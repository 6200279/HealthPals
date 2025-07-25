//
//  TodayView.swift
//  HealthPal
//
//  Today's medications view - primary interface for daily medication management
//  Designed with cognitive load reduction and accessibility in mind
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var medications: [Medication]
    @Query private var adherenceLogs: [AdherenceLog]
    @Query private var userPreferences: [UserPreferences]
    
    @State private var showingSymptomCheck = false
    @State private var currentTime = Date()
    
    // Timer to update current time
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    private var preferences: UserPreferences {
        userPreferences.first ?? UserPreferences()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Compassionate greeting
                    greetingSection
                    
                    // Quick symptom check prompt (if enabled)
                    if preferences.enableDailySymptomCheck && !hasLoggedSymptomsToday {
                        symptomCheckPrompt
                    }
                    
                    // Today's medications
                    medicationsSection
                    
                    // Encouraging message or streak
                    if preferences.enableEncouragingMessages {
                        encouragementSection
                    }
                }
                .padding()
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .onReceive(timer) { _ in
                currentTime = Date()
            }
            .sheet(isPresented: $showingSymptomCheck) {
                QuickSymptomCheckView()
            }
        }
    }
    
    // MARK: - View Components
    
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(greetingText)
                    .font(.title2)
                    .fontWeight(.medium)
                Spacer()
                Text(currentTime, style: .time)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(motivationalMessage)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var symptomCheckPrompt: some View {
        Button(action: { showingSymptomCheck = true }) {
            HStack {
                Image(systemName: "heart.circle.fill")
                    .foregroundColor(.pink)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text("How are you feeling today?")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Quick 30-second check-in")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.pink.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var medicationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Medications")
                .font(.headline)
                .padding(.horizontal)
            
            if todaysMedications.isEmpty {
                emptyMedicationsView
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(todaysMedications, id: \.medication.id) { item in
                        MedicationCardView(
                            medication: item.medication,
                            reminderTime: item.reminderTime,
                            adherenceLog: item.adherenceLog
                        )
                    }
                }
            }
        }
    }
    
    private var emptyMedicationsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "pills")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No medications scheduled for today")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Tap the + button to add your first medication")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var encouragementSection: some View {
        VStack(spacing: 8) {
            if preferences.showStreakCounter {
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(adherenceStreak) day streak!")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                }
            }
            
            Text(encouragingMessage)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Computed Properties
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good night"
        }
    }
    
    private var motivationalMessage: String {
        let messages = [
            "Taking care of yourself is important.",
            "Every step counts in your health journey.",
            "You're doing great managing your health.",
            "Today is a new opportunity to feel better."
        ]
        return messages.randomElement() ?? messages[0]
    }
    
    private var encouragingMessage: String {
        let messages = [
            "You're taking great care of yourself! 💙",
            "Keep up the excellent work with your medications.",
            "Your consistency is making a difference.",
            "Every dose taken is a step toward better health."
        ]
        return messages.randomElement() ?? messages[0]
    }
    
    private var hasLoggedSymptomsToday: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return adherenceLogs.contains { log in
            Calendar.current.isDate(log.loggedTime, inSameDayAs: today)
        }
    }
    
    private var adherenceStreak: Int {
        // Calculate consecutive days of good adherence
        // This is a simplified calculation - would be more sophisticated in production
        let recentLogs = adherenceLogs
            .filter { $0.status == .taken }
            .sorted { $0.scheduledDate > $1.scheduledDate }
        
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        for log in recentLogs {
            let logDate = Calendar.current.startOfDay(for: log.scheduledDate)
            if Calendar.current.isDate(logDate, inSameDayAs: currentDate) {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    private var todaysMedications: [(medication: Medication, reminderTime: ReminderTime, adherenceLog: AdherenceLog?)] {
        let today = Date()
        var results: [(medication: Medication, reminderTime: ReminderTime, adherenceLog: AdherenceLog?)] = []
        
        for medication in medications.filter({ $0.isActive }) {
            for reminderTime in medication.reminderTimes.filter({ $0.isEnabled }) {
                // Check if this medication should be taken today based on schedule
                if shouldTakeMedicationToday(medication: medication, reminderTime: reminderTime, date: today) {
                    let log = findAdherenceLog(medicationId: medication.id, reminderTime: reminderTime, date: today)
                    results.append((medication: medication, reminderTime: reminderTime, adherenceLog: log))
                }
            }
        }
        
        return results.sorted { first, second in
            let firstTime = Calendar.current.date(bySettingHour: first.reminderTime.hour, 
                                                minute: first.reminderTime.minute, 
                                                second: 0, of: today) ?? today
            let secondTime = Calendar.current.date(bySettingHour: second.reminderTime.hour, 
                                                 minute: second.reminderTime.minute, 
                                                 second: 0, of: today) ?? today
            return firstTime < secondTime
        }
    }
    
    // MARK: - Helper Methods
    
    private func shouldTakeMedicationToday(medication: Medication, reminderTime: ReminderTime, date: Date) -> Bool {
        let weekday = Calendar.current.component(.weekday, from: date)
        
        switch medication.scheduleType {
        case .daily:
            return true
        case .weekdays:
            return weekday >= 2 && weekday <= 6 // Monday to Friday
        case .weekends:
            return weekday == 1 || weekday == 7 // Saturday and Sunday
        case .custom:
            return reminderTime.customDays?.contains(weekday) ?? false
        case .asNeeded:
            return false // PRN medications don't have scheduled times
        }
    }
    
    private func findAdherenceLog(medicationId: UUID, reminderTime: ReminderTime, date: Date) -> AdherenceLog? {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let scheduledTime = Calendar.current.date(bySettingHour: reminderTime.hour, 
                                                minute: reminderTime.minute, 
                                                second: 0, of: startOfDay) ?? startOfDay
        
        return adherenceLogs.first { log in
            log.medicationId == medicationId && 
            Calendar.current.isDate(log.scheduledTime, equalTo: scheduledTime, toGranularity: .minute)
        }
    }
}

#Preview {
    TodayView()
        .modelContainer(for: [Medication.self, AdherenceLog.self, UserPreferences.self], inMemory: true)
}