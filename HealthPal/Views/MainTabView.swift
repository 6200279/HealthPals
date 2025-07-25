//
//  MainTabView.swift
//  HealthPal
//
//  Main navigation with patient-centric design and accessibility focus
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userPreferences: [UserPreferences]
    
    // Get or create user preferences
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
        TabView {
            // Today's Medications - Primary focus
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "house.fill")
                }
            
            // Medication Management
            MedicationsView()
                .tabItem {
                    Label("Medications", systemImage: "pills.fill")
                }
            
            // Symptom Tracking
            SymptomsView()
                .tabItem {
                    Label("How I Feel", systemImage: "heart.fill")
                }
            
            // Progress & History
            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            // Settings & Preferences
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .preferredColorScheme(colorScheme)
        .dynamicTypeSize(textSize)
    }
    
    // Accessibility helpers based on user preferences
    private var colorScheme: ColorScheme? {
        switch preferences.preferredColorScheme {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        case .highContrast: return .dark // Will be enhanced with high contrast colors
        }
    }
    
    private var textSize: DynamicTypeSize {
        preferences.useLargeText ? .accessibility1 : .large
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [Medication.self, UserPreferences.self], inMemory: true)
}