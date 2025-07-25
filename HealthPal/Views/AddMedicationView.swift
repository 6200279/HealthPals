import SwiftUI
import SwiftData

/// Form for creating a new medication record.
struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    // MARK: - Form Fields
    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var instructions: String = ""
    @State private var scheduleType: ScheduleType = .daily
    @State private var reminderTime: Date = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var selectedColor: String = "blue"
    @State private var selectedShape: MedicationShape = .pill

    private let availableColors = ["blue", "red", "green", "orange", "purple"]

    var body: some View {
        NavigationView {
            Form {
                detailsSection
                appearanceSection
                scheduleSection
                saveSection
            }
            .navigationTitle("New Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    // MARK: - Sections
    private var detailsSection: some View {
        Section("Details") {
            TextField("Name", text: $name)
            TextField("Dosage", text: $dosage)
            TextField("Instructions", text: $instructions)
        }
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            Picker("Shape", selection: $selectedShape) {
                ForEach(MedicationShape.allCases, id: \.self) { shape in
                    Text(shape.rawValue.capitalized).tag(shape)
                }
            }
            Picker("Color", selection: $selectedColor) {
                ForEach(availableColors, id: \.self) { color in
                    Text(color.capitalized).tag(color)
                }
            }
        }
    }

    private var scheduleSection: some View {
        Section("Schedule") {
            Picker("Type", selection: $scheduleType) {
                ForEach(ScheduleType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            if scheduleType != .asNeeded {
                DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
            }
        }
    }

    private var saveSection: some View {
        Section {
            Button("Save", action: saveMedication)
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                          dosage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }

    // MARK: - Persistence
    private func saveMedication() {
        var reminders: [ReminderTime] = []
        if scheduleType != .asNeeded {
            let hour = Calendar.current.component(.hour, from: reminderTime)
            let minute = Calendar.current.component(.minute, from: reminderTime)
            reminders.append(ReminderTime(hour: hour, minute: minute))
        }
        let medication = Medication(
            name: name,
            dosage: dosage,
            instructions: instructions,
            scheduleType: scheduleType,
            reminderTimes: reminders,
            isAsNeeded: scheduleType == .asNeeded,
            color: selectedColor,
            shape: selectedShape
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
