//
//  HealthPalApp.swift
//  HealthPal
//
//  Created by STIJN OVERWATER on 25/07/2025.
//

import SwiftUI
import SwiftData

@main
struct HealthPalApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Medication.self,
            ReminderTime.self,
            SymptomEntry.self,
            AdherenceLog.self,
            SnoozeEntry.self,
            UserPreferences.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
