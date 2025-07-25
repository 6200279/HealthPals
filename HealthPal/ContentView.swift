//
//  ContentView.swift
//  HealthPal
//
//  Main entry point - now using patient-centric MainTabView architecture
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            Medication.self,
            SymptomEntry.self,
            AdherenceLog.self,
            UserPreferences.self
        ], inMemory: true)
}
