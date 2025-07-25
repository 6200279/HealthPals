//
//  SymptomsView.swift
//  HealthPal
//
//  Placeholder for symptoms tracking view
//

import SwiftUI

struct SymptomsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.pink)
                
                Text("Symptom Tracking")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("View your symptom history and patterns here. This feature is coming soon!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("How I Feel")
        }
    }
}

#Preview {
    SymptomsView()
}