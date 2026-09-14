# Foldable Motion Lab

A Flutter app dedicated to one interaction: preserving the user's work while a phone folds and unfolds.

This is no longer a static foldable mockup. Every action is functional, state survives posture changes, and the same detail widget moves between compact and expanded presentations.

## Locked-in behavior

### Folded phone

- The action list is the home screen.
- Tapping **Notes**, **Tasks**, **Reader**, or **Fold settings** opens that action as a full-screen workspace.
- Back returns to the compact action list.
- Notes, checked tasks, reader size, bookmark state, and settings stay in memory.
- If the phone unfolds while an action is open, that exact workspace smoothly moves into the right pane instead of being recreated.

### Unfolded phone

- The action list becomes the persistent left navigation pane.
- Tapping an action does not navigate away; it updates the right detail pane.
- Folding again keeps the selected action as the compact full-screen workspace when it was actively opened.

## Motion model

The UI is driven by two values:

- `foldProgress`: `0.0` folded -> `1.0` unfolded
- `detailProgress`: `0.0` compact home -> `1.0` compact detail open

That gives two continuous flows:

```text
folded home                         unfolded
┌──────────────────┐               ┌────────────┬───────────────┐
│ action list      │  ──────────>  │ action list│ detail        │
└──────────────────┘               └────────────┴───────────────┘

folded detail                       unfolded
┌──────────────────┐               ┌────────────┬───────────────┐
│ selected detail  │  ──────────>  │ action list│ same detail   │
└──────────────────┘               └────────────┴───────────────┘
```

The fold controller uses a 700 ms `fastOutSlowIn` transition. The compact detail uses perspective `rotateY`, then morphs position and width as the phone opens.

## Real foldable support

`MediaQuery.displayFeatures` is inspected for only:

- `DisplayFeatureType.fold`
- `DisplayFeatureType.hinge`

Camera holes and cutouts are ignored. Physical hinge width is used as part of the dual-pane gap when Flutter exposes it.

## Functional actions

- **Notes** — create and delete notes
- **Tasks** — add, check, uncheck, and delete tasks
- **Reader** — change reading size and toggle bookmark state
- **Fold settings** — show/hide the fold guide and switch between normal/dense action navigation

All action state survives fold/unfold because posture changes presentation, not app state.

## Simulator

The bottom Fold Simulator works on any phone or simulator:

- drag the slider for frame-by-frame fold inspection
- tap **Fold**
- tap **Unfold**
- toggle **Auto device** to let real width / fold state drive the motion

## Run

```bash
flutter pub get
flutter run
```

## Structure

```text
lib/
├── main.dart
├── fold/
│   ├── fold_device_info.dart
│   └── fold_motion_controller.dart
├── models/
│   └── lab_action.dart
├── state/
│   └── fold_lab_store.dart
├── screens/
│   └── functional_fold_screen.dart
└── widgets/
    ├── fold_detail_panel.dart
    ├── fold_home_panel.dart
    └── fold_simulator_bar.dart
```

GitHub Actions runs `flutter analyze` and `flutter test` on feature branches and pull requests.
