# Flutter App — Fixes & Additions (v1.1 request)

Corrected scope: these are edits to the Flutter client (elder-facing app),
not the web dashboard. Grouped the same way as before — decisions needed,
backend-dependent, ready to build, too vague, deprioritized.

## 0. Decision needed before building

**Caregiver-invites-caregiver flow.** The elder-side approval screen (in
Family Circle) needs to show incoming caregiver requests either way — but
whether a *second* caregiver can be added without hitting that screen at
all (silent) or always produces a dismissible notification (visible,
revocable) is still unresolved from last turn. Build the approval screen
regardless; the open question is only whether every addition requires it
or just the first one.

## 1. Needs a backend/schema change first, Flutter change depends on it

- **Alert timestamp in the trigger payload.** When the elder triggers an
  emergency, the Flutter call to the backend needs to include a
  timestamp — confirm the field name matches `emergency_event.triggered_at`
  on the backend side so analytics has a real date to work from (this was
  item 1 in the original list — "due date" was the wrong term, timestamp
  is what's needed).
- **Medication-taken timestamp.** When the elder marks a reminder done,
  the app needs to send a `completed_at` timestamp, not just a status
  flag — this is the actual data source for the Medication Adherence
  metric elsewhere in the system. Needs the `completed_at` column to exist
  on the backend first (flagged in the backend proposal already).
- **Reminder duration fields.** The "Add Reminder" flow needs day-of-week
  and duration inputs (e.g. "for 7 days" vs. ongoing) — needs the
  `duration_days`/`end_date` column added to `reminder` on the backend
  before the Flutter form can save it meaningfully.
- **Shared appointment cancellation.** The elder needs a cancel button on
  `appointments_screen.dart` that calls the same endpoint the caregiver
  dashboard will use (`PATCH /api/v1/appointments/{id}/cancel`) — build
  against that shared endpoint once it exists, not a Flutter-only action.
- **Alert reassurance notification to the elder.** Item 13 ("alert must go
  to elder and caregivers") means the elder's own app should receive a
  confirmation ("Help is on the way") after triggering SOS — this depends
  on the Socket.io/notification consumer that's still unbuilt on the
  Flutter side (the dormant socket layer flagged in the earlier
  architecture review). This item can't ship until that's wired up.

## 2. Flutter-only — ready to build now

- **Text size and contrast.** Subtext currently renders in a low-contrast
  grey that's hard to read for elderly users — bump weight and contrast on
  secondary text app-wide. This directly conflicts with the accessibility
  rule already in `AGENTS.md` ("avoid thin/light font weights," "high
  contrast color scheme") — this isn't a new rule, it's an existing rule
  not being followed yet. Audit every `Theme.of(context).textTheme`
  secondary/muted color usage, not just one screen.
- **Reminder edit and delete.** `reminders_screen.dart` currently only
  supports add + mark-complete. Add edit and delete actions.
- **"Skipped" status support.** The backend schema already allows
  `skipped` as a reminder status; Flutter's mock data and status badges
  don't show it yet. Add a skipped-state example to mock data and a badge
  for it, matching the pending/completed/missed pattern already there.
- **Define the "Book" button's behavior.** On the doctor search screen,
  tapping "Book" currently doesn't do anything real. It should open a
  booking flow (date/time picker) that calls the appointments endpoint —
  this can't fully work until the HTTP client decision (already an open
  item in `AGENTS.md`) is made, but the UI/flow can be built against a
  stub now.
- **Appointment cancel button** (client-side half of item 10 above) — the
  button and confirmation dialog can be built now; wire it to the real
  endpoint once it exists.

## 3. Too vague to action as-is — needs specifics

- "Build the remaining screens so it looks more complete" — per the last
  status audit, every planned Flutter screen already exists and is
  implemented (voice, reminders, doctors, appointments, emergency, family,
  profile, auth flow). If something specific still feels unfinished, name
  the screen — otherwise there's nothing left on the original screen list
  to build.

## 4. Explicitly deprioritized, not dropped

- General UI refinement — v1.1, after the items above.

## 5. Cross-cutting — affects both Flutter and backend, flagging so it isn't missed

- **Doctor appointment response.** See the reply this file was sent
  with — doctor confirms/declines via a token-secured link in the
  notification, no doctor login. The Flutter side doesn't build anything
  for this directly, but the appointment status Flutter displays
  (`confirmed`/`scheduled`/etc.) now depends on this mechanism actually
  existing on the backend — flag to the backend team alongside this file.