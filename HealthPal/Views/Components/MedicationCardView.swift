//
//  MedicationCardView.swift
//  HealthPal
//
//  Individual medication card with patient-centric interactions
//  Large touch targets, clear status, and flexible options for difficult days
//

import SwiftUI
import SwiftData
import OSLog

struct MedicationCardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userPreferences: [UserPreferences]

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "HealthPal",
        category: "MedicationCardView"
    )
    
    let medication: Medication
    let reminderTime: ReminderTime
    let adherenceLog: AdherenceLog?
    
    @State private var showingSnoozeOptions = false
    @State private var showingMissedReasonSheet = false
    @State private var showingDelayReasonSheet = false
    
    private var preferences: UserPreferences {
        userPreferences.first ?? UserPreferences()
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with medication info
            medicationHeader
            
            // Status and action buttons
            actionSection
            
            // Additional info if delayed or missed
            if let log = adherenceLog, log.status != .pending && log.status != .taken {
                statusDetails
            }
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .sheet(isPresented: $showingSnoozeOptions) {
            SnoozeOptionsView(
                medication: medication,
                reminderTime: reminderTime,
                onSnooze: handleSnooze
            )
        }
        .sheet(isPresented: $showingMissedReasonSheet) {
            MissedReasonView(
                medication: medication,
                onMissed: handleMissed
            )
        }
        .sheet(isPresented: $showingDelayReasonSheet) {
            DelayReasonView(
                medication: medication,
                onDelay: handleDelay
            )
        }
    }
    
    // MARK: - View Components
    
    private var medicationHeader: some View {
        HStack(spacing: 12) {
            // Medication icon
            ZStack {
                Circle()
                    .fill(Color(medication.color).opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Image(systemName: medication.shape.systemImage)
                    .font(.title2)
                    .foregroundColor(Color(medication.color))
            }
            
            // Medication details
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(medication.dosage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(reminderTime.timeString)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Status indicator
            statusIndicator
        }
    }
    
    private var statusIndicator: some View {
        Group {
            if let log = adherenceLog {
                statusBadge(for: log.status)
            } else {
                statusBadge(for: .pending)
            }
        }
    }
    
    private func statusBadge(for status: AdherenceStatus) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color(status.color))
                .frame(width: 8, height: 8)
            
            Text(status.displayName)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(status.color).opacity(0.1))
        .cornerRadius(8)
    }
    
    private var actionSection: some View {
        HStack(spacing: 12) {
            if let log = adherenceLog {
                switch log.status {
                case .pending, .snoozed:
                    pendingActions
                case .taken:
                    takenActions
                case .missed:
                    missedActions
                case .skipped:
                    skippedActions
                }
            } else {
                pendingActions
            }
        }
    }
    
    private var pendingActions: some View {
        HStack(spacing: 12) {
            // Primary action - Take medication
            Button(action: markAsTaken) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Taken")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            // Secondary actions
            if medication.allowSnooze {
                Button(action: { showingSnoozeOptions = true }) {
                    HStack {
                        Image(systemName: "clock")
                        Text("Snooze")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.orange.opacity(0.1))
                    .foregroundColor(.orange)
                    .cornerRadius(12)
                }
            }
            
            Button(action: { showingMissedReasonSheet = true }) {
                HStack {
                    Image(systemName: "xmark.circle")
                    Text("Skip")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
                .cornerRadius(12)
            }
        }
    }
    
    private var takenActions: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            
            VStack(alignment: .leading) {
                Text("Medication taken")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if let log = adherenceLog, let takenTime = log.actualTakenTime {
                    Text("at \(takenTime, formatter: timeFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if preferences.enableEncouragingMessages {
                Text("Great job! 💙")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var missedActions: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                
                Text("Medication missed")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button("Take Now") {
                    markAsTaken()
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            if let log = adherenceLog, let reason = log.missReason {
                Text("Reason: \(reason.displayName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var skippedActions: some View {
        HStack {
            Image(systemName: "minus.circle.fill")
                .foregroundColor(.gray)
            
            Text("Intentionally skipped")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private var statusDetails: some View {
        Group {
            if let log = adherenceLog {
                VStack(alignment: .leading, spacing: 4) {
                    if log.snoozeCount > 0 {
                        Text("Snoozed \(log.snoozeCount) time(s)")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    
                    if let notes = log.notes, !notes.isEmpty {
                        Text("Note: \(notes)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if log.status == .taken && !log.isOnTime {
                        Text("Taken \(log.totalDelayMinutes) minutes late")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var cardBackground: Color {
        if let log = adherenceLog {
            switch log.status {
            case .taken:
                return Color.green.opacity(0.05)
            case .missed:
                return Color.red.opacity(0.05)
            case .snoozed:
                return Color.orange.opacity(0.05)
            case .pending:
                return Color(.systemBackground)
            case .skipped:
                return Color.gray.opacity(0.05)
            }
        }
        return Color(.systemBackground)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    // MARK: - Actions
    
    private func markAsTaken() {
        let log = getOrCreateAdherenceLog()
        log.markAsTaken(at: Date(), method: .quickTap)
        
        // Haptic feedback if enabled
        if preferences.enableHapticFeedback {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
        
        try? modelContext.save()
    }
    
    private func handleSnooze(duration: Int, reason: DelayReason?) {
        let log = getOrCreateAdherenceLog()
        log.addSnooze(duration: duration, reason: reason)
        
        try? modelContext.save()
        showingSnoozeOptions = false
        
        // Schedule new notification (would be implemented with NotificationCenter)
        scheduleSnoozeNotification(duration: duration)
    }
    
    private func handleMissed(reason: MissReason, notes: String?) {
        let log = getOrCreateAdherenceLog()
        log.markAsMissed(reason: reason, notes: notes)
        
        try? modelContext.save()
        showingMissedReasonSheet = false
    }
    
    private func handleDelay(reason: DelayReason) {
        showingDelayReasonSheet = false
        showingSnoozeOptions = true
    }
    
    private func getOrCreateAdherenceLog() -> AdherenceLog {
        if let existing = adherenceLog {
            return existing
        } else {
            let today = Date()
            let scheduledTime = Calendar.current.date(
                bySettingHour: reminderTime.hour,
                minute: reminderTime.minute,
                second: 0,
                of: today
            ) ?? today
            
            let newLog = AdherenceLog(
                medicationId: medication.id,
                scheduledDate: Calendar.current.startOfDay(for: today),
                scheduledTime: scheduledTime
            )
            
            modelContext.insert(newLog)
            return newLog
        }
    }
    
    private func scheduleSnoozeNotification(duration: Int) {
        // This would integrate with UNUserNotificationCenter
        // For now, just a placeholder
        logger.debug("Scheduling snooze notification for \(duration) minutes")
    }
}

#Preview {
    let medication = Medication(
        name: "Metformin",
        dosage: "500mg",
        instructions: "Take with food"
    )
    
    let reminderTime = ReminderTime(hour: 8, minute: 0)
    
    return MedicationCardView(
        medication: medication,
        reminderTime: reminderTime,
        adherenceLog: nil
    )
    .padding()
    .modelContainer(for: [Medication.self, AdherenceLog.self, UserPreferences.self], inMemory: true)
}