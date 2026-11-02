# Rafiq (رفيق) — AI Elderly Assistant (Mobile Client)

A voice-first mobile companion engineered specifically for older adults and family caregivers, built with accessibility-first principles, large touch targets, and bilingual (Arabic/English) support.

> **Graduation Project** | Alexandria National University (Faculty of Engineering)  
> **Team Size**: 4 members (Led team of 4 and built the entire Flutter client)  
> **Repository Scope**: Complete Flutter Mobile Client Application

---

## 🛠️ Tech Stack & Architecture

| Layer | Technology | Usage in Codebase |
| :--- | :--- | :--- |
| **Framework** | Flutter (Dart 3) | Cross-platform mobile client |
| **State Management** | **Flutter Bloc** (`v9.1.1`) & **Cubit** | `EmergencyBloc`, `WayHomeCubit`, `FamilyCubit`, `CaregiverRequestsCubit`, `AppSettingsCubit` |
| **Real-Time Gateway** | **Socket.io Client** (`v3.0.2`) | Real-time event streaming and live connection handling (`SocketService`) |
| **Localization** | `flutter_localizations` | Native Arabic and English support (`AppLocalizations`) |
| **Design System** | Custom Material 3 | High-contrast themes, dynamic system font scaling, large touch targets |

---

## ✨ Features Implemented in `lib/`

### 1. 🚨 15-Second Emergency SOS Countdown (`features/emergency`)
- **`EmergencyBloc` FSM**: Event-driven finite state machine managing the 15-second cancelable countdown timer.
- Protects seniors against accidental false triggers (e.g. hand tremors) with prominent cancel and instant-dispatch buttons.
- State-managed session transitions: `EmergencySessionStarted` → `EmergencyCountdownTicked` → `EmergencyDispatchedImmediately` or `EmergencyCancelled`.

### 2. 🧭 "Way Home" Walking Directional Assistant (`features/way_home`)
- **`WayHomeCubit`**: Step-by-step directional walking guidance designed for elders experiencing spatial disorientation.
- High-contrast directional cues, remaining distance calculations, and step advancement (`WayHomeStep`).

### 3. 💊 Medication & Daily Reminders (`features/reminders`)
- Daily timeline separated into morning, afternoon, and evening medication schedules.
- Card-based reminder items with one-tap status toggling (`pending` / `completed`).
- Add and delete reminder flows handled reactively.

### 4. 🎙️ Conversational Voice Dialogue UI (`features/voice_assistant`)
- Senior-centric conversational chat interface with oversized text bubbles and audio state feedback cues.
- Dialogue layout tailored for elder readability.

### 5. 👨‍👩‍👧 Family Circle & Caregiver Coordination (`features/emergency`)
- **`FamilyCubit` & `CaregiverRequestsCubit`**: Caregiver connection listing, approval workflow, and one-tap emergency contact calling.

### 6. 🏥 Healthcare & Doctor Appointments (`features/doctors`)
- Directory listing and specialty search for medical clinics and hospitals.
- Appointment scheduling view and status tracking.

### 7. ♿ Accessibility-First System (`core/theme` & `core/widgets`)
- Dynamic font scaling up to 145% wrapped seamlessly around the app's `MediaQuery`.
- `AccessibilityFloatingButton` for instant on-screen accessibility adjustments.
- Minimum 48–60dp touch targets across all interactive buttons (`AccessibleButton`).

### 8. 🔌 Real-Time Connectivity (`core/socket`)
- Centralized `SocketService` managing connection states, reconnects, event streams, and real-time status banners.

---

## 👨‍💻 My Role & Contribution (Ezz Al-Din)

- **Team Leadership**: Led a multidisciplinary graduation project team of four members.
- **Complete Mobile Client**: Architected and built the entire Flutter mobile application from the ground up.
- **State Management**: Designed and implemented the complete Bloc/Cubit reactive state layer (`EmergencyBloc`, `WayHomeCubit`, `FamilyCubit`, `CaregiverRequestsCubit`, `AppSettingsCubit`).
- **UI/UX & Accessibility Engineering**: Translated Figma specifications into production Flutter widgets, implementing the accessibility font scaling system and high-contrast UI themes.
- **Real-Time Integration**: Integrated the client-side Socket.io service layer for real-time caregiver synchronization.

---

## 🔮 Out of Scope / Backend Roadmap

The mobile client interface is ready to connect to upstream external services:
- **Arabic Speech-to-Intent Pipeline**: Backend Arabic Natural Language Understanding (NLU) microservice for voice intent processing.
- **Automated Telephony Call Dispatch**: Backend telecom service for automated multi-contact phone call escalation.

---

## 🚀 Running the App

### Prerequisites
- Flutter SDK `^3.8.1` / Dart `^3.8.1`
- Android Studio / VS Code with Flutter extension
- Android Emulator or physical device

### Installation
```bash
# 1. Clone repository
git clone https://github.com/alshwadfy/elderlyassistant.git
cd elderlyassistant

# 2. Fetch dependencies
flutter pub get

# 3. Run application
flutter run
```
