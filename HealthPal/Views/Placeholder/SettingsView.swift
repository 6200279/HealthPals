//
//  SettingsView.swift
//  HealthPal
//
//  Placeholder for settings view
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "gear")
                    .font(.system(size: 64))
                    .foregroundColor(.gray)
                
                Text("Settings")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Customize your HealthPal experience, privacy settings, and accessibility options here. This feature is coming soon!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}