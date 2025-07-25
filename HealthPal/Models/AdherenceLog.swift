//
//  AdherenceLog.swift
//  HealthPal
//
//  Tracks medication adherence with patient-centric flexibility and context
//

import Foundation
import SwiftData

@Model
final class AdherenceLog {
    var id: UUID
    var medicationId: UUID
    var scheduledDate: Date
    var scheduledTime: Date // The exact time the medication was supposed to be taken
    
    // Adherence tracking
    var status: AdherenceStatus
    var actualTakenTime: Date?
    var loggedTime: Date // When the user logged this entry
    
    // Patient-centric context (addressing PRD requirements)
    var delayReason: DelayReason?
    var missReason: MissReason?
    var notes: String?
    
    // Snooze tracking
    var snoozeCount: Int
    var snoozeHistory: [SnoozeEntry]
    
    // Entry method for accessibility tracking
    var entryMethod: LogEntryMethod
    
    init(
        medicationId: UUID,
        scheduledDate: Date,
        scheduledTime: Date,
        status: AdherenceStatus = .pending
    ) {
        self.id = UUID()
        self.medicationId = medicationId
        self.scheduledDate = scheduledDate
        self.scheduledTime = scheduledTime
        self.status = status
        self.loggedTime = Date()
        self.snoozeCount = 0
        self.snoozeHistory = []
        self.entryMethod = .manual
    }
    
    // Helper methods
    func markAsTaken(at time: Date = Date(), method: LogEntryMethod = .manual, notes: String? = nil) {
        self.status = .taken
        self.actualTakenTime = time
        self.loggedTime = Date()
        self.entryMethod = method
        self.notes = notes
    }
    
    func markAsMissed(reason: MissReason, notes: String? = nil) {
        self.status = .missed
        self.missReason = reason
        self.loggedTime = Date()
        self.notes = notes
    }
    
    func addSnooze(duration: Int, reason: DelayReason? = nil) {
        let snoozeEntry = SnoozeEntry(duration: duration, reason: reason)
        self.snoozeHistory.append(snoozeEntry)
        self.snoozeCount += 1
        self.delayReason = reason
        self.status = .snoozed
    }
    
    var isOnTime: Bool {
        guard let takenTime = actualTakenTime else { return false }
        let timeDifference = abs(takenTime.timeIntervalSince(scheduledTime))
        return timeDifference <= 30 * 60 // Within 30 minutes considered on time
    }
    
    var totalDelayMinutes: Int {
        guard let takenTime = actualTakenTime else { return 0 }
        let delay = takenTime.timeIntervalSince(scheduledTime)
        return max(0, Int(delay / 60))
    }
}

// MARK: - Supporting Types

enum AdherenceStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case taken = "taken"
    case missed = "missed"
    case snoozed = "snoozed"
    case skipped = "skipped" // Intentionally skipped (e.g., doctor's advice)
    
    var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .taken: return "Taken"
        case .missed: return "Missed"
        case .snoozed: return "Snoozed"
        case .skipped: return "Skipped"
        }
    }
    
    var color: String {
        switch self {
        case .pending: return "orange"
        case .taken: return "green"
        case .missed: return "red"
        case .snoozed: return "yellow"
        case .skipped: return "gray"
        }
    }
}

enum DelayReason: String, CaseIterable, Codable {
    case pain = "pain"
    case fatigue = "fatigue"
    case nausea = "nausea"
    case forgotAtHome = "forgot_at_home"
    case inMeeting = "in_meeting"
    case sleeping = "sleeping"
    case sideEffects = "side_effects"
    case noWater = "no_water"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .pain: return "Pain flare-up"
        case .fatigue: return "Too tired"
        case .nausea: return "Feeling nauseous"
        case .forgotAtHome: return "Forgot medication at home"
        case .inMeeting: return "In meeting/appointment"
        case .sleeping: return "Was sleeping"
        case .sideEffects: return "Experiencing side effects"
        case .noWater: return "No water available"
        case .other: return "Other reason"
        }
    }
    
    var isSymptomRelated: Bool {
        return [.pain, .fatigue, .nausea, .sideEffects].contains(self)
    }
}

enum MissReason: String, CaseIterable, Codable {
    case forgot = "forgot"
    case ranOut = "ran_out"
    case sideEffects = "side_effects"
    case feltBetter = "felt_better"
    case tooSick = "too_sick"
    case noAccess = "no_access"
    case doctorAdvice = "doctor_advice"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .forgot: return "Simply forgot"
        case .ranOut: return "Ran out of medication"
        case .sideEffects: return "Side effects too severe"
        case .feltBetter: return "Felt better, didn't think I needed it"
        case .tooSick: return "Too sick to take it"
        case .noAccess: return "Couldn't access medication"
        case .doctorAdvice: return "Doctor advised to skip"
        case .other: return "Other reason"
        }
    }
    
    var requiresAttention: Bool {
        return [.ranOut, .sideEffects, .tooSick, .noAccess].contains(self)
    }
}

enum LogEntryMethod: String, CaseIterable, Codable {
    case manual = "manual"
    case quickTap = "quick_tap"
    case voice = "voice"
    case widget = "widget"
    case reminder = "reminder_response"
    case automatic = "automatic" // Future: smart detection
    
    var displayName: String {
        switch self {
        case .manual: return "Manual Entry"
        case .quickTap: return "Quick Tap"
        case .voice: return "Voice Command"
        case .widget: return "Home Screen Widget"
        case .reminder: return "Reminder Response"
        case .automatic: return "Automatic Detection"
        }
    }
}

@Model
final class SnoozeEntry {
    var id: UUID
    var timestamp: Date
    var durationMinutes: Int
    var reason: DelayReason?
    
    init(duration: Int, reason: DelayReason? = nil) {
        self.id = UUID()
        self.timestamp = Date()
        self.durationMinutes = duration
        self.reason = reason
    }
}