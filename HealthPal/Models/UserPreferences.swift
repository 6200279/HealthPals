//
//  UserPreferences.swift
//  HealthPal
//
//  User preferences model focusing on accessibility and privacy controls
//

import Foundation
import SwiftData

@Model
final class UserPreferences {
    var id: UUID
    var lastModified: Date
    
    // Accessibility preferences (addressing PRD requirements)
    var useLargeText: Bool
    var useHighContrast: Bool
    var preferredColorScheme: ColorScheme
    var enableVoiceReminders: Bool
    var enableHapticFeedback: Bool
    var reminderSoundLevel: SoundLevel
    
    // Notification preferences
    var enablePushNotifications: Bool
    var enableEmailReminders: Bool
    var enableSMSBackup: Bool
    var quietHoursStart: Date?
    var quietHoursEnd: Date?
    
    // Privacy controls (patient-centric focus from PRD)
    var shareDataWithProvider: Bool
    var providerAccessLevel: ProviderAccessLevel
    var allowDataExport: Bool
    var enableOfflineMode: Bool
    var dataRetentionDays: Int
    
    // Compassionate design preferences
    var enableEncouragingMessages: Bool
    var reminderTone: ReminderTone
    var showStreakCounter: Bool
    var enableGentleNudges: Bool
    
    // Symptom tracking preferences
    var enableDailySymptomCheck: Bool
    var symptomReminderTime: Date?
    var trackPainLevels: Bool
    var trackFatigueLevels: Bool
    var trackMoodLevels: Bool
    
    // Emergency and caregiver settings
    var emergencyContactEnabled: Bool
    var emergencyContactInfo: String?
    var caregiverAccessEnabled: Bool
    var caregiverContactInfo: String?
    
    init() {
        self.id = UUID()
        self.lastModified = Date()
        
        // Accessibility defaults
        self.useLargeText = false
        self.useHighContrast = false
        self.preferredColorScheme = .system
        self.enableVoiceReminders = false
        self.enableHapticFeedback = true
        self.reminderSoundLevel = .medium
        
        // Notification defaults
        self.enablePushNotifications = true
        self.enableEmailReminders = false
        self.enableSMSBackup = false
        
        // Privacy defaults (privacy-first approach)
        self.shareDataWithProvider = false // Opt-in, not opt-out
        self.providerAccessLevel = .basic
        self.allowDataExport = true
        self.enableOfflineMode = false
        self.dataRetentionDays = 365
        
        // Compassionate design defaults
        self.enableEncouragingMessages = true
        self.reminderTone = .gentle
        self.showStreakCounter = true
        self.enableGentleNudges = true
        
        // Symptom tracking defaults
        self.enableDailySymptomCheck = true
        self.trackPainLevels = true
        self.trackFatigueLevels = true
        self.trackMoodLevels = true
        
        // Emergency defaults
        self.emergencyContactEnabled = false
        self.caregiverAccessEnabled = false
    }
}

// MARK: - Supporting Enums

enum ColorScheme: String, CaseIterable, Codable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    case highContrast = "high_contrast"
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System Default"
        case .highContrast: return "High Contrast"
        }
    }
}

enum SoundLevel: String, CaseIterable, Codable {
    case silent = "silent"
    case low = "low"
    case medium = "medium"
    case high = "high"
    case vibrationOnly = "vibration_only"
    
    var displayName: String {
        switch self {
        case .silent: return "Silent"
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .vibrationOnly: return "Vibration Only"
        }
    }
}

enum ProviderAccessLevel: String, CaseIterable, Codable {
    case none = "none"
    case basic = "basic" // Adherence data only
    case standard = "standard" // Adherence + basic symptoms
    case full = "full" // All data including notes
    
    var displayName: String {
        switch self {
        case .none: return "No Access"
        case .basic: return "Basic (Medication adherence only)"
        case .standard: return "Standard (Adherence + symptoms)"
        case .full: return "Full Access (All data)"
        }
    }
    
    var description: String {
        switch self {
        case .none:
            return "Your healthcare provider cannot see any of your HealthPal data."
        case .basic:
            return "Your provider can see which medications you've taken and missed, but no symptom data or personal notes."
        case .standard:
            return "Your provider can see medication adherence and basic symptom levels (pain, fatigue, mood ratings)."
        case .full:
            return "Your provider has access to all your HealthPal data including personal notes and detailed logs."
        }
    }
}

enum ReminderTone: String, CaseIterable, Codable {
    case gentle = "gentle"
    case standard = "standard"
    case urgent = "urgent"
    case custom = "custom"
    
    var displayName: String {
        switch self {
        case .gentle: return "Gentle & Encouraging"
        case .standard: return "Standard"
        case .urgent: return "Urgent (for critical meds)"
        case .custom: return "Custom"
        }
    }
    
    var sampleMessage: String {
        switch self {
        case .gentle:
            return "Time for your medication 💙 Take care of yourself today."
        case .standard:
            return "Medication reminder: [Medication Name]"
        case .urgent:
            return "Important: Time for your [Medication Name]"
        case .custom:
            return "Your custom message here"
        }
    }
}