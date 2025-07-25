//
//  SnoozeOptionsView.swift
//  HealthPal
//
//  Snooze options sheet with patient-centric flexibility for difficult days
//

import SwiftUI

struct SnoozeOptionsView: View {
    let medication: Medication
    let reminderTime: ReminderTime
    let onSnooze: (Int, DelayReason?) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDuration: Int = 15
    @State private var selectedReason: DelayReason?
    @State private var showingReasonPicker = false
    
    private let snoozeOptions = [15, 30, 60, 120] // minutes
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header with compassionate messaging
                headerSection
                
                // Duration selection
                durationSection
                
                // Optional reason selection
                reasonSection
                
                Spacer()
                
                // Action buttons
                actionButtons
            }
            .padding()
            .navigationTitle("Snooze Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Take a moment")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("It's okay if you can't take your medication right now. Choose when you'd like to be reminded again.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Remind me again in:")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(snoozeOptions, id: \.self) { duration in
                    Button(action: { selectedDuration = duration }) {
                        VStack(spacing: 8) {
                            Text("\(duration)")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(duration == 1 ? "minute" : "minutes")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            selectedDuration == duration ? 
                            Color.orange : Color(.systemGray6)
                        )
                        .foregroundColor(
                            selectedDuration == duration ? 
                            .white : .primary
                        )
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var reasonSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Why are you delaying? (Optional)")
                .font(.headline)
            
            Text("This helps us understand your patterns and provide better support.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button(action: { showingReasonPicker = true }) {
                HStack {
                    Text(selectedReason?.displayName ?? "Select a reason")
                        .foregroundColor(selectedReason == nil ? .secondary : .primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .sheet(isPresented: $showingReasonPicker) {
                DelayReasonPickerView(selectedReason: $selectedReason)
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: confirmSnooze) {
                Text("Set Reminder")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.orange)
                    .cornerRadius(12)
            }
            
            Button("Cancel") {
                dismiss()
            }
            .font(.body)
            .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Actions
    
    private func confirmSnooze() {
        onSnooze(selectedDuration, selectedReason)
        dismiss()
    }
}

// MARK: - Supporting Views

struct DelayReasonPickerView: View {
    @Binding var selectedReason: DelayReason?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(DelayReason.allCases, id: \.self) { reason in
                        Button(action: {
                            selectedReason = reason
                            dismiss()
                        }) {
                            HStack {
                                Text(reason.displayName)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if selectedReason == reason {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Why are you delaying this medication?")
                } footer: {
                    Text("This information helps us understand your medication patterns and provide better support. It's completely optional and private.")
                }
                
                Section {
                    Button("No specific reason") {
                        selectedReason = nil
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Delay Reason")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let medication = Medication(
        name: "Metformin",
        dosage: "500mg"
    )
    
    let reminderTime = ReminderTime(hour: 8, minute: 0)
    
    return SnoozeOptionsView(
        medication: medication,
        reminderTime: reminderTime,
        onSnooze: { duration, reason in
            print("Snoozed for \(duration) minutes, reason: \(reason?.displayName ?? "none")")
        }
    )
}