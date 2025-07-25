//
//  QuickSymptomCheckView.swift
//  HealthPal
//
//  Quick daily symptom check-in with minimal cognitive load
//

import SwiftUI
import SwiftData
import OSLog

struct QuickSymptomCheckView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "HealthPal",
        category: "QuickSymptomCheckView"
    )
    
    @State private var painLevel: Int = 3
    @State private var fatigueLevel: Int = 3
    @State private var moodLevel: Int = 3
    @State private var notes: String = ""
    @State private var selectedTriggers: Set<String> = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Pain level
                    symptomSlider(
                        title: "Pain Level",
                        value: $painLevel,
                        icon: "bolt.fill",
                        color: .red,
                        descriptions: (1...5).map { SymptomLevels.painDescription(level: $0) }
                    )
                    
                    // Fatigue level
                    symptomSlider(
                        title: "Energy Level",
                        value: $fatigueLevel,
                        icon: "battery.100",
                        color: .orange,
                        descriptions: (1...5).map { SymptomLevels.fatigueDescription(level: $0) }
                    )
                    
                    // Mood level
                    symptomSlider(
                        title: "Mood",
                        value: $moodLevel,
                        icon: "heart.fill",
                        color: .pink,
                        descriptions: (1...5).map { SymptomLevels.moodDescription(level: $0) }
                    )
                    
                    // Optional triggers
                    triggersSection
                    
                    // Optional notes
                    notesSection
                    
                    // Action buttons
                    actionButtons
                }
                .padding()
            }
            .navigationTitle("How are you feeling?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Skip") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.pink)
            
            Text("Quick Check-in")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("This takes just 30 seconds and helps track your patterns over time.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private func symptomSlider(
        title: String,
        value: Binding<Int>,
        icon: String,
        color: Color,
        descriptions: [String]
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            
            VStack(spacing: 12) {
                // Current description
                Text(descriptions[value.wrappedValue - 1])
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(height: 20)
                
                // Slider
                HStack {
                    Text("1")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Slider(value: Binding(
                        get: { Double(value.wrappedValue) },
                        set: { value.wrappedValue = Int($0.rounded()) }
                    ), in: 1...5, step: 1)
                    .accentColor(color)
                    
                    Text("5")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Visual indicators
                HStack {
                    ForEach(1...5, id: \.self) { level in
                        Circle()
                            .fill(level <= value.wrappedValue ? color : Color(.systemGray4))
                            .frame(width: 12, height: 12)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var triggersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Any triggers today? (Optional)")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(SymptomTriggers.common, id: \.self) { trigger in
                    Button(action: {
                        if selectedTriggers.contains(trigger) {
                            selectedTriggers.remove(trigger)
                        } else {
                            selectedTriggers.insert(trigger)
                        }
                    }) {
                        Text(trigger)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                selectedTriggers.contains(trigger) ?
                                Color.blue : Color(.systemGray6)
                            )
                            .foregroundColor(
                                selectedTriggers.contains(trigger) ?
                                .white : .primary
                            )
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Additional notes (Optional)")
                .font(.headline)
            
            TextField("How are you feeling today? Any concerns?", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: saveSymptomEntry) {
                Text("Save Check-in")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.pink)
                    .cornerRadius(12)
            }
            
            Button("Skip for today") {
                dismiss()
            }
            .font(.body)
            .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Actions
    
    private func saveSymptomEntry() {
        let entry = SymptomEntry(
            painLevel: painLevel,
            fatigueLevel: fatigueLevel,
            moodLevel: moodLevel,
            notes: notes.isEmpty ? nil : notes,
            triggers: Array(selectedTriggers),
            entryMethod: .manual
        )
        
        modelContext.insert(entry)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            logger.error("Error saving symptom entry: \(error.localizedDescription)")
        }
    }
}

#Preview {
    QuickSymptomCheckView()
        .modelContainer(for: SymptomEntry.self, inMemory: true)
}