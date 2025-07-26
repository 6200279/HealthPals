import SwiftUI
import SwiftData

struct AddMedicationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var instructions: String = ""
    @State private var scheduleType: ScheduleType = .daily
    @State private var reminderDate: Date = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date()

    var body: some View {
        NavigationView {
            Form {
                Section("Medication") {
                    TextField("Name", text: $name)
                    TextField("Dosage", text: $dosage)
                    TextField("Instructions", text: $instructions, axis: .vertical)
                        .lineLimit(1...4)
                }

                Section("Schedule") {
                    Picker("Type", selection: $scheduleType) {
                        ForEach(ScheduleType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    DatePicker("Reminder Time", selection: $reminderDate, displayedComponents: .hourAndMinute)
                }
            }
            .navigationTitle("New Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save", action: addMedication)
                        .disabled(name.isEmpty || dosage.isEmpty)
                }
            }
        }
    }

    private func addMedication() {
        let comps = Calendar.current.dateComponents([.hour, .minute], from: reminderDate)
        let time = ReminderTime(hour: comps.hour ?? 8, minute: comps.minute ?? 0)
        let medication = Medication(
            name: name,
            dosage: dosage,
            instructions: instructions,
            scheduleType: scheduleType,
            reminderTimes: [time]
        )
        modelContext.insert(medication)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving medication: \(error)")
        }
    }
}

#Preview {
    AddMedicationView()
        .modelContainer(for: [Medication.self, ReminderTime.self], inMemory: true)
}
