# Real Gaps — What's Actually Missing, and Why It Matters

Everything in `status-audit.md` is bookkeeping accuracy. This file is the
part that actually affects whether the app works. Each item says what's
wrong, what evidence shows it, and why it's worth fixing before it's worth
adding anything new.

## 1. The entire Socket.io layer is built and never turned on

`socket_service.dart` and `socket_providers.dart` are fully implemented —
connection management, reconnection with backoff, three exposed streams
(`connectionStateStream`, `elderStatusStream`, `alertTriggeredStream`).
None of it is used. Nowhere in the codebase does any screen `watch()` or
`read()` `elderStatusStreamProvider`, `alertTriggeredStreamProvider`, or
`socketConnectionStateProvider`. Nowhere is `SocketService.connect()` ever
called outside its own class definition.

**Why this matters more than any other gap on this list:** the entire
premise of `AGENTS.md`'s "Real-time Data — Socket.io" section — the reason
Riverpod's `StreamProvider` was chosen, the reason `autoDispose` matters,
the reason there's a whole rule about surfacing "reconnecting..." states to
the UI — is currently inert. An academic committee demo that shows "live
elder status" or "real-time alerts" as a feature would currently be showing
nothing, because nothing in the UI listens for it. This is the gap the
proposed-but-never-built `status_notifications` feature
(`connection_status_banner.dart`) was supposed to close. Its absence isn't
a missing nice-to-have widget — it's the missing consumer for infrastructure
that otherwise has no reason to exist yet.

**What decides priority here:** whether the real-time status feed is a
committee-demo requirement or a nice-to-have. That's not a technical
question — it's worth confirming against the project proposal before
building the consumer, not assuming.

## 2. The emergency flow has no state behind it

`emergency_screen.dart` is a `StatelessWidget`. It doesn't read any
provider. "Call Emergency" shows a demo snackbar ("Calling emergency
services (demo)") and does nothing else — no `EmergencyEvent` is created,
no contact is notified, no state changes anywhere in the app as a result of
pressing it. The only real data model here (`EmergencyContactModel`) is
consumed by the family-circle screen, not by the emergency screen itself.

**Why this matters:** for an elderly-assistant app, the emergency flow is
arguably the single highest-stakes screen in the product. Right now it's
visually complete and functionally a dead end — pressing the biggest, most
prominent button in the app changes nothing. That gap between how finished
it looks and how finished it is is exactly the kind of thing that's
invisible until someone actually tests the flow expecting it to do
something.

## 3. Test coverage doesn't test anything specific to this app

One file, the Flutter-generated default `widget_test.dart`. The plan
explicitly called for tests on the socket providers and on accessibility
tap-target sizes — both are things `AGENTS.md` treats as non-negotiable
("ALWAYS run flutter analyze and flutter test", "Minimum tap target size:
48x48"). Passing `flutter test` currently proves almost nothing about
either rule being followed; it's a green checkmark with no coverage behind
it.

**Why this matters:** `AGENTS.md`'s own workflow rule says never report a
task done with failing tests — but a *passing* trivial test suite gives the
same false confidence as a failing one, just quieter. If a future change
breaks the 48x48 rule on some button, nothing will catch it.

## 4. Model/provider naming drifted from the original plan without anyone deciding that

The plan document names the doctors feature model `healthcare_provider_
model.dart`. The actual codebase has `doctor_model.dart` / `DoctorModel`.
Not wrong — `DoctorModel` is arguably clearer for this app's actual scope —
but it means the plan document and the codebase now describe two different
things, and nobody wrote down that the rename was intentional. Same pattern
as the Emergency/Family provider consolidation in `status-audit.md`: a
reasonable choice that exists nowhere except in the diff between what was
planned and what was built.

**Why this matters less urgently than 1–3, but still matters:** future
sessions (including AI-assisted ones) that read the plan document as a
source of truth will look for files that don't exist under the names it
expects. Worth a one-line note in `AGENTS.md` confirming the rename was
deliberate, so it stops looking like drift.

## What this list does NOT include

Input validation gaps (login/register have no `Form`/validators wired in)
and the missing repository/HTTP-client layer are real, but they're already
tracked in `AGENTS.md`'s session-2 plan from prior review — repeating them
here would just be noise. This file is specifically the gaps the *task
tracker* was hiding, not a restatement of the architecture review.