import 'package:flutter/foundation.dart';

import '../models/lab_action.dart';

class LabNote {
  const LabNote({required this.id, required this.title, required this.body});
  final int id;
  final String title;
  final String body;
}

class LabTask {
  const LabTask({required this.id, required this.title, required this.done});
  final int id;
  final String title;
  final bool done;

  LabTask copyWith({String? title, bool? done}) => LabTask(
        id: id,
        title: title ?? this.title,
        done: done ?? this.done,
      );
}

class FoldLabStore extends ChangeNotifier {
  LabActionType _selectedAction = LabActionType.reader;

  final List<LabNote> _notes = [
    const LabNote(
      id: 1,
      title: 'Fold behavior',
      body: 'Folded actions open full screen. Unfolded actions update the detail pane.',
    ),
    const LabNote(
      id: 2,
      title: 'State continuity',
      body: 'The selected tool and its content stay alive while the device changes posture.',
    ),
  ];

  final List<LabTask> _tasks = [
    const LabTask(id: 1, title: 'Open an action while folded', done: true),
    const LabTask(id: 2, title: 'Unfold while the action is still open', done: false),
    const LabTask(id: 3, title: 'Fold again and verify state is preserved', done: false),
  ];

  int _nextNoteId = 3;
  int _nextTaskId = 4;
  double _readerScale = 1.0;
  bool _readerBookmarked = false;
  bool _showFoldGuide = true;
  bool _denseNavigation = false;

  LabActionType get selectedAction => _selectedAction;
  List<LabNote> get notes => List.unmodifiable(_notes);
  List<LabTask> get tasks => List.unmodifiable(_tasks);
  double get readerScale => _readerScale;
  bool get readerBookmarked => _readerBookmarked;
  bool get showFoldGuide => _showFoldGuide;
  bool get denseNavigation => _denseNavigation;

  void selectAction(LabActionType type) {
    if (_selectedAction == type) return;
    _selectedAction = type;
    notifyListeners();
  }

  void addNote({required String title, required String body}) {
    final trimmedTitle = title.trim();
    final trimmedBody = body.trim();
    if (trimmedTitle.isEmpty && trimmedBody.isEmpty) return;

    _notes.insert(
      0,
      LabNote(
        id: _nextNoteId++,
        title: trimmedTitle.isEmpty ? 'Untitled note' : trimmedTitle,
        body: trimmedBody.isEmpty ? 'No additional text.' : trimmedBody,
      ),
    );
    notifyListeners();
  }

  void deleteNote(int id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  void addTask(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    _tasks.insert(0, LabTask(id: _nextTaskId++, title: trimmed, done: false));
    notifyListeners();
  }

  void toggleTask(int id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;
    final task = _tasks[index];
    _tasks[index] = task.copyWith(done: !task.done);
    notifyListeners();
  }

  void deleteTask(int id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void increaseReaderScale() {
    _readerScale = (_readerScale + 0.1).clamp(0.8, 1.5).toDouble();
    notifyListeners();
  }

  void decreaseReaderScale() {
    _readerScale = (_readerScale - 0.1).clamp(0.8, 1.5).toDouble();
    notifyListeners();
  }

  void toggleReaderBookmark() {
    _readerBookmarked = !_readerBookmarked;
    notifyListeners();
  }

  void setShowFoldGuide(bool value) {
    if (_showFoldGuide == value) return;
    _showFoldGuide = value;
    notifyListeners();
  }

  void setDenseNavigation(bool value) {
    if (_denseNavigation == value) return;
    _denseNavigation = value;
    notifyListeners();
  }
}
