//
//  MedicationsView.swift
//  HealthPal
//
//  Placeholder for medication management view
//

import SwiftUI

struct MedicationsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "pills.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.blue)
                
                Text("Medication Management")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Add and manage your medications here. This feature is coming soon!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Medications")
        }
    }
}

#Preview {
    MedicationsView()
}