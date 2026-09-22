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

## State Management
- Riverpod (flutter_riverpod) — chosen for StreamProvider + autoDispose fit with live data (elder status, alerts) and compile-time safety for solo development.
- Wrap app root in ProviderScope.
- Use StreamProvider for any live/real-time data source (elder status, caregiver alerts).
- Use autoDispose on stream providers so connections close when a screen is left — verify this actually works, don't just assume the annotation is enough.

## Real-time Data — Socket.io
- Use the socket_io_client package (NOT web_socket_channel — Socket.io has its own protocol and client).
- Keep one shared Socket.io connection instance in lib/core/socket/ — don't instantiate a new connection per feature or per screen.
- Wrap socket events in a StreamProvider (or a StreamController bridged to one) so screens consume it via Riverpod, not by holding a raw socket reference themselves.
- Any stream-consuming screen must handle three states explicitly: loading, error (with visible retry), and data — never leave a screen stuck on a bare error with no recovery path.
- Rely on Socket.io's built-in reconnection/polling fallback, but surface connection state changes to the UI (e.g. a subtle "reconnecting..." indicator) — don't let it fail silently.
- Don't hardcode a placeholder server URL and move on if the real one isn't defined yet — stop and ask.

## Folder Structure (feature-based)
- lib/core/ — shared infrastructure: the Socket.io connection, shared providers, shared widgets/theme
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


## end of session 1 what to do next in session 2
- next we need to add the widget file  and utils folder
- fix the current errors
- list the upcoming tasks
-  what are the missing components and features
- what do we need from the backend and ai microservice team 
- what should we send them so they can match our payload