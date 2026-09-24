# AI Elderly Assistant — Flutter Client (AGENTS.md)

## Project Context
- Voice-first Flutter app for elderly users. This repo is the Flutter mobile client ONLY.
- Figma Design: [AI Elderly System](https://www.figma.com/design/6Q9wR5VGg1aGDgHvs60yBg/AI-Elderly-System?node-id=0-1&t=J8C2Wb6I3LZLoVXr-1)
- Caregiver/family dashboard is a separate web app — different repo, don't touch it.
- Backend: Node.js core service + Python AI microservice — separate repo, don't modify.
- Graduation project, academic committee demo — not a production deployment. Scope discipline matters: don't add complexity (Docker, CI/CD, extra services) unless explicitly asked.
- Ezz al-din is the sole Flutter developer on this client — no team review loop, so be extra rigorous about self-verification (tests/analyze) before reporting done.

## Build & Test
- Install deps: flutter pub get
- Run: flutter run
- Test: flutter test
- Analyze: flutter analyze
- ALWAYS run flutter analyze and flutter test after every change. Fix all failures yourself before reporting a task done — never report success with failing tests or analyzer warnings.
- When adding or moving a file that isn't in its directory's default location, double-check every relative import (`../`) actually resolves to a real path — count the folder levels, don't eyeball it. This exact bug (wrong `../` depth in `voice_chat_models.dart`) already broke the build once.

## State Management
- Riverpod (flutter_riverpod) — chosen for StreamProvider + autoDispose fit with live data (elder status, alerts) and compile-time safety for solo development.
- Wrap app root in ProviderScope.
- Use StreamProvider for any live/real-time data source (elder status, caregiver alerts).
- Use autoDispose on stream providers so connections close when a screen is left — verify this actually works, don't just assume the annotation is enough.
- Providers should not hold hardcoded mock data as their permanent implementation. Mock data is fine as a placeholder, but each provider that will eventually hit the backend needs a repository/data-source seam now, so swapping mock → real data later doesn't mean rewriting the provider.

## Real-time Data — Socket.io
- Use the socket_io_client package (NOT web_socket_channel — Socket.io has its own protocol and client).
- Keep one shared Socket.io connection instance in lib/core/socket/ — don't instantiate a new connection per feature or per screen.
- Wrap socket events in a StreamProvider (or a StreamController bridged to one) so screens consume it via Riverpod, not by holding a raw socket reference themselves.
- Any stream-consuming screen must handle three states explicitly: loading, error (with visible retry), and data — never leave a screen stuck on a bare error with no recovery path.
- Rely on Socket.io's built-in reconnection/polling fallback, but surface connection state changes to the UI (e.g. a subtle "reconnecting..." indicator) — don't let it fail silently.
- Don't hardcode a placeholder server URL and move on if the real one isn't defined yet — stop and ask.

## REST / Request-Response Data
- pubspec.yaml currently has no HTTP client (no dio, no http) — only socket_io_client for real-time events. Anything that isn't push/live data (login, fetching doctor lists, booking an appointment) will need one. Decide and ask before adding it — don't default to dio without confirming.

## Folder Structure (feature-based)
- lib/core/ — shared infrastructure: the Socket.io connection, shared providers, shared widgets/theme
- lib/core/utils/ and lib/core/constants/ — shared formatting, validation, and constants. Do not duplicate date formatting, validators, or magic numbers (radii, durations, tap-target sizes) across features — this folder is where those go.
- lib/features/<feature>/ — screens, widgets, and providers specific to one feature
- If a provider or widget is used by 2+ features, move it to lib/core/ — don't duplicate it across features
- Widget files: snake_case. Class names: PascalCase.

## Accessibility Rules (Critical — elderly users)
- Minimum tap target size: 48x48
- Respect system text scaling — no fixed font sizes that ignore accessibility settings
- High contrast color scheme; avoid thin/light font weights
- Every interactive element needs a semantic label for screen readers
- Error states must be large, clear, and actionable (visible retry button) — never a small icon or subtle text

## Safety Guardrails
- Never commit .env, API keys, or secrets
- Never modify backend (Node.js) or AI microservice (Python) code from this repo
- Ask before adding new dependencies to pubspec.yaml — don't add packages speculatively
- Never force-push to main/master

## Git Conventions
- Conventional commits: feat:, fix:, docs:, refactor:, test:, chore:
- Keep commits scoped to one change

## Workflow
- After every change: run flutter analyze and flutter test, fix failures before reporting done
- If a test fails, explain why before deleting or skipping it — never silently remove a failing test
- If stuck after 2 attempts fixing something, stop and explain what's blocking you instead of continuing to guess
- Flag any accessibility-rule violation you notice, even in code you weren't asked to touch
- If a request conflicts with anything in this file, say so before proceeding — don't silently override it

## Communication
- Be concise — skip explanations of basic Flutter concepts
- When proposing a change, explain why, not just what
- Ask when uncertain about intent rather than guessing

## End of session 1 — status and session 2 plan

**Fixed in session 1:**
- `voice_chat_models.dart` had two broken relative imports (`../data/models/voice_interaction_model.dart` and `../../doctors/data/models/doctor_model.dart`) — wrong `../` depth from its actual location (`lib/features/voice_assistant/data/models/`), causing `DoctorModel` and `VoiceInteractionModel` to be unresolved types. Corrected to `voice_interaction_model.dart` and `../../../doctors/data/models/doctor_model.dart`.
- Active/selected bottom nav tab wasn't blue — `AppBottomNavBar` renders Material 3's `NavigationBar`, but `app_theme.dart` only had `bottomNavigationBarTheme` set (`BottomNavigationBarThemeData`, which only applies to the legacy `BottomNavigationBar` widget). `NavigationBar` was falling back to Material 3 defaults (`secondaryContainer`/teal), ignoring the `navActive` blue already defined in `app_colors.dart`. Added a `navigationBarTheme` (`NavigationBarThemeData`) block to `app_theme.dart` wiring selected state to `AppColors.navActive` and unselected to `AppColors.navInactive`.
- **Open decision:** `bottomNavigationBarTheme` in `app_theme.dart` is now dead config — nothing in the app uses the legacy `BottomNavigationBar` widget. Either delete it or confirm a reason to keep it; left in, it's a trap for the next "the nav bar color is wrong" bug.

**Architecture review findings (session 1):**
- No `lib/core/utils/` or `lib/core/constants/` exists — date formatting, validators, and magic numbers (border radii, tap sizes, durations) are inlined per-screen instead of centralized.
- `_VoiceDoctorCard` (in `voice_assistant_screen.dart`) and `DoctorCard` (`doctors/presentation/widgets/doctor_card.dart`) duplicate the same doctor-card UI as two separately maintained widgets.
- No repository/data-source layer — `doctors_provider.dart`, `reminders_provider.dart`, `appointments_provider.dart` hold hardcoded mock lists directly inside the `StateNotifier`, so there's no seam to swap in real backend calls later.
- No HTTP client dependency (`dio`/`http`) — only `socket_io_client`. Fine for live data, not sufficient for request/response calls (auth, doctor search, booking).
- Core widget layer (`AccessibleButton`, `AsyncValueWidget`, `ErrorView`) is solid and correctly follows the accessibility rules above — no changes needed there.
- Missing shared widgets: empty-state widget (currently ad hoc per screen), loading skeleton, and a base card component the duplicated doctor cards could both build on.

**Session 2 tasks, in order:**
1. Add `lib/core/utils/date_formatter.dart`, `validators.dart`, `lib/core/constants/app_constants.dart`, `lib/core/routes/app_routes.dart`, and `lib/core/config/env_config.dart` — created, not yet wired in. Remaining wiring:
   - `socket_providers.dart`: change `SocketService()` to `SocketService(serverUrl: EnvConfig.socketUrl)`.
   - Delete the inline `AppShellRoutes` class from `home_shell_screen.dart`; replace every `AppShellRoutes.xxx` reference (that file, `family_circle_screen.dart`, `voice_assistant_screen.dart`) with `AppRoutes.xxx`.
   - Wire `validators.dart` into `login_form_screen.dart`/`register_screen.dart` — both currently use plain `TextField` with no `Form`/validation at all (not a duplication cleanup, this is net-new).
   - Wire `date_formatter.dart` into `appointments_screen.dart`/`reminders_screen.dart`.
   - Confirm `EnvConfig` values (`SOCKET_URL`, `API_BASE_URL`, `APP_ENV`) get passed via `--dart-define` in run/build configs once staging/prod URLs exist — staging/prod builds throw a clear error without them by design, dev keeps working with no arguments.
2. Merge `_VoiceDoctorCard` and `DoctorCard` into one shared widget (e.g. `lib/features/doctors/presentation/widgets/doctor_card.dart`) with a compact/full variant flag; delete the duplicate.
3. Add a shared empty-state widget and loading-skeleton widget to `lib/core/widgets/`; wire empty-state into `doctor_search_screen.dart` and `reminders_screen.dart` where it's currently inlined.
4. Re-run `flutter analyze` and `flutter test` after each step above — confirm clean before moving to the next.
5. Decide on an HTTP client (ask before adding to pubspec.yaml) once the repository-layer question below is settled with the backend team — don't add it speculatively.
6. Draft the repository/data-source seam for `doctors_provider.dart` as the first candidate (smallest surface), so mock → real swap is a config change, not a rewrite.

**What's needed from the backend / AI microservice team:**
- Final Socket.io connection URL and auth handshake mechanism (token in handshake vs. query param) — `Socket.io Event Contract` doc has this marked `[يتحدد مع الباك اند]`, still unresolved.
- REST endpoint base URL and auth scheme (JWT? session?) for non-realtime calls (login, doctor search, appointment booking, reminders CRUD).
- Confirmed payload shape for `elder_status_update` and `alert_triggered` events — the contract doc has `location` marked optional/nullable; confirm whether the client should render UI differently when it's absent.

**What to send them:**
- The current `DoctorModel`, `AppointmentModel`, `ReminderModel`, and `VoiceInteractionModel` field names/types (from `lib/features/*/data/models/`) so they can match field names on their side rather than the client remapping after the fact.
- The Socket.io event names and payload shapes the client already expects, as documented in `Socket.io Event Contract — AI Elderly Assistant.md`, flagged as DRAFT pending their review.