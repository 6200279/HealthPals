# HealthPal

HealthPal is a patient‑centred medication management app written in SwiftUI. It focuses on helping chronic illness patients handle their daily medications and symptom tracking with minimal cognitive load.

## Features
- **Accessible UI** – large touch targets and high‑contrast options.
- **Flexible reminders** – schedule medications with snooze options and gentle messaging.
- **Symptom diary** – quick check‑ins for pain, fatigue and mood.
- **Compassionate design** – supportive copy and non‑judgemental tone.
- **Privacy controls** – configurable data sharing and offline mode.

## Building
1. Install the latest Xcode (15 or newer is recommended).
2. Open `HealthPal.xcodeproj`.
3. Select the desired iOS simulator or device.
4. Build and run via **Product ▶ Run** or press `⌘R`.

## Running Tests
The project includes unit and UI tests under `HealthPalTests` and `HealthPalUITests`.
To execute them in Xcode choose **Product ▶ Test** (`⌘U`). From the command line you can use:

```bash
xcodebuild -scheme HealthPal -destination 'platform=iOS Simulator,name=iPhone 15' test
```

## Project Goals
HealthPal aims to support people managing chronic illnesses by tracking medications and symptoms in a compassionate way. The app places emphasis on accessibility, privacy and user‑friendly reminders while remaining flexible for days when symptoms flare up.

## License
This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
