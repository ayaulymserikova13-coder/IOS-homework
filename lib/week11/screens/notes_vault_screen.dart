import 'package:flutter/material.dart';

import '../models/note_item.dart';
import '../services/local_storage_service.dart';
import '../widgets/note_card.dart';

class NotesVaultScreen extends StatefulWidget {
  const NotesVaultScreen({
    super.key,
    required this.storage,
    required this.initialName,
    required this.initialNotes,
    required this.darkMode,
    required this.onThemeChanged,
  });
  final LocalStorageService storage;
  final String initialName;
  final List<NoteItem> initialNotes;
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<NotesVaultScreen> createState() => _NotesVaultScreenState();
}

class _NotesVaultScreenState extends State<NotesVaultScreen> {
  late String name = widget.initialName;
  late List<NoteItem> notes = List.of(widget.initialNotes);
  late final TextEditingController nameController = TextEditingController(
    text: name,
  );
  final noteController = TextEditingController();
  bool saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.storage.hadInvalidNotes) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          message(
            'Some saved notes could not be read. Valid notes were restored.',
          );
        }
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          width: MediaQuery.sizeOf(context).width >= 600 ? 380 : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  // Only one write is allowed at a time. Commit visible state after success.
  Future<void> persist(
    Future<void> Function() write,
    VoidCallback commit,
    String feedback,
  ) async {
    if (saving) return;
    setState(() => saving = true);
    try {
      await write();
      if (!mounted) return;
      setState(commit);
      message(feedback);
    } catch (_) {
      if (mounted) message('Could not save. Please try again.');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  void saveProfile() {
    final value = nameController.text.trim();
    if (value.isEmpty) {
      message('Please enter a username.');
      return;
    }
    persist(() => widget.storage.saveName(value), () {
      name = value;
      nameController.text = value;
    }, 'Profile saved');
  }

  void addNote() {
    final title = noteController.text.trim();
    if (title.isEmpty) {
      message('Please write a note first.');
      return;
    }
    final now = DateTime.now();
    var id = now.microsecondsSinceEpoch.toString();
    while (notes.any((note) => note.id == id)) {
      id = '${id}_';
    }
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final updated = List<NoteItem>.of(notes)
      ..insert(0, NoteItem(id: id, title: title, dateText: date));
    persist(() => widget.storage.saveNotes(updated), () {
      notes = updated;
      noteController.clear();
    }, 'Note added');
  }

  void updateNotes(List<NoteItem> updated, String feedback) => persist(
    () => widget.storage.saveNotes(updated),
    () => notes = updated,
    feedback,
  );

  Widget panel(List<Widget> children) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    ),
  );

  Widget statistic(String label, int value, IconData icon) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colors.primary),
          const SizedBox(height: 10),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = notes.where((note) => note.isCompleted).length;
    final progress = notes.isEmpty ? 0.0 : completed / notes.length;
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    final initials = parts
        .take(2)
        .map((part) => part.characters.first)
        .join()
        .toUpperCase();
    final profile = panel([
      Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            child: Text(
              initials.isEmpty ? 'G' : initials,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                Text('Your personal space', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Text(
        'Profile & Settings',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 6),
      Text('Make this space yours.', style: theme.textTheme.bodySmall),
      const SizedBox(height: 20),
      TextField(
        controller: nameController,
        enabled: !saving,
        maxLength: 60,
        decoration: const InputDecoration(
          labelText: 'Display name',
          isDense: true,
          counterText: '',
        ),
        onSubmitted: (_) => saveProfile(),
      ),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerRight,
        child: FilledButton.icon(
          onPressed: saving ? null : saveProfile,
          icon: const Icon(Icons.check, size: 18),
          label: const Text('Save'),
        ),
      ),
      const Divider(height: 32),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Dark Mode'),
        subtitle: const Text('Easy on the eyes'),
        value: widget.darkMode,
        onChanged: saving
            ? null
            : (value) => persist(
                () => widget.storage.saveTheme(value),
                () => widget.onThemeChanged(value),
                'Appearance saved',
              ),
      ),
      const Divider(height: 32),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.offline_pin_outlined,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Stored on this device. Available offline.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    ]);
    final notesPanel = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'My Notes',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text('Newest first', style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 16),
        panel([
          TextField(
            controller: noteController,
            enabled: !saving,
            minLines: 1,
            maxLines: 3,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: 'Write a new note...',
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: saving ? null : addNote,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add Note'),
            ),
          ),
        ]),
        const SizedBox(height: 20),
        if (notes.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.edit_note_rounded,
                    size: 28,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'A fresh page, a clear mind.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your first note above. We’ll keep it here for you.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        for (final note in notes)
          NoteCard(
            key: ValueKey(note.id),
            note: note,
            onToggle: saving
                ? null
                : () => updateNotes(
                    notes
                        .map(
                          (item) => item.id == note.id ? item.toggled() : item,
                        )
                        .toList(),
                    'Note updated',
                  ),
            onDelete: saving
                ? null
                : () => updateNotes(
                    notes.where((item) => item.id != note.id).toList(),
                    'Note deleted',
                  ),
            onEdit: saving
                ? null
                : (title) => updateNotes(
                    notes
                        .map(
                          (item) =>
                              item.id == note.id ? item.withTitle(title) : item,
                        )
                        .toList(),
                    'Note edited',
                  ),
          ),
      ],
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Notes Vault',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        ),
        leading: Icon(
          Icons.auto_stories_outlined,
          color: theme.colorScheme.primary,
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewport) {
            final mobile = viewport.maxWidth < 700;
            return SingleChildScrollView(
              key: const ValueKey('vault-scroll'),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(
                horizontal: mobile ? 16 : 24,
                vertical: mobile ? 16 : 24,
              ),
              child: Center(
                child: SizedBox(
                  width: (viewport.maxWidth - (mobile ? 32 : 48)).clamp(
                    0.0,
                    1160.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          name == 'Guest User'
                              ? 'YOUR PERSONAL WORKSPACE'
                              : "$name's Workspace",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        name == 'Guest User'
                            ? 'Welcome to your space.'
                            : 'Welcome back, $name!',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.8,
                          fontSize: mobile ? 28 : 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A little clarity for your everyday ideas.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final minCardWidth =
                              112 * MediaQuery.textScalerOf(context).scale(1);
                          final columns = ((width + 12) / (minCardWidth + 12))
                              .floor()
                              .clamp(1, 3);
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              SizedBox(
                                width: (width - (columns - 1) * 12) / columns,
                                child: statistic(
                                  'All Notes',
                                  notes.length,
                                  Icons.layers_outlined,
                                ),
                              ),
                              SizedBox(
                                width: (width - (columns - 1) * 12) / columns,
                                child: statistic(
                                  'Active',
                                  notes.length - completed,
                                  Icons.radio_button_unchecked,
                                ),
                              ),
                              SizedBox(
                                width: (width - (columns - 1) * 12) / columns,
                                child: statistic(
                                  'Completed',
                                  completed,
                                  Icons.task_alt,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          SizedBox(
                            width: 64,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              '${(progress * 100).round()}% complete',
                              style: theme.textTheme.labelMedium,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 28,
                        child: saving
                            ? const Center(
                                child: LinearProgressIndicator(minHeight: 2),
                              )
                            : null,
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) =>
                            viewport.maxWidth >= 700
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: viewport.maxWidth < 1000 ? 3 : 2,
                                    child: notesPanel,
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: viewport.maxWidth < 1000 ? 2 : 1,
                                    child: profile,
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  notesPanel,
                                  const SizedBox(height: 24),
                                  profile,
                                ],
                              ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
