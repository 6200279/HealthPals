//
//  ProgressView.swift
//  HealthPal
//
//  Placeholder for progress tracking view
//

import SwiftUI

struct ProgressView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 64))
                    .foregroundColor(.green)
                
                Text("Progress Tracking")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("See your medication adherence trends and health progress here. This feature is coming soon!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Progress")
        }
    }
}

#Preview {
    ProgressView()
}