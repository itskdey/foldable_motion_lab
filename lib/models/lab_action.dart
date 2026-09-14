import 'package:flutter/material.dart';

enum LabActionType {
  notes,
  tasks,
  reader,
  settings,
}

class LabActionDefinition {
  const LabActionDefinition({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentLabel,
  });

  final LabActionType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final String accentLabel;
}

const labActions = <LabActionDefinition>[
  LabActionDefinition(
    type: LabActionType.notes,
    title: 'Notes',
    subtitle: 'Capture ideas and keep them with the fold state',
    icon: Icons.edit_note_rounded,
    accentLabel: 'CREATE',
  ),
  LabActionDefinition(
    type: LabActionType.tasks,
    title: 'Tasks',
    subtitle: 'Add, check, and keep work visible across layouts',
    icon: Icons.check_circle_outline_rounded,
    accentLabel: 'DO',
  ),
  LabActionDefinition(
    type: LabActionType.reader,
    title: 'Reader',
    subtitle: 'Read with controls that stay alive while folding',
    icon: Icons.chrome_reader_mode_outlined,
    accentLabel: 'READ',
  ),
  LabActionDefinition(
    type: LabActionType.settings,
    title: 'Fold settings',
    subtitle: 'Tune the demo without leaving the current posture',
    icon: Icons.tune_rounded,
    accentLabel: 'TUNE',
  ),
];

LabActionDefinition actionFor(LabActionType type) {
  return labActions.firstWhere((action) => action.type == type);
}
