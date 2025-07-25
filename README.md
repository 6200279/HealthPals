# HealthPal

HealthPal is a SwiftUI medication and symptom tracker focused on compassionate design. The app helps patients manage daily medications, log symptoms, and review progress while keeping data local with SwiftData.

## Features
- **Today View**: see today's medications with reminders and optional snooze.
- **Medications Management**: add or edit medications and schedules.
- **Symptom Diary**: quick pain, fatigue, and mood logging.
- **Progress Overview**: adherence trends and wellness insights.
- **Accessibility Settings**: large text, color scheme options, and more.

## Build & Run
1. Open `HealthPal.xcodeproj` in Xcode 15 or later.
2. Select the **HealthPal** target and press **Run** (⌘R) to build on a simulator or device.

Command line build example:
```bash
xcodebuild -scheme HealthPal -destination 'platform=iOS Simulator,name=iPhone 15' build
```

## Running Tests
Unit and UI tests are provided. Run them in Xcode with **Product → Test** (⌘U) or via the command line:
```bash
xcodebuild test -scheme HealthPal -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Project Goals
HealthPal aims to simplify medication adherence for people living with chronic illness. The project emphasizes privacy, accessibility, and a gentle tone to support users even on difficult days.
