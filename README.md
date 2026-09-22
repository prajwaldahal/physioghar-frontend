# PhysioGhar — Therapist App

A Flutter prototype of the PhysioGhar therapist app: a daily dashboard, a weekly schedule with
availability management, booking requests and session management, patient records with session
notes, profile and language settings, and issue reporting.

Android only. All data is mocked locally and lives in memory — nothing persists across restarts.

## Running

```bash
flutter pub get
flutter run
```

Building a release APK:

```bash
flutter build apk --release
```

`flutter pub get` also regenerates the localisation classes from `lib/l10n/*.arb`, so no extra
codegen step is needed.

## Versions

| | |
|---|---|
| Flutter | 3.44.1 (stable) |
| Dart | 3.12.1 |
| Android SDK | 36.0.0 |
| Min Android | as per the Flutter default template |

## Packages

| Package | Why |
|---|---|
| `flutter_riverpod` | State management (see below). Compile-safe, testable, no `BuildContext` needed to read state. |
| `go_router` | Declarative routing with a `StatefulShellRoute` so each bottom-nav tab keeps its own navigation stack, and detail screens are deep-linkable. |
| `google_fonts` | Loads Fraunces, Inter and IBM Plex Mono from bundled assets, per the design system in the brief. |
| `intl` | Date and time formatting. |
| `flutter_localizations` | English and Nepali localisation. |

No code generation is used — no `freezed`, no `riverpod_generator`, no `build_runner`. Models are
hand-written and immutable with `copyWith`.

## State management: why Riverpod

The brief asks for Riverpod, and the shape of this app suits it well. The central problem here is
that the same facts are shown in several places at once: today's sessions appear on the dashboard,
the same sessions make slots look BOOKED on the schedule, and the same sessions form a patient's
history. If each screen kept its own copy, they would drift apart the moment something changed.

So there is exactly **one owner per piece of state**, and everything else is derived:

- `bookingsProvider` owns every session. It is the spine of the app.
- `slotsProvider` owns only what the therapist controls: whether a slot is open or blocked.
- `availabilityStatusProvider` owns the single Available/Unavailable flag.
- `profileProvider`, `notesProvider`, `patientsProvider` and `complaintsProvider` own their slices.

Everything else is a derived `Provider` that reads those with `ref.watch` — today's sessions, the
three dashboard counts, a patient's previous sessions, the last-session date, the per-day open
count, and the resolved state of every slot. Accepting a booking updates one list, and the
dashboard, the schedule and the patient record all change on the next frame without any manual
syncing.

`AsyncNotifier` is used for anything loaded asynchronously and `Notifier` for synchronous state.
`AsyncValue` drives the loading, error and data branches in the UI.

## Mock data

Mock JSON lives in `assets/mock/`, one file per feature, read through a `MockDataSource` that sits
behind an abstract repository per feature (`BookingRepository`, `SlotRepository`, and so on). Each
repository has a `Mock…` implementation; swapping in a remote implementation later would not
require changes above the repository layer, and providers can be overridden in tests.

Two details worth calling out:

- **Dates are relative, not absolute.** Sessions are stored as a `dayOffset` from today plus a
  `"HH:mm"` time, resolved when the data loads. "Today" is therefore always correct, whichever day
  the app is opened, and the sample data from the brief always lands on today.
- **Slots are generated from a per-weekday template** rather than fixed dates, so the current week
  always looks realistic — a blocked lunch hour every day, shorter weekends — regardless of when
  the app is run.

Initial loads simulate 300–600 ms of latency so the loading states are real rather than decorative.
Actions taken by the user apply immediately and confirm with a snackbar.

## Project structure

```
lib/
├── main.dart                  entry point, ProviderScope
├── app.dart                   MaterialApp.router, theme, locale
├── l10n/                      app_en.arb, app_ne.arb
├── core/                      shared and feature-agnostic
│   ├── data/                  MockDataSource (asset load, latency, date resolution)
│   ├── format/                date helpers, reusable field validation rules
│   ├── l10n/                  locale provider
│   ├── models/                models used by more than one feature
│   ├── router/                routes and the shell
│   ├── theme/                 palette, spacing, text styles, theme
│   └── widgets/               the shared widget set
└── features/<feature>/
    ├── model/                 models owned by this feature
    ├── providers/             notifiers and derived providers
    ├── repository/            abstract interface plus mock implementation
    └── presentation/
        ├── screens/
        └── widgets/
```

Each feature owns its full vertical slice — model, mock data, repository, providers and UI. Only
genuinely feature-agnostic infrastructure lives in `core/`. Widgets hold no business logic; they
watch providers and call notifier methods.

## Key decisions

- **BOOKED is derived, never stored.** A slot record only knows whether it is open or blocked.
  Whether it is booked is worked out by matching its time against the sessions. A session and its
  slot therefore cannot disagree.
- **No double booking, enforced in one place.** Accepting a request or rescheduling checks that a
  slot exists at that time, is not blocked, and is not already taken. Any failure is rejected with
  a message that says what to do next. Pending requests deliberately do not reserve a slot, which
  is what makes a genuine clash possible.
- **The seed data contains two real conflicts on purpose** — two pending requests at the same time,
  and one request landing on a blocked slot — so the rejection paths can be reached by tapping
  rather than only existing in theory.
- **Sessions carry a denormalised patient name**, as a real API response would, so the bookings
  feature does not depend on the patients feature.
- **One shared session detail screen.** The actions it offers depend on the session's status.
- **Declined and cancelled are distinct.** Both appear under Cancelled, but a declined request is
  labelled "Declined".

## Assumptions

The brief leaves some things open. Where it did, the simplest behaviour that keeps the app coherent
was chosen:

1. Slots are a fixed 60 minutes. Adding a slot validates against a real interval overlap, not just
   an identical start time.
2. Slots are seeded for the current week plus the following seven days. The schedule screen shows
   the current week, as the brief asks; rescheduling may target any date within the seeded range.
3. Completion remarks are optional and belong to the session. They are shown on the session detail
   and in the patient's history. They are separate from patient notes.
4. Notes use a structured form: the session note is required, exercises and the next-session plan
   are optional. Exercises are entered one per line.
5. A patient's last-session date and previous sessions are derived from completed sessions, so
   completing a session updates the patient record immediately.
6. There is no authentication. Logging out asks for confirmation, resets the mock data to its seed
   and returns to the dashboard.
7. Nepali covers the navigation labels, dashboard headings and the account screens. The brief
   states a full translation is not required.
8. Complaint reference IDs are generated locally in a `PG-#####` format.

## Things I would do next with more time

- **Persistence.** State is in memory only. A local database would let the app survive a restart
  and would make the repository layer earn its keep.
- **A real backend.** The repository interfaces were written with this in mind; a remote
  implementation could be selected at startup without touching the UI.
- **Wider localisation.** Only part of the app is translated. The remaining strings should move
  into the ARB files, along with localised date formatting for Nepali.
- **Search and filtering** on the patient list and the bookings tabs, which would start to matter
  well before a real caseload.
- **Accessibility passes** — semantic labels on the icon-only controls, and a check against a
  screen reader.
- **Richer schedule editing**, such as dragging a session to a new slot, or setting recurring
  weekly availability instead of editing day by day.
