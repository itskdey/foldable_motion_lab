# Foldable Motion Lab

A small Flutter project dedicated to one thing: making the transition between a
single-screen phone layout and a two-pane foldable layout feel continuous.

## What this project demonstrates

- One persistent widget tree instead of swapping two completely different screens.
- Smooth 700 ms fold / unfold motion.
- 3D `rotateY` animation for the second pane.
- Width interpolation for the first pane.
- Fade + slide + scale details that follow the same `foldProgress`.
- `MediaQuery.displayFeatures` support for real hinges and folds.
- Camera cutouts are ignored.
- A built-in simulator so you can test the motion on a normal phone or desktop.
- Responsive action buttons that do not collapse into vertical text.

## Important idea

`foldProgress` is the single source of truth:

- `0.0` = folded / compact
- `1.0` = unfolded / dual pane

Every visual transformation is derived from that same progress value.

## Run

If this folder does not yet have generated platform folders, run:

```bash
flutter create --platforms=android,ios .
flutter pub get
flutter run
```

The `lib/` source is the project implementation. If `flutter create .` replaces
your generated `lib/main.dart`, restore the `lib/` folder from this archive.

## Simulator

Use the bottom control:

- drag the slider for frame-by-frame folding
- tap **Fold**
- tap **Unfold**
- enable **Auto device** to let window width / foldable device state drive the animation

For a real foldable device, leave **Auto device** enabled.

## Architecture

```text
lib/
├── main.dart
├── fold/
│   ├── fold_device_info.dart
│   └── fold_motion_controller.dart
├── screens/
│   └── foldable_lab_screen.dart
└── widgets/
    ├── fold_demo_content.dart
    └── fold_simulator_bar.dart
```
