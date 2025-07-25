//
//  ProgressView.swift
//  HealthPal
//
//  Progress and history view with patient-centric insights
//

import SwiftUI
import SwiftData

struct ProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var adherenceLogs: [AdherenceLog]
    @Query private var symptomEntries: [SymptomEntry]
    @Query private var userPreferences: [UserPreferences]
    
    private var preferences: UserPreferences {
        userPreferences.first ?? UserPreferences()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Weekly adherence overview
                    weeklyAdherenceSection
                    
                    // Symptom trends
                    if !symptomEntries.isEmpty {
                        symptomTrendsSection
                    }
                    
                    // Insights and patterns
                    insightsSection
                }
                .padding()
            }
            .navigationTitle("My Progress")
        }
    }
    
    private var weeklyAdherenceSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("This Week")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if adherenceLogs.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No data yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Start taking your medications to see progress here")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(24)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            } else {
                // Placeholder for adherence chart
                VStack(spacing: 12) {
                    Text("Adherence Rate")
                        .font(.headline)
                    
                    Text("85%")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.green)
                    
                    Text("Great job this week!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(24)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
    
    private var symptomTrendsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Symptom Trends")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            // Placeholder for symptom trends
            VStack(spacing: 12) {
                Text("Weekly Average")
                    .font(.headline)
                
                HStack(spacing: 20) {
                    TrendIndicator(title: "Pain", value: "2.3", trend: .down, color: .red)
                    TrendIndicator(title: "Fatigue", value: "3.1", trend: .stable, color: .orange)
                    TrendIndicator(title: "Mood", value: "3.8", trend: .up, color: .blue)
                }
            }
            .padding(24)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var insightsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Insights")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(spacing: 12) {
                InsightCard(
                    icon: "lightbulb.fill",
                    title: "Pattern Detected",
                    description: "You tend to feel better on days when you take your morning medication on time.",
                    color: .yellow
                )
                
                InsightCard(
                    icon: "heart.fill",
                    title: "Wellness Tip",
                    description: "Your mood scores are highest on weekends. Consider what makes those days special.",
                    color: .pink
                )
            }
        }
    }
}

struct TrendIndicator: View {
    let title: String
    let value: String
    let trend: Trend
    let color: Color
    
    enum Trend {
        case up, down, stable
        
        var icon: String {
            switch self {
            case .up: return "arrow.up.circle.fill"
            case .down: return "arrow.down.circle.fill"
            case .stable: return "minus.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .up: return .green
            case .down: return .red
            case .stable: return .gray
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            Image(systemName: trend.icon)
                .font(.caption)
                .foregroundColor(trend.color)
        }
        .frame(maxWidth: .infinity)
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    ProgressView()
        .modelContainer(for: [AdherenceLog.self, SymptomEntry.self, UserPreferences.self], inMemory: true)
}