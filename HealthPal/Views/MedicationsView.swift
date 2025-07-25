//
//  MedicationsView.swift
//  HealthPal
//
//  Medication management interface with patient-centric design
//

import SwiftUI
import SwiftData

struct MedicationsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var medications: [Medication]
    @Query private var userPreferences: [UserPreferences]
    
    @State private var showingAddMedication = false
    
    private var preferences: UserPreferences {
        userPreferences.first ?? UserPreferences()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if medications.isEmpty {
                    emptyStateView
                } else {
                    medicationsList
                }
            }
            .navigationTitle("My Medications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddMedication = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .accessibilityLabel("Add new medication")
                    }
                }
            }
            .sheet(isPresented: $showingAddMedication) {
                AddMedicationView()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "pills.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("No Medications Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add your first medication to get started with reminders and tracking.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button(action: { showingAddMedication = true }) {
                Label("Add Medication", systemImage: "plus")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .accessibilityLabel("Add your first medication")
        }
        .padding()
    }
    
    private var medicationsList: some View {
        List {
            ForEach(medications.filter { $0.isActive }) { medication in
                MedicationRowView(medication: medication)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct MedicationRowView: View {
    let medication: Medication
    
    var body: some View {
        HStack(spacing: 16) {
            // Medication icon
            Image(systemName: medication.shape.systemImage)
                .font(.title2)
                .foregroundColor(Color(medication.color))
                .frame(width: 40, height: 40)
                .background(Color(medication.color).opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name)
                    .font(.headline)
                
                Text(medication.dosage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if !medication.instructions.isEmpty {
                    Text(medication.instructions)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(medication.scheduleType.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(medication.reminderTimes.count) reminders")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

// Placeholder for Add Medication View
struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add Medication")
                    .font(.title)
                    .padding()
                
                Text("Medication form will be implemented in the next phase")
                    .foregroundColor(.secondary)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("New Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MedicationsView()
        .modelContainer(for: [Medication.self, UserPreferences.self], inMemory: true)
}