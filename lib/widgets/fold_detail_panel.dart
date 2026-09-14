import 'package:flutter/material.dart';

import '../models/lab_action.dart';
import '../state/fold_lab_store.dart';

class FoldDetailPanel extends StatelessWidget {
  const FoldDetailPanel({
    super.key,
    required this.store,
    required this.compactBackOpacity,
    required this.onBack,
  });

  final FoldLabStore store;
  final double compactBackOpacity;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final action = actionFor(store.selectedAction);

    return Container(
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Row(
              children: [
                IgnorePointer(
                  ignoring: compactBackOpacity < 0.25,
                  child: Opacity(
                    opacity: compactBackOpacity,
                    child: IconButton.filledTonal(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                ),
                if (compactBackOpacity > 0.05) const SizedBox(width: 8),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0EC),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Icon(action.icon, size: 21),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        action.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF8B8A84),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC8FF22),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    action.accentLabel,
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.025, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey(store.selectedAction),
                child: _body(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    switch (store.selectedAction) {
      case LabActionType.notes:
        return _Notes(store: store);
      case LabActionType.tasks:
        return _Tasks(store: store);
      case LabActionType.reader:
        return _Reader(store: store);
      case LabActionType.settings:
        return _Settings(store: store);
    }
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.eyebrow, required this.title, required this.body, this.action});
  final String eyebrow;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eyebrow, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1, color: Color(0xFF777772))),
                  const SizedBox(height: 8),
                  Text(title, style: const TextStyle(fontSize: 25, height: 1.02, fontWeight: FontWeight.w900, letterSpacing: -0.9)),
                ],
              ),
            ),
            if (action != null) ...[const SizedBox(width: 12), action!],
          ],
        ),
        const SizedBox(height: 10),
        Text(body, style: const TextStyle(color: Color(0xFF74746E), fontSize: 12, height: 1.5)),
      ],
    );
  }
}

class _Notes extends StatelessWidget {
  const _Notes({required this.store});
  final FoldLabStore store;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        _Intro(
          eyebrow: 'STATEFUL ACTION',
          title: 'Notes stay exactly where you left them.',
          body: 'Create a note while folded, unfold the phone, and the same list remains active in the right pane.',
          action: FilledButton.icon(
            onPressed: () => _newNote(context),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('New note'),
          ),
        ),
        const SizedBox(height: 18),
        ...store.notes.map((note) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF6F5F0), borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.notes_rounded),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(note.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 5),
                  Text(note.body, style: const TextStyle(color: Color(0xFF74746E), fontSize: 12, height: 1.45)),
                ])),
                IconButton(onPressed: () => store.deleteNote(note.id), icon: const Icon(Icons.close_rounded, size: 18)),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Future<void> _newNote(BuildContext context) async {
    final title = TextEditingController();
    final body = TextEditingController();
    final create = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('New note'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: title, autofocus: true, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: body, minLines: 3, maxLines: 5, decoration: const InputDecoration(labelText: 'Body', border: OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Create')),
      ],
    ));
    if (create == true) store.addNote(title: title.text, body: body.text);
    title.dispose();
    body.dispose();
  }
}

class _Tasks extends StatelessWidget {
  const _Tasks({required this.store});
  final FoldLabStore store;

  @override
  Widget build(BuildContext context) {
    final complete = store.tasks.where((task) => task.done).length;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        _Intro(
          eyebrow: '$complete / ${store.tasks.length} COMPLETE',
          title: 'Tasks survive every posture change.',
          body: 'Check a task, fold or unfold, and the completion state remains unchanged.',
          action: FilledButton.icon(onPressed: () => _newTask(context), icon: const Icon(Icons.add_task_rounded, size: 18), label: const Text('Add task')),
        ),
        const SizedBox(height: 18),
        ...store.tasks.map((task) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: task.done ? const Color(0xFFEFFFD0) : const Color(0xFFF6F5F0),
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              onTap: () => store.toggleTask(task.id),
              leading: CircleAvatar(
                backgroundColor: task.done ? Colors.black : Colors.white,
                child: task.done ? const Icon(Icons.check_rounded, color: Colors.white, size: 18) : null,
              ),
              title: Text(task.title, style: TextStyle(fontWeight: FontWeight.w700, decoration: task.done ? TextDecoration.lineThrough : null)),
              trailing: IconButton(onPressed: () => store.deleteTask(task.id), icon: const Icon(Icons.close_rounded, size: 18)),
            ),
          ),
        )),
      ],
    );
  }

  Future<void> _newTask(BuildContext context) async {
    final controller = TextEditingController();
    final create = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('Add task'),
      content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(labelText: 'Task', border: OutlineInputBorder())),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Add')),
      ],
    ));
    if (create == true) store.addTask(controller.text);
    controller.dispose();
  }
}

class _Reader extends StatelessWidget {
  const _Reader({required this.store});
  final FoldLabStore store;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        _Intro(
          eyebrow: store.readerBookmarked ? 'BOOKMARKED' : 'LIVE READER',
          title: 'The detail becomes the whole screen when folded.',
          body: 'Adjust the reader, then change posture. Content and controls remain the same widget.',
          action: IconButton.filledTonal(
            onPressed: store.toggleReaderBookmark,
            icon: Icon(store.readerBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFF3F2ED), borderRadius: BorderRadius.circular(18)),
          child: Row(children: [
            const Expanded(child: Text('Reading size', style: TextStyle(fontWeight: FontWeight.w800))),
            IconButton(onPressed: store.decreaseReaderScale, icon: const Icon(Icons.text_decrease_rounded)),
            Text('${(store.readerScale * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w800)),
            IconButton(onPressed: store.increaseReaderScale, icon: const Icon(Icons.text_increase_rounded)),
          ]),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(color: const Color(0xFFF9F8F4), borderRadius: BorderRadius.circular(24)),
          child: DefaultTextStyle.merge(
            style: TextStyle(fontSize: 15 * store.readerScale, height: 1.7, color: const Color(0xFF252522)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Designing for posture, not just width', style: TextStyle(fontSize: 22, height: 1.1, fontWeight: FontWeight.w900)),
              SizedBox(height: 16),
              Text('A foldable interface should preserve intent while its geometry changes. The user should not feel that a second application replaced the first one.'),
              SizedBox(height: 14),
              Text('This lab moves the same selected action between a compact full-screen workspace and an unfolded detail pane.'),
            ]),
          ),
        ),
      ],
    );
  }
}

class _Settings extends StatelessWidget {
  const _Settings({required this.store});
  final FoldLabStore store;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const _Intro(
          eyebrow: 'DEMO SETTINGS',
          title: 'Tune the fold presentation.',
          body: 'These controls change the live lab while keeping the current action and posture.',
        ),
        const SizedBox(height: 18),
        _Setting(title: 'Show fold guide', subtitle: 'Draw the animated crease between panes.', value: store.showFoldGuide, onChanged: store.setShowFoldGuide),
        const SizedBox(height: 10),
        _Setting(title: 'Dense action list', subtitle: 'Use a compact left-side navigation layout.', value: store.denseNavigation, onChanged: store.setDenseNavigation),
      ],
    );
  }
}

class _Setting extends StatelessWidget {
  const _Setting({required this.title, required this.subtitle, required this.value, required this.onChanged});
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
    decoration: BoxDecoration(color: const Color(0xFFF5F4EF), borderRadius: BorderRadius.circular(20)),
    child: Row(children: [
      const Icon(Icons.tune_rounded),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        Text(subtitle, style: const TextStyle(color: Color(0xFF85847E), fontSize: 10)),
      ])),
      Switch.adaptive(value: value, onChanged: onChanged),
    ]),
  );
}
