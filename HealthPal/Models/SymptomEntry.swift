//
//  SymptomEntry.swift
//  HealthPal
//
//  Lightweight symptom tracking model for chronic illness patients
//

import Foundation
import SwiftData

@Model
final class SymptomEntry {
    var id: UUID
    var date: Date
    var timestamp: Date
    
    // Core symptom tracking (1-5 scale as requested in PRD)
    var painLevel: Int? // 1 = minimal, 5 = severe
    var fatigueLevel: Int? // 1 = energetic, 5 = exhausted
    var moodLevel: Int? // 1 = very low, 5 = very good
    
    // Optional context for patients who want to add more detail
    var notes: String?
    var triggers: [String] // e.g., ["weather", "stress", "sleep"]
    
    // Quick entry support for bad days
    var entryMethod: EntryMethod
    var wasQuickEntry: Bool // True if entered via simplified interface
    
    init(
        date: Date = Date(),
        painLevel: Int? = nil,
        fatigueLevel: Int? = nil,
        moodLevel: Int? = nil,
        notes: String? = nil,
        triggers: [String] = [],
        entryMethod: EntryMethod = .manual
    ) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.timestamp = Date()
        self.painLevel = painLevel
        self.fatigueLevel = fatigueLevel
        self.moodLevel = moodLevel
        self.notes = notes
        self.triggers = triggers
        self.entryMethod = entryMethod
        self.wasQuickEntry = entryMethod == .quickEntry
    }
    
    // Helper computed properties
    var hasAnySymptoms: Bool {
        return painLevel != nil || fatigueLevel != nil || moodLevel != nil
    }
    
    var overallWellness: Double? {
        let levels = [painLevel, fatigueLevel, moodLevel].compactMap { $0 }
        guard !levels.isEmpty else { return nil }
        
        // Convert pain and fatigue to wellness scale (invert them)
        let painWellness = painLevel.map { 6 - $0 } ?? 3
        let fatigueWellness = fatigueLevel.map { 6 - $0 } ?? 3
        let mood = moodLevel ?? 3
        
        return Double(painWellness + fatigueWellness + mood) / 3.0
    }
}

// MARK: - Supporting Types

enum EntryMethod: String, CaseIterable, Codable {
    case manual = "manual"
    case quickEntry = "quick_entry"
    case voice = "voice" // Future enhancement
    case reminder = "reminder_prompt"
    
    var displayName: String {
        switch self {
        case .manual: return "Manual Entry"
        case .quickEntry: return "Quick Entry"
        case .voice: return "Voice Entry"
        case .reminder: return "Reminder Prompt"
        }
    }
}

// Common symptom triggers for quick selection
struct SymptomTriggers {
    static let common = [
        "Weather Change",
        "Stress",
        "Poor Sleep",
        "Physical Activity",
        "Medication Change",
        "Diet",
        "Hormonal",
        "Travel",
        "Work Pressure",
        "Family Issues"
    ]
}

// Helper for symptom level descriptions
struct SymptomLevels {
    static func painDescription(level: Int) -> String {
        switch level {
        case 1: return "Minimal"
        case 2: return "Mild"
        case 3: return "Moderate"
        case 4: return "Severe"
        case 5: return "Very Severe"
        default: return "Unknown"
        }
    }
    
    static func fatigueDescription(level: Int) -> String {
        switch level {
        case 1: return "Energetic"
        case 2: return "Slightly Tired"
        case 3: return "Moderately Tired"
        case 4: return "Very Tired"
        case 5: return "Exhausted"
        default: return "Unknown"
        }
    }
    
    static func moodDescription(level: Int) -> String {
        switch level {
        case 1: return "Very Low"
        case 2: return "Low"
        case 3: return "Neutral"
        case 4: return "Good"
        case 5: return "Very Good"
        default: return "Unknown"
        }
    }
}