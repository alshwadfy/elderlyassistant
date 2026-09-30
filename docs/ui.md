# UI Redesign Brief — AI Elderly Assistant (Flutter Client)
### Master version — supersedes the two earlier documents, send this one instead

You are redesigning the visual UI of a voice-first Flutter app for elderly
users (60+). You have no image reference — everything you need to make
correct visual decisions is specified below. Where a rule conflicts with a
default design instinct (e.g. "make it look modern and minimal"), the rule
in this document wins. This app's primary user has declining vision,
possible reduced fine motor control, and no obligation to be
tech-comfortable — design for that reality, not for a design-portfolio
aesthetic.

A first pass against an earlier version of this brief came back close, but
with a real contrast failure and a structurally incomplete color palette —
both are fixed below, folded into the rules directly instead of left as a
separate patch.

## The one rule that overrides every other instinct

**Do not strip this down to a "toy" interface.** Most users in this age
group are healthy, capable adults — not helpless. Over-simplifying, using
baby-ish visuals, or patronizing copy is as much a failure here as tiny
unreadable text. The goal is *legible and confident*, not "dumbed down."
If a design choice would embarrass a competent adult, reject it.

## Typography

- **Body text minimum: 18sp.** Never go below this for anything the user
  is expected to read and act on. Headings scale up from there (24–32sp).
- **Never hardcode a font size that ignores system text-scaling.** If the
  OS-level accessibility text size is increased, the layout must reflow
  to accommodate it, not clip or truncate.
- **Weight: medium/semibold minimum for anything informational.** No thin
  or light font weights anywhere.
- **Plain, literal language. No cleverness, no idioms, no abbreviations.**
  Write instructions as complete, literal sentences: "Tap the green
  button to call your doctor," not "Call Doctor →".

## Color — corrected palette, use these exact values

The palette submitted in the first pass had one contrast failure and no
non-blue colors at all. This is the fixed, complete set:

### Brand & neutrals

| Role | Hex | Notes |
|---|---|---|
| Primary | `#1647AD` | Buttons, active nav, primary actions |
| Primary Dark | `#10275A` | Pressed states, dark-mode surfaces |
| Text Primary | `#1A2B4A` | Headings, primary body text |
| Background | `#F7F9FF` | App background |
| Surface | `#FFFFFF` | Cards |
| Container Tint | `#E9ECFF` | Selected states, subtle highlight fills |

### Text

| Role | Hex | Contrast on white | Notes |
|---|---|---|---|
| Text Secondary | `#4B5875` | 7.1:1 | Do not use `#66789E` or any grey below 4.5:1 — this was the original failure point |

### Status colors — required, none of these existed in the first pass

| Role | Hex | Contrast on white | Use |
|---|---|---|---|
| Success | `#15803D` | 5.0:1 | Completed reminders, resolved alerts, confirmed appointments |
| Warning | `#B45309` | 5.0:1 | Pending/missed reminders, unconfirmed appointments |
| Error / Emergency | `#B91C1C` | 6.5:1 | SOS button, active/critical alerts, destructive-action confirms |

Each status color gets a light tint background (~90% lightness, same
hue) for badges/cards — e.g. success tint `#DCFCE7`, warning tint
`#FEF3C7`, error tint `#FEE2E2`. Text on a tint uses the full-strength
color, never white-on-tint. The tint is decoration; solid color + icon +
text label together carry the meaning — color is never the only signal.

### Color rules

- **Blue and purple read as faded/washed-out to many older eyes.** Keep
  blue as brand identity, but never let blue-on-light or blue-on-dark be
  the *only* differentiator for something the user must notice or act
  on — pair every meaningful blue element with shape, icon, weight, or
  size difference too.
- **Never pair yellow/green or blue/purple as adjacent status colors** —
  those pairs are hard to distinguish for this age group. The palette
  above avoids this already; don't introduce a new color that breaks it.
- **Treat WCAG AA (4.5:1) as the absolute floor, aim for 7:1+ (AAA)**
  wherever feasible, especially anything safety-related.

## Touch targets and layout

- **Minimum tap target: 48x48dp, no exceptions.** Primary actions (SOS,
  "call," "confirm") should go larger — 64dp+ for the single most
  important action on a screen.
- **Generous spacing between tappable elements** — accidental mis-taps on
  adjacent targets are a real failure mode here, not a minor annoyance.
- **Prefer vertical lists over dense grids.** Reserve grids for small,
  equal-weight items (4 home-screen shortcuts max); never for anything
  with more than ~6 items.
- **One primary action per screen, visually dominant.** There should
  always be one obvious next step, not several equally-weighted buttons.
- **Bottom navigation always shows a visible text label under every icon,
  permanently — never icon-only, never label-on-selection-only.**

## Interaction patterns

- **Confirm every destructive or important action with a plain Yes/No
  prompt, not a vague icon-only dialog.** "Cancel this appointment?" with
  clearly labeled Yes/No buttons — not a trash-can icon with no text.
- **Every action gets visible confirmation feedback** — a large, clear
  checkmark + text, not just a subtle color shift.
- **Reinforce visual feedback with audio/voice** where the app already
  has voice capability — important confirmations ("Reminder saved,"
  "Help is on the way") should be spoken aloud, not just shown as text.
- **No hidden gestures.** Swipe-to-delete, long-press menus, and other
  gesture-only interactions are undiscoverable and risk accidental
  destructive triggers. Every action needs a visible, tappable, labeled
  control — stricter than most modern app conventions.

## Screen-by-screen notes

- **Home / shell navigation** — literal text labels always visible under
  every nav icon.
- **Emergency screen — this must exist, and is the highest-priority
  screen in the whole app.** If it wasn't included in a prior pass, build
  it before considering any other screen finished. The SOS action uses
  Error (`#B91C1C`) at full strength — visually distinct from every other
  button in the app, not a shade of the brand blue. Largest,
  highest-contrast element on the screen. Follow the confirm-with-Yes/No
  pattern once triggered, but the confirm step itself must be equally
  large and immediate — don't add friction that delays a real emergency.
- **Voice assistant screen** — chat-bubble UI meets the same 18sp/
  high-contrast rules as every other screen; don't let small bubble text
  or low-contrast timestamps creep in just because that's common
  elsewhere.
- **Reminders / Appointments / Doctors** — list-based, one card per row.
  Status (pending/completed/missed) shown with the Success/Warning/Error
  colors above plus a text label — never color alone.
- **Forms (login, register, add reminder, etc.)** — large labels above
  each field, not placeholder-only text that disappears once typing
  starts.

## What NOT to do

- No cartoonish mascots, no baby-talk copy, no excessive rounding/bubble
  shapes that read as a children's app.
- Don't over-simplify by removing real functionality "for their own
  good" — reduce visual/cognitive clutter, not capability.
- Don't assume this user can't handle a multi-step flow if each step is
  clear — the failure mode is *unclear* steps, not *multiple* steps.
- Don't rely on any interaction requiring precise timing, rapid taps, or
  fine gesture control.
- **Don't default to a generic modern-consumer-app look and call it
  done.** If the result reads as visually indistinguishable from a
  standard app at a glance, that's a signal the rules above weren't
  actually applied, not proof they were.

## Deliverable expectation

Apply these rules to the existing screen set (auth flow, home shell,
reminders, doctors, appointments, **emergency**, family circle, voice
assistant, profile) — not new screens, not a new information
architecture. When this pass is complete, every screen should use the
palette above with zero remaining instances of `#66789E` or any other
sub-4.5:1 text color anywhere in the app.

## to do next
refine the rest of the screens and make it as the reminders one 
fix the pixel overflow
arabic wasn't applied in all screens (nav bar)
remove the small actions in the home screen (why do we even have same 2 buttons in the same screen)
can we refine th nav bar and make it flowing 
also i want to add a new floating action button (accessibility) that opens a menu with quick actions like:
- increase font size
- decrease font size
- increase text spacing
- decrease text spacing
- increase contrast
- decrease contrast
- high contrast mode
- read aloud
