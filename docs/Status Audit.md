# Status Audit — Task Tracker vs. Actual Codebase

Every line below was checked against the actual repository, not assumed from
the tracker. Where the tracker and the code disagree, the code wins, and the
evidence is given so this doesn't need re-litigating next session.

## Why this file exists
A task tracker that's wrong in either direction costs you twice: marking done
work as pending means you re-do it or second-guess it; marking stub work as
done means you present a feature at the committee demo that doesn't actually
function. Both happened in this tracker. This file is the correction, once,
with receipts.

## Corrections — tracker said NOT done, code says DONE

- **BottomNavBar** — tracker: `[ ]`. Reality: `AppBottomNavBar` exists
  (`lib/core/widgets/app_bottom_nav_bar.dart`), is wired into
  `HomeShellScreen.bottomNavigationBar`, and drives the 4-tab shell
  (Home/Schedule/Reminders/More) via `AppShellRoutes`. Its selected-state
  color was a separate real bug (fixed last session — see
  `AGENTS.md` session log) but the widget itself has existed and worked
  since before that fix.

- **Login form screen** — tracker: `[ ]`. Reality: `login_form_screen.dart`
  is a complete screen — email/password fields, show/hide password toggle,
  error banner wired to `authProvider.error`, loading state on the submit
  button, navigation to register. Nothing about it is a stub.

- **Create account screen** — tracker: `[ ]`. Reality: `register_screen.dart`
  is complete — name/email/phone/password fields, privacy-acceptance
  checkbox gate, wired to `authProvider.register()`, navigates to
  `VerifyCodeScreen` on success.

- **Verify code screen** — tracker: `[ ]`. Reality: `verify_code_screen.dart`
  exists and is reached from the register flow via
  `Navigator.push(MaterialPageRoute(...))`. Implemented, not a placeholder.

- **Voice Conversation screen** — tracker: `[ ]`. Reality:
  `voice_assistant_screen.dart` is fully built — chat bubble list, scroll-to-
  bottom on new messages, doctor-recommendation cards inline in the chat,
  mic state handling. This is the screen two of the last several sessions
  were spent debugging; it very much exists.

- **AuthProvider (mock)** — tracker: `[ ]`. Reality: `auth_provider.dart`
  is a complete `StateNotifier` — `AuthState` with `isLoading`/`error`/
  `codeSent`/`isAuthenticated`, `login()` and `register()` methods with a
  simulated network delay. Mock, as labeled, but not missing.

**Why this direction of error matters more than it looks:** every item above
was treated as open work in a plan. If session 2 had followed the tracker
literally, it would have rebuilt four screens and a provider that already
work, instead of spending that time on the things that are actually missing
(see `real-gaps.md`).

## Corrections — tracker said DONE, reality is thinner than the checkmark implies

- **"EmergencyContactModel + EmergencyProvider" and "FamilyContactModel +
  FamilyProvider"** — tracker: both `[x]`, listed as four separate
  deliverables. Reality: there is one model (`EmergencyContactModel`) and
  one provider (`FamilyNotifier` / `familyProvider`), shared between the
  emergency and family-circle screens. There is no `EmergencyProvider` and
  no `FamilyContactModel` anywhere in the codebase. Not wrong to share them —
  that's a defensible design choice — but the tracker claims twice as much
  was built as actually was, which matters if anyone is estimating remaining
  work off this list.

- **"Update tests" / "flutter test → all pass"** — tracker: `[x]`. Reality:
  there is exactly one test file, `test/widget_test.dart` (the default
  Flutter counter-app test scaffold is the likely origin). The original
  plan document called for `socket_provider_test.dart` and
  `accessibility_test.dart` specifically — neither exists. "Tests pass" is
  true but trivial: a single default test passing says nothing about
  whether the socket layer or the accessibility rules in `AGENTS.md`
  (48x48 tap targets, etc.) are actually verified anywhere.

## Item correctly left in-progress, but for the wrong reason

- **"Add Figma link to AGENTS.md"** — tracker: `[/]` (in progress). Reality:
  the current `AGENTS.md` already contains the Figma link in the Project
  Context section. This one should just be checked off — it's not a gap,
  it's a stale tracker entry.

## Items not on the tracker at all

The original plan document (`Feature-Based Architecture Implementation
Plan`) proposed a `lib/features/status_notifications/` feature —
`connection_status_banner.dart` and `notifications_provider.dart` — to
surface live socket connection state to the user. It's absent from both the
codebase and the current tracker. It didn't get dropped on purpose that
anyone recorded; it just never made it onto the list after the plan was
written. See `real-gaps.md` for why this specific omission is the most
consequential one in this audit.