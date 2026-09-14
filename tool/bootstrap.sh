#!/usr/bin/env bash
set -euo pipefail

echo "Bootstrapping Flutter platform folders..."

TMP_DIR=".foldable_motion_backup"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

cp -R lib "$TMP_DIR/lib"
cp pubspec.yaml "$TMP_DIR/pubspec.yaml"
cp analysis_options.yaml "$TMP_DIR/analysis_options.yaml"
cp README.md "$TMP_DIR/README.md"

flutter create \
  --project-name foldable_motion_lab \
  --platforms=android,ios \
  .

rm -rf lib
cp -R "$TMP_DIR/lib" lib
cp "$TMP_DIR/pubspec.yaml" pubspec.yaml
cp "$TMP_DIR/analysis_options.yaml" analysis_options.yaml
cp "$TMP_DIR/README.md" README.md

rm -rf "$TMP_DIR"

flutter pub get

echo ""
echo "Done."
echo "Run:"
echo "  flutter run"
