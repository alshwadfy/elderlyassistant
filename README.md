# Rafiq (رفيق) — AI Elderly Assistant (Mobile Client)

A mobile companion engineered specifically for older adults and family caregivers, designed with accessibility-first principles, large visual targets, and bilingual (Arabic/English) support.

> **Graduation Project** | Alexandria National University (Faculty of Engineering)  
> **Team Size**: 4 members  
> **Repository Scope**: Flutter Mobile Client Application

---

## 🛠️ Tech Stack & Architecture

| Layer | Technology | Usage in Codebase |
| :--- | :--- | :--- |
| **Framework** | Flutter (Dart 3) | Cross-platform mobile client |
| **State Management** | **Flutter Riverpod** (`v2.6.1`) | `ConsumerWidget`, `StateNotifierProvider`, reactive state |
| **Networking** | **Socket.io Client** (`v3.0.2`) | Real-time event streaming and connection management |
| **Localization** | `flutter_localizations` | Native Arabic and English support |
| **Design System** | Custom Flutter Material 3 | Accessible typography, high-contrast themes, dynamic font scaling |

---

## ✨ Features Implemented in `lib/`

### 1. 💊 Medication & Daily Reminders (`features/reminders`)
- Daily timeline for morning, afternoon, and evening medication schedules.
- High-contrast interactive reminder cards with one-tap status toggling (`pending` / `completed`).
- Add and delete reminder functionality managed reactively through Riverpod.

### 2. 🎙️ Voice Assistant UI (`features/voice_assistant`)
- Conversational chat interface tailored for older adults with oversized text bubbles and clear status cues.
- State-driven interaction flow managed via `VoiceAssistantProvider`.

### 3. 🚨 Emergency Contacts & Caregiver Hub (`features/emergency`)
- Immediate emergency screen providing quick one-tap contact calling.
- Caregiver request listing and family connection management.

### 4. 🏥 Healthcare & Doctor Appointments (`features/doctors`)
- Directory listing and search interface for clinics and medical specialists.
- Appointment scheduling view and status tracking.

### 5. ♿ Accessibility-First System (`core/theme` & `core/widgets`)
- Floating Accessibility Action Sheet allowing dynamic font scaling up to 145% via custom `MediaQuery` wrapping.
- High-contrast color palettes adhering to legible contrast thresholds.
- Minimum 48–60dp touch targets across all interactive buttons (`AccessibleButton`).

### 6. 🔌 Real-Time Connectivity (`core/socket`)
- Socket.io client service wrapper (`SocketService`) handling connection states, event subscriptions, and banner feedback.

---

## 👨‍💻 My Role & Personal Contributions (Ezz Al-Din)

As the primary mobile frontend contributor on the team, my work focused on:
- **Application Architecture & Navigation**: Architected the application structure, main navigation shell (`HomeShellScreen`), bottom navigation tabs, and onboarding flows.
- **State Management (Riverpod)**: Authored and structured the client state management providers (`RemindersProvider`, `VoiceAssistantProvider`, `FamilyProvider`, `DoctorsProvider`, `AppointmentsProvider`).
- **Complete Screen & UI Implementation**: Built the user interfaces for Reminders, Voice Assistant dialogue, Emergency contacts, Doctor appointments, and Authentication from Figma wireframes into production Flutter widgets.
- **Accessibility Engine**: Engineered the `AccessibilityFloatingButton` font scaling mechanism and custom accessible button wrappers.
- **Socket.io Integration**: Scaffolded the client-side `SocketService` and reactive connection status indicators.

---

## 🔮 Planned Architecture (Future Roadmap)

The following items are outlined in project architectural specifications and planned for future integration:
- **Speech-to-Intent Pipeline**: Backend Arabic Natural Language Understanding (NLU) microservice integration for hands-free voice intent processing.
- **Automated Emergency Call Escalation**: Backend-driven sequential telephony dispatch for unanswered SOS alerts.
- **"Way Home" Walking Assistance**: GPS-guided simplified turn-by-turn walking route navigation for disoriented seniors.
- **Lab WCAG AAA Certification**: Formal automated contrast and screen-reader accessibility test suite.

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