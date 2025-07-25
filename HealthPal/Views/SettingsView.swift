//
//  SettingsView.swift
//  HealthPal
//
//  Settings and preferences with patient-centric privacy controls
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userPreferences: [UserPreferences]
    
    private var preferences: UserPreferences {
        if let existing = userPreferences.first {
            return existing
        } else {
            let newPrefs = UserPreferences()
            modelContext.insert(newPrefs)
            return newPrefs
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                // Accessibility Section
                Section("Accessibility") {
                    Toggle("Large Text", isOn: Binding(
                        get: { preferences.useLargeText },
                        set: { preferences.useLargeText = $0 }
                    ))
                    
                    Toggle("High Contrast", isOn: Binding(
                        get: { preferences.useHighContrast },
                        set: { preferences.useHighContrast = $0 }
                    ))
                    
                    Toggle("Haptic Feedback", isOn: Binding(
                        get: { preferences.enableHapticFeedback },
                        set: { preferences.enableHapticFeedback = $0 }
                    ))
                    
                    Picker("Color Scheme", selection: Binding(
                        get: { preferences.preferredColorScheme },
                        set: { preferences.preferredColorScheme = $0 }
                    )) {
                        ForEach(ColorScheme.allCases, id: \.self) { scheme in
                            Text(scheme.displayName).tag(scheme)
                        }
                    }
                }
                
                // Notifications Section
                Section("Notifications") {
                    Toggle("Push Notifications", isOn: Binding(
                        get: { preferences.enablePushNotifications },
                        set: { preferences.enablePushNotifications = $0 }
                    ))
                    
                    Toggle("Gentle Reminders", isOn: Binding(
                        get: { preferences.enableGentleNudges },
                        set: { preferences.enableGentleNudges = $0 }
                    ))
                    
                    Picker("Reminder Tone", selection: Binding(
                        get: { preferences.reminderTone },
                        set: { preferences.reminderTone = $0 }
                    )) {
                        ForEach(ReminderTone.allCases, id: \.self) { tone in
                            Text(tone.displayName).tag(tone)
                        }
                    }
                    
                    Picker("Sound Level", selection: Binding(
                        get: { preferences.reminderSoundLevel },
                        set: { preferences.reminderSoundLevel = $0 }
                    )) {
                        ForEach(SoundLevel.allCases, id: \.self) { level in
                            Text(level.displayName).tag(level)
                        }
                    }
                }
                
                // Privacy Section
                Section("Privacy & Data") {
                    Toggle("Share with Healthcare Provider", isOn: Binding(
                        get: { preferences.shareDataWithProvider },
                        set: { preferences.shareDataWithProvider = $0 }
                    ))
                    
                    if preferences.shareDataWithProvider {
                        Picker("Provider Access Level", selection: Binding(
                            get: { preferences.providerAccessLevel },
                            set: { preferences.providerAccessLevel = $0 }
                        )) {
                            ForEach(ProviderAccessLevel.allCases, id: \.self) { level in
                                VStack(alignment: .leading) {
                                    Text(level.displayName)
                                    Text(level.description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .tag(level)
                            }
                        }
                    }
                    
                    Toggle("Enable Data Export", isOn: Binding(
                        get: { preferences.allowDataExport },
                        set: { preferences.allowDataExport = $0 }
                    ))
                    
                    Toggle("Offline Mode", isOn: Binding(
                        get: { preferences.enableOfflineMode },
                        set: { preferences.enableOfflineMode = $0 }
                    ))
                }
                
                // Wellness Tracking Section
                Section("Wellness Tracking") {
                    Toggle("Daily Symptom Check-in", isOn: Binding(
                        get: { preferences.enableDailySymptomCheck },
                        set: { preferences.enableDailySymptomCheck = $0 }
                    ))
                    
                    Toggle("Track Pain Levels", isOn: Binding(
                        get: { preferences.trackPainLevels },
                        set: { preferences.trackPainLevels = $0 }
                    ))
                    
                    Toggle("Track Fatigue Levels", isOn: Binding(
                        get: { preferences.trackFatigueLevels },
                        set: { preferences.trackFatigueLevels = $0 }
                    ))
                    
                    Toggle("Track Mood Levels", isOn: Binding(
                        get: { preferences.trackMoodLevels },
                        set: { preferences.trackMoodLevels = $0 }
                    ))
                }
                
                // Support Section
                Section("Support") {
                    Toggle("Encouraging Messages", isOn: Binding(
                        get: { preferences.enableEncouragingMessages },
                        set: { preferences.enableEncouragingMessages = $0 }
                    ))
                    
                    Toggle("Show Progress Streaks", isOn: Binding(
                        get: { preferences.showStreakCounter },
                        set: { preferences.showStreakCounter = $0 }
                    ))
                    
                    NavigationLink("Emergency Contacts") {
                        EmergencyContactsView()
                    }
                    
                    NavigationLink("About HealthPal") {
                        AboutView()
                    }
                }
                
                // Data Management Section
                Section("Data Management") {
                    Button("Export My Data") {
                        // Export functionality
                    }
                    .foregroundColor(.blue)
                    
                    Button("Clear All Data") {
                        // Clear data functionality
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// Placeholder views for navigation
struct EmergencyContactsView: View {
    var body: some View {
        Text("Emergency Contacts")
            .navigationTitle("Emergency Contacts")
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
                .foregroundColor(.pink)
            
            Text("HealthPal")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Version 1.0")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("A patient-centric medication management app designed with compassion for those managing chronic conditions.")
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("About")
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [UserPreferences.self], inMemory: true)
}