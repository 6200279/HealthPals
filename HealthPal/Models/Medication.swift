//
//  Medication.swift
//  HealthPal
//
//  Core medication model supporting flexible scheduling and patient-centric features
//

import Foundation
import SwiftData

@Model
final class Medication {
    var id: UUID
    var name: String
    var dosage: String
    var instructions: String
    var isActive: Bool
    var createdDate: Date
    var lastModified: Date
    
    // Flexible scheduling support
    var scheduleType: ScheduleType
    var reminderTimes: [ReminderTime] // Multiple daily reminders
    var isAsNeeded: Bool // PRN (Pro Re Nata) medications
    
    // Patient-centric features
    var customReminderMessage: String?
    var allowSnooze: Bool
    var snoozeIntervals: [Int] // Minutes: [15, 30, 60]
    
    // Visual and accessibility
    var color: String // For visual identification
    var shape: MedicationShape // pill, capsule, liquid, etc.
    
    init(
        name: String,
        dosage: String,
        instructions: String = "",
        scheduleType: ScheduleType = .daily,
        reminderTimes: [ReminderTime] = [],
        isAsNeeded: Bool = false,
        allowSnooze: Bool = true,
        color: String = "blue",
        shape: MedicationShape = .pill
    ) {
        self.id = UUID()
        self.name = name
        self.dosage = dosage
        self.instructions = instructions
        self.isActive = true
        self.createdDate = Date()
        self.lastModified = Date()
        self.scheduleType = scheduleType
        self.reminderTimes = reminderTimes
        self.isAsNeeded = isAsNeeded
        self.allowSnooze = allowSnooze
        self.snoozeIntervals = [15, 30, 60] // Default snooze options
        self.color = color
        self.shape = shape
    }
}

// MARK: - Supporting Enums and Types

enum ScheduleType: String, CaseIterable, Codable {
    case daily = "daily"
    case weekdays = "weekdays"
    case weekends = "weekends"
    case custom = "custom" // Specific days of week
    case asNeeded = "as_needed"
    
    var displayName: String {
        switch self {
        case .daily: return "Every Day"
        case .weekdays: return "Weekdays Only"
        case .weekends: return "Weekends Only"
        case .custom: return "Custom Schedule"
        case .asNeeded: return "As Needed"
        }
    }
}

enum MedicationShape: String, CaseIterable, Codable {
    case pill = "pill"
    case capsule = "capsule"
    case liquid = "liquid"
    case injection = "injection"
    case patch = "patch"
    case inhaler = "inhaler"
    case drops = "drops"
    
    var systemImage: String {
        switch self {
        case .pill: return "pills.fill"
        case .capsule: return "capsule.fill"
        case .liquid: return "drop.fill"
        case .injection: return "syringe.fill"
        case .patch: return "bandage.fill"
        case .inhaler: return "lungs.fill"
        case .drops: return "drop.triangle.fill"
        }
    }
}

@Model
final class ReminderTime {
    var id: UUID
    var hour: Int // 0-23
    var minute: Int // 0-59
    var isEnabled: Bool
    var customDays: [Int]? // 1-7 for custom schedules (1=Sunday)
    
    init(hour: Int, minute: Int, isEnabled: Bool = true, customDays: [Int]? = nil) {
        self.id = UUID()
        self.hour = hour
        self.minute = minute
        self.isEnabled = isEnabled
        self.customDays = customDays
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
        return formatter.string(from: date)
    }
}