# Rafiq (رفيق) — Voice-First AI Elderly Assistant
### معك في كل مرحلة · With You Every Step of the Way

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Hybrid%20Bloc%20%2B%20Cubit-blueviolet)](https://bloclibrary.dev)
[![State](https://img.shields.io/badge/State-flutter__bloc%20v9-blue)](https://pub.dev/packages/flutter_bloc)
[![Tests](https://img.shields.io/badge/Tests-Passing%20100%25-brightgreen)](https://flutter.dev)
[![Accessibility](https://img.shields.io/badge/Accessibility-WCAG%20AAA%20Compliant-success)](https://www.w3.org/WAI/WCAG21/quickref/)
[![Language](https://img.shields.io/badge/Language-Arabic%20(Primary)%20%2F%20English-orange)](#multilingual--localization)

---

## 📌 Executive Summary

**Rafiq (رفيق)** is an empathetic, voice-first mobile companion engineered specifically for older adults (60+) and their family caregivers. 

As individuals age, standard smartphone interfaces become hostile: small text, dense menus, complex multi-step navigation, and low-contrast controls create severe digital barriers. **Rafiq** eliminates these friction points by providing a calm, legible, dignified, and voice-accessible experience in natural Arabic (with Egyptian dialect and regional support) and English.

Built strictly against evidence-based accessibility standards (WCAG AAA, minimum 48–64dp touch targets, system-wide font scaling), **Rafiq** bridges the care gap between seniors living independently and family members who care for them.

---

## 🌟 Core Pillars & Capabilities

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           RAFIQ (رفيق) ECOSYSTEM                        │
├──────────────────────────┬──────────────────────────────────────────────┤
│  👵 Elder Experience     │  👨‍👩‍👧 Family & Caregiver Coordination        │
├──────────────────────────┼──────────────────────────────────────────────┤
│ • Natural Voice AI       │ • Real-Time Medication Adherence Sync        │
│ • Single-Tap Reminders   │ • Sequential Emergency SOS Call Escalation   │
│ • 15s Safety Countdown  │ • Remote Reminder & Prescription Injection   │
│ • "Way Home" Navigation  │ • Caregiver Link Approval & Access Control   │
│ • Daily Emotional Check  │ • Shared Doctor Visits & Healthcare Plans    │
└──────────────────────────┴──────────────────────────────────────────────┘
```

### 1. 🎙️ Natural Conversational Voice Assistant (`اسأل مساعدك`)
- **Speech-to-Intent Pipeline:** Elders speak naturally (e.g. *"نعم، أخذت حبة الضغط الآن"* or *"أين أقرب مستشفى؟"*).
- **Intent Recognition:** Powered by FastAPI NLU models supporting Egyptian and Modern Standard Arabic.
- **Empathetic Personas:** Customizable assistant tone:
  - **Warm & Gentle (`دافئ ولطيف`)** — default supportive and patient pacing.
  - **Clear & Direct (`واضح ومباشر`)** — concise instructions.
  - **Family Member Style (`أسلوب فرد من العائلة`)** — friendly and familiar.
- **Audible Responses (TTS):** Automatic spoken confirmation alongside clear visual chat bubbles.

### 2. 💊 Medication & Routine Timeline (`أدويتي` & `الرئيسية`)
- **Zero-Friction Logging:** Doses can be logged by voice command or by tapping high-contrast status cards.
- **Unified Timeline:** Daily schedule separated into Morning, Afternoon, Evening, and Night intervals.
- **Statuses:** `pending` (بانتظار الجرعة), `completed` (تم تناولها ✓), and `skipped` (تم تخطيها).
- **Dose Adherence Tracking:** Accurate timestamping (`completed_at`) feeds caregiver adherence metrics.

### 3. 🚨 15-Second Emergency SOS & Family Escalation (`مساعدة الطوارئ`)
- **Prominent Emergency Access:** Always accessible via the floating SOS bar and dedicated header action.
- **15-Second Cancelable Buffer:** Prevents accidental false alarms caused by hand tremors.
- **Live Location Sharing:** Automatically attaches GPS coordinates and street address to the alert payload.
- **Sequential Priority Escalation:** If emergency dispatch triggers, calls family members in strict priority order:
  1. **ليلى (الابنة)** — First responder.
  2. **عمر (الابن)** — Escalation if no answer.
  3. **هدى (الأخت)** — Secondary escalation.
- **Direct Emergency Services:** Quick one-tap fallback to national emergency dispatch (`١٢٣`).

### 4. 🧭 "Way Home" Directional Walking Assistant (`ساعدني أرجع للبيت`)
- Designed for elders who experience mild spatial disorientation or forget their return route.
- Step-by-step visual and audible instructions (e.g., *"امشِ للأمام ١٠٠ متر ثم انعطف يمينًا"*).
- Bold directional arrows and high-contrast remaining distance cues.

### 5. 🏥 Healthcare & Hospital Search (`المستشفيات القريبة`)
- Lists nearby verified clinics, cardiology centers, and hospitals.
- Displays distance in kilometers and driving/walking time in minutes.
- One-tap booking flow and shared appointment cancellation.

### 6. 👨‍👩‍👧 Live Family Synchronization (`عائلتي` & Caregiver Integration)
- **Bidirectional Sync:** When Uncle Ahmed logs his medicine by voice, daughter Laila's app updates instantly.
- **Remote Injection:** Family members can remotely schedule new medications (e.g., Vitamin D) which appear immediately on the senior's home timeline.
- **Caregiver Link Approval:** The elder maintains control by reviewing and approving incoming caregiver requests.

### 7. ♿ Comprehensive Accessibility Suite
- **Minimum 48×48dp Tap Targets** (and 60dp+ for primary CTAs).
- **WCAG AAA Contrast Ratio (7:1+)** on all vital text and interactive surfaces.
- **Quick Accessibility Menu:** Floating action button providing real-time:
  - Font scaling (from 85% up to 145%).
  - Text letter spacing adjustments (+0.0 to +2.0).
  - Contrast enhancements and High-Contrast mode toggle.
  - Spoken Read-Aloud (Text-to-Speech) for on-screen content.

### 8. ☀️/🌙 Signature Day & Night Sky Interface
- **Sunny Day Mode:** Serene blue sky with subtle clouds and morning warmth.
- **Moonlit Night Mode:** Calming midnight blue (`#0E1B38`) with crescent moon halo (`#F5E5AD`) and soft stars.
- **Emergency Mode:** Deep alert crimson gradient (`#D32F2F`) signaling urgent status.
- **Quick Weather Chip:** Integrated `٢٤°` weather and one-tap Day/Night toggle in every header.

---

## 🏛️ Senior Architecture: Hybrid Bloc + Cubit + Reactive Repositories

The project avoids legacy state-management patterns (such as deprecated `StateNotifier` or tightly coupled controllers) and adopts a **Senior-Grade Hybrid `flutter_bloc` (`Bloc` + `Cubit`) + Reactive Repository Pattern**:

```
┌────────────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER (UI)                         │
│  StatelessWidget / StatefulWidget with context.watch() & context.read() │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ Events & Method Calls
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                      BUSINESS LOGIC LAYER (BLOC / CUBIT)               │
│                                                                        │
│   ┌──────────────────────────┐         ┌───────────────────────────┐   │
│   │   Event-Driven BLOCs     │         │      Pragmatic CUBITs     │   │
│   │ (Finite State Machines)  │         │   (Synchronous / CRUD)    │   │
│   ├──────────────────────────┤         ├───────────────────────────┤   │
│   │ • EmergencyBloc          │         │ • AppSettingsCubit        │   │
│   │ • VoiceAssistantBloc     │         │ • RemindersCubit          │   │
│   └──────────────────────────┘         │ • DoctorsCubit            │   │
│                                        │ • AppointmentsCubit       │   │
│                                        │ • FamilyCubit             │   │
│                                        │ • DailyCheckInCubit       │   │
│                                        │ • WayHomeCubit            │   │
│                                        └───────────────────────────┘   │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ Emits / Listens
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│              DOMAIN REPOSITORY LAYER (Single Source of Truth)           │
│                                                                        │
│   • MedicationRepository: Canonical Stream<List<ReminderModel>>        │
│   • HealthcareRepository: Verified Hospitals & Doctor Visits           │
│   • EmergencyRepository: Priority Contacts & Dispatch Actions          │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ Network & Sockets
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                       INFRASTRUCTURE / API LAYER                       │
│                                                                        │
│   • RafiqApiService: REST endpoints (POST /voice, /emergency, /checkin)│
│   • SocketService / SocketCubit: Real-time Caregiver synchronization   │
│   • RafiqBlocObserver: Centralized audit logging of all events/errors  │
└────────────────────────────────────────────────────────────────────────┘
```

### Why this architecture is superior for Rafiq:
1. **Tremor / Multi-Tap Protection:** In `VoiceAssistantBloc` and `EmergencyBloc`, incoming user events pass through sequential event queues with explicit state guards (`if (state.state == VoiceAssistantState.processing) return;`), preventing accidental duplicate API calls.
2. **Race-Condition-Free Timers:** The 15-second emergency countdown timer lives entirely inside `EmergencyBloc` rather than leaking into the widget lifecycle. If the user taps *"Cancel"* while a network request is in flight, the post-await check prevents late responses from overriding cancellation.
3. **Zero Controller Coupling:** `VoiceAssistantBloc` never holds a reference to `RemindersCubit`. Instead, it updates `MedicationRepository`, which broadcasts changes via `remindersStream`. `VoiceAssistantScreen`, `HomeTabView`, `RemindersScreen`, and `FamilyCircleScreen` update reactively.
4. **Pragmatic Simplicity:** Settings, hospital filters, and check-ins use lightweight `Cubit`s, eliminating unnecessary event boilerplate where simple synchronous updates suffice.
5. **Medical Audit Trail:** `RafiqBlocObserver` centrally logs every event, transition, and error across the entire application lifecycle.

---

## 📂 Project Directory Structure

```
elderlyassistant/
├── assets/
│   ├── images/
│   │   ├── rafiq_logo_day.png        # Sunny day brand logo (#105:285)
│   │   ├── rafiq_logo_night.png      # Night moonlit brand logo (#107:75)
│   │   ├── rafiq_logo_full.png       # Horizontal brand badge (#91:140)
│   │   └── sky_header_day.png        # Sky header illustration (#2:99)
├── lib/
│   ├── main.dart                     # App entry point + RafiqBlocObserver
│   ├── core/
│   │   ├── bloc/
│   │   │   ├── rafiq_app_providers.dart # Root MultiRepository & MultiBloc trees
│   │   │   └── rafiq_bloc_observer.dart # Global state & event transition logger
│   │   ├── config/
│   │   │   └── app_config.dart       # API & Socket configuration
│   │   ├── l10n/                     # Bilingual translations (Arabic / English)
│   │   ├── providers/
│   │   │   └── app_settings_provider.dart # AppSettingsCubit (theme, font, a11y)
│   │   ├── repositories/
│   │   │   └── rafiq_repositories.dart    # Medication, Healthcare, Emergency Repos
│   │   ├── services/
│   │   │   └── rafiq_api_service.dart     # REST client with local fallback
│   │   ├── socket/                   # Real-time caregiver socket consumer
│   │   ├── theme/
│   │   │   ├── app_colors.dart       # WCAG AAA palette & color roles
│   │   │   └── app_theme.dart        # Light and Dark theme configurations
│   │   └── widgets/
│   │       ├── rafiq_sky_header.dart # Signature Day/Night/Emergency sky header
│   │       ├── rafiq_emergency_bar.dart # Floating SOS action pill
│   │       ├── accessibility_floating_button.dart # Quick a11y sheet trigger
│   │       └── app_bottom_nav_bar.dart # Accessible bottom navigation
│   └── features/
│       ├── auth/                     # Onboarding, Login, Register, Permissions
│       ├── check_in/                 # Daily emotional check-in flow
│       ├── doctors/                  # Hospital search & appointment management
│       ├── emergency/                # 15s SOS countdown, escalation, Family circle
│       ├── home/                     # Home shell screen & HomeTabView
│       ├── profile/                  # User profile, appearance, audio settings
│       ├── reminders/                # Medication schedule, add/edit/delete doses
│       ├── voice_assistant/          # 9-step voice interaction FSM & chat bubbles
│       └── way_home/                 # Directional walking assistance
└── test/
    ├── widget_test.dart              # End-to-end screen & repository unit tests
    ├── accessibility_test.dart       # Accessibility bounds, scaling & FAB tests
    ├── reminders_test.dart           # Medication CRUD & stream listener tests
    ├── appointments_test.dart        # Doctor booking & cancellation tests
    └── emergency_test.dart           # SOS session & escalation logic tests
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK:** Version `3.22.0` or higher (Channel stable)
- **Dart SDK:** Version `3.4.0` or higher
- **Android Studio / Xcode / VS Code** with Flutter & Dart extensions

### Installation & Execution

1. **Clone the repository:**
   ```bash
   git clone <repo-url>
   cd AI_Elderly_Assistant_Project/elderlyassistant
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify static analysis:**
   ```bash
   flutter analyze
   ```
   *(Expected output: `No issues found!`)*

4. **Run the test suite:**
   ```bash
   flutter test
   ```
   *(Runs all unit, widget, accessibility, and decoupled repository tests)*

5. **Launch the application:**
   ```bash
   flutter run
   ```

---

## ⚙️ Backend & API Configuration

Backend connection URLs are centralized in [`lib/core/config/app_config.dart`](file:///D:/std/AI_Elderly_Assistant_Project/elderlyassistant/lib/core/config/app_config.dart):

```dart
class AppConfig {
  // Main backend API (FastAPI / Node.js)
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.rafiq-elderly.com',
  );

  // Dedicated AI Voice NLU service
  static const String aiBaseUrl = String.fromEnvironment(
    'AI_BASE_URL',
    defaultValue: 'https://ai.rafiq-elderly.com',
  );

  // Real-time Caregiver Socket.io gateway
  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'wss://socket.rafiq-elderly.com',
  );
}
```

You can pass environment variables at build/run time:
```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8000 --dart-define=SOCKET_URL=http://localhost:3000
```

> **Note on Offline / Mock Fallback:**
> If backend services are unreachable or URLs are left blank, `RafiqApiService` gracefully engages an offline mock pipeline matching Sequence Diagrams 1–4, allowing UI, voice interactions, and SOS simulation to function completely.

---

## ♿ Accessibility Compliance Checklist

- [x] **Target Sizing:** Every interactive touch target is $\ge 48 \times 48\text{ dp}$ (SOS and primary buttons $\ge 60\text{ dp}$).
- [x] **Contrast:** Informational text achieves WCAG AAA compliance ($\ge 7:1$ contrast ratio).
- [x] **Redundant Signaling:** Color is never the sole carrier of meaning; icons and text labels always accompany status changes.
- [x] **Text Scaling:** Full reflow support without text clipping when OS font scale is enlarged up to 145%.
- [x] **Screen Reader Semantics:** Explicit `Semantics` widgets annotate buttons, sliders, weather chips, and emergency controls.
- [x] **Physical Tremor Protection:** Guarded event handling prevents duplicate trigger invocations on accidental multi-taps.

---

## 👥 Graduation Project & Development Team

- **Project:** Rafiq (رفيق) — AI Elderly Assistant
- **Scope:** Voice-First Mobile Client for Older Adults & Family Caregiver Integration
- **Academic Year:** 2025 – 2026

*Crafted with care, patience, and senior software craftsmanship.*
