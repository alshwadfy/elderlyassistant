# Next-Steps Plan — Priority and Reasoning

No code decisions here, no file names, no implementation details. Just what
to do next and why it's ranked where it is. Code comes after this is
confirmed.

## How priority was decided

Three questions, in this order, for everything competing for next-session
time:
1. Does skipping this risk demoing something that doesn't actually work?
2. Does skipping this cost more the longer it's skipped (architecture debt
   compounding) or less (a utils file nobody's blocked on yet)?
3. Is a decision needed from someone other than the person writing code
   (backend team, design system) before this can even start?

Everything below is ordered by that, not by how easy it is to build.

## Priority 1 — Confirm the emergency flow's real scope before touching it

This isn't a coding task yet — it's a question: for the committee demo,
does "Call Emergency" need to be a real, stateful action (create an
`EmergencyEvent`, notify a contact, log it) or is a convincing demo
interaction enough? The answer changes the size of the work by an order of
magnitude, and right now nobody has written down which one was intended.
Given `real-gaps.md` item 2, this is the single highest-consequence unknown
in the project — get the answer before writing anything for it.

## Priority 2 — Decide whether the socket layer is in-scope for the demo

Same shape of question as Priority 1: `real-gaps.md` item 1 shows a fully
built, entirely unused real-time layer. Either it's demo-critical (in which
case the missing consumer — a connection-status indicator and something
that reacts to `elder_status_update`/`alert_triggered` — becomes urgent),
or it's a stretch feature for after the demo (in which case it's fine to
leave dormant and this drops far down the list). This can't be answered by
writing code faster; it needs a scope decision.

## Priority 3 — Fix the task tracker itself

Not because it's urgent, but because it's cheap and it's actively
misleading right now. `status-audit.md` documents the corrections — the
five-minute version of "next steps" here is just: replace the checklist
with the corrected one so the next session (or the next person looking at
it) isn't working from wrong information. This is the one item on this
list that's pure bookkeeping, which is exactly why it should happen before
anything else competes for attention.

## Priority 4 — Wire in what's already been built, before building more utils

Session's worth of core utility files now exist (`app_constants`,
`date_formatter`, `app_validator`, `app_routes`, `env_config`, `app_assets`,
`dialog_utils`, `app_styles`) and none of them are used by a screen yet.
The reasoning for ranking this above adding anything new: every additional
utils file created before the existing ones are wired in increases the gap
between "infrastructure that exists" and "infrastructure that's actually
load-bearing," and that gap is exactly what produced the false checkmarks
in the task tracker in the first place — things get marked done when a file
exists, not when it's actually doing something.

## Priority 5 — Real test coverage for the two things `AGENTS.md` treats as non-negotiable

Accessibility tap-target sizes and socket stream behavior are both called
out explicitly in `AGENTS.md` as rules, not preferences. Right now neither
is tested. This is ranked below the scope questions above because writing
tests for a flow that might get rebuilt (emergency) or turned on for the
first time (socket) is wasted effort until Priorities 1–2 are answered —
but it should happen before the demo, not after something breaks silently.

## Priority 6 — Everything already in `AGENTS.md`'s existing session-2 plan

Input validation wiring, doctor-card duplication, empty-state/loading
widgets, the repository/data-source seam. These are real and already
documented — they're not being dropped, just correctly ranked below items
that are either higher-risk (broken-looking emergency flow) or
higher-leverage (unblocking the utils files already written) at this exact
point in the project.

## What this plan deliberately does not do

It doesn't assume more utils files, more architecture layers, or more
scaffolding are automatically the next right move just because they're
easy to produce. The pattern in this project so far has been: infrastructure
gets built, checkmarks get added, and the gap between "exists" and "works"
grows. This plan is ranked to close that gap before widening it further.