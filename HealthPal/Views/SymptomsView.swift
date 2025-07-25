//
//  SymptomsView.swift
//  HealthPal
//
//  Symptom tracking interface with patient-centric design
//

import SwiftUI
import SwiftData

struct SymptomsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var symptomEntries: [SymptomEntry]
    @Query private var userPreferences: [UserPreferences]
    
    @State private var showingDailyCheckIn = false
    
    private var preferences: UserPreferences {
        userPreferences.first ?? UserPreferences()
    }
    
    private var todayEntry: SymptomEntry? {
        let today = Calendar.current.startOfDay(for: Date())
        return symptomEntries.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Today's check-in section
                todayCheckInSection
                
                // Recent entries
                if !symptomEntries.isEmpty {
                    recentEntriesSection
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("How I Feel")
            .sheet(isPresented: $showingDailyCheckIn) {
                DailyCheckInView()
            }
        }
    }
    
    private var todayCheckInSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today's Check-in")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if let entry = todayEntry {
                // Show today's entry
                TodaySymptomCard(entry: entry)
            } else {
                // Prompt for check-in
                Button(action: { showingDailyCheckIn = true }) {
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.pink)
                        
                        Text("How are you feeling today?")
                            .font(.headline)
                        
                        Text("Quick check-in • 30 seconds")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var recentEntriesSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recent Entries")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            LazyVStack(spacing: 12) {
                ForEach(symptomEntries.prefix(5)) { entry in
                    SymptomEntryRow(entry: entry)
                }
            }
        }
    }
}

struct TodaySymptomCard: View {
    let entry: SymptomEntry
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today's Entry")
                    .font(.headline)
                Spacer()
                Text("✓ Completed")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            HStack(spacing: 20) {
                if let pain = entry.painLevel {
                    SymptomIndicator(
                        title: "Pain",
                        level: pain,
                        color: .red,
                        icon: "bolt.fill"
                    )
                }
                
                if let fatigue = entry.fatigueLevel {
                    SymptomIndicator(
                        title: "Fatigue",
                        level: fatigue,
                        color: .orange,
                        icon: "battery.25"
                    )
                }
                
                if let mood = entry.moodLevel {
                    SymptomIndicator(
                        title: "Mood",
                        level: mood,
                        color: .blue,
                        icon: "face.smiling"
                    )
                }
            }
            
            if let notes = entry.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SymptomIndicator: View {
    let title: String
    let level: Int
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            
            Text("\(level)/5")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SymptomEntryRow: View {
    let entry: SymptomEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack(spacing: 12) {
                    if let pain = entry.painLevel {
                        Text("Pain: \(pain)/5")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    if let fatigue = entry.fatigueLevel {
                        Text("Fatigue: \(fatigue)/5")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    if let mood = entry.moodLevel {
                        Text("Mood: \(mood)/5")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Spacer()
            
            if let wellness = entry.overallWellness {
                Text(String(format: "%.1f", wellness))
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// Placeholder for Daily Check-in View
struct DailyCheckInView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Daily Check-in")
                    .font(.title)
                    .padding()
                
                Text("Symptom tracking form will be implemented in Phase 4")
                    .foregroundColor(.secondary)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("How I Feel")
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
    SymptomsView()
        .modelContainer(for: [SymptomEntry.self, UserPreferences.self], inMemory: true)
}