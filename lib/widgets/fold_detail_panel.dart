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
        color: const Color(0xFFFCFBF7),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.black.withValues(alpha: 0.045)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          _DetailHeader(
            action: action,
            compactBackOpacity: compactBackOpacity,
            onBack: onBack,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
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

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.action,
    required this.compactBackOpacity,
    required this.onBack,
  });

  final LabActionDefinition action;
  final double compactBackOpacity;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF171816),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          IgnorePointer(
            ignoring: compactBackOpacity < 0.25,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: compactBackOpacity,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Material(
                  color: Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: onBack,
                    borderRadius: BorderRadius.circular(14),
                    child: const SizedBox(
                      width: 42,
                      height: 42,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFC8FF22),
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Icon(action.icon, size: 21, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  action.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.46),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 6,
                  height: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFC8FF22),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  action.accentLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({
    required this.eyebrow,
    required this.title,
    required this.body,
    this.action,
  });

  final String eyebrow;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFE8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eyebrow,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: Color(0xFF777772),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        height: 1.02,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.9,
                      ),
                    ),
                  ],
                ),
              ),
              if (action != null) ...[
                const SizedBox(width: 12),
                action!,
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: const TextStyle(
              color: Color(0xFF74746E),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      children: [
        _Intro(
          eyebrow: '${store.notes.length} NOTES · LIVE STATE',
          title: 'Capture it once. Keep it through every posture.',
          body:
              'Create a note while folded, unfold the phone, and the same list remains active in the right pane.',
          action: FilledButton.icon(
            onPressed: () => _newNote(context),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('New'),
          ),
        ),
        const SizedBox(height: 14),
        ...store.notes.map(
          (note) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ContentCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _IconBlock(icon: Icons.notes_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          note.body,
                          style: const TextStyle(
                            color: Color(0xFF74746E),
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => store.deleteNote(note.id),
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _newNote(BuildContext context) async {
    final title = TextEditingController();
    final body = TextEditingController();
    final create = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: body,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Body'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create'),
          ),
        ],
      ),
    );
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
    final ratio = store.tasks.isEmpty ? 0.0 : complete / store.tasks.length;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      children: [
        _Intro(
          eyebrow: '$complete / ${store.tasks.length} COMPLETE',
          title: 'Your task state travels with the layout.',
          body:
              'Check a task, fold or unfold, and completion remains unchanged.',
          action: FilledButton.icon(
            onPressed: () => _newTask(context),
            icon: const Icon(Icons.add_task_rounded, size: 18),
            label: const Text('Add'),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 6,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFE7E4DC),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: ratio,
              child: const ColoredBox(color: Color(0xFFC8FF22)),
            ),
          ),
        ),
        const SizedBox(height: 14),
        ...store.tasks.map(
          (task) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              decoration: BoxDecoration(
                color: task.done
                    ? const Color(0xFFEFFDCA)
                    : const Color(0xFFF3F1EA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white),
              ),
              child: ListTile(
                onTap: () => store.toggleTask(task.id),
                contentPadding: const EdgeInsets.fromLTRB(12, 3, 8, 3),
                leading: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: task.done ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: task.done ? Colors.black : const Color(0xFFDEDBD2),
                    ),
                  ),
                  child: task.done
                      ? const Icon(
                          Icons.check_rounded,
                          color: Color(0xFFC8FF22),
                          size: 18,
                        )
                      : null,
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    decoration: task.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => store.deleteTask(task.id),
                  icon: const Icon(Icons.close_rounded, size: 18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _newTask(BuildContext context) async {
    final controller = TextEditingController();
    final create = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Task'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );
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
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      children: [
        _Intro(
          eyebrow: store.readerBookmarked ? 'BOOKMARKED · READER' : 'LIVE READER',
          title: 'The detail becomes the whole screen when folded.',
          body:
              'Adjust the reader, then change posture. Content and controls remain the same widget.',
          action: IconButton.filledTonal(
            onPressed: store.toggleReaderBookmark,
            icon: Icon(
              store.readerBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
            ),
          ),
        ),
        const SizedBox(height: 14),
        _ContentCard(
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Reading size',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                onPressed: store.decreaseReaderScale,
                icon: const Icon(Icons.text_decrease_rounded),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF171816),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '${(store.readerScale * 100).round()}%',
                  style: const TextStyle(
                    color: Color(0xFFC8FF22),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: store.increaseReaderScale,
                icon: const Icon(Icons.text_increase_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: const Color(0xFFE7E4DB)),
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: 15 * store.readerScale,
              height: 1.72,
              color: const Color(0xFF252522),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Designing for posture, not just width',
                  style: TextStyle(
                    fontSize: 22,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.7,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'A foldable interface should preserve intent while its geometry changes. The user should not feel that a second application replaced the first one.',
                ),
                SizedBox(height: 14),
                Text(
                  'This lab moves the same selected action between a compact full-screen workspace and an unfolded detail pane.',
                ),
              ],
            ),
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
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      children: [
        const _Intro(
          eyebrow: 'DEMO SETTINGS',
          title: 'Tune the fold presentation.',
          body:
              'These controls change the live lab while keeping the current action and posture.',
        ),
        const SizedBox(height: 14),
        _Setting(
          title: 'Show fold guide',
          subtitle: 'Draw the animated crease between panes.',
          value: store.showFoldGuide,
          onChanged: store.setShowFoldGuide,
        ),
        const SizedBox(height: 10),
        _Setting(
          title: 'Dense action list',
          subtitle: 'Use a compact left-side navigation layout.',
          value: store.denseNavigation,
          onChanged: store.setDenseNavigation,
        ),
      ],
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F2EB),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: Colors.white),
      ),
      child: child,
    );
  }
}

class _IconBlock extends StatelessWidget {
  const _IconBlock({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF171816),
        borderRadius: BorderRadius.circular(13),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 18, color: const Color(0xFFC8FF22)),
    );
  }
}

class _Setting extends StatelessWidget {
  const _Setting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 11, 8, 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F0E9),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          const _IconBlock(icon: Icons.tune_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF85847E),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
