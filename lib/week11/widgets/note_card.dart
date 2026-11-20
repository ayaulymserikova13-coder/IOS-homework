import 'package:flutter/material.dart';

import '../models/note_item.dart';

class NoteCard extends StatefulWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });
  final NoteItem note;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final ValueChanged<String>? onEdit;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late final TextEditingController controller = TextEditingController(
    text: widget.note.title,
  );
  bool editing = false;
  String? error;

  @override
  void didUpdateWidget(covariant NoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note.title != widget.note.title) {
      controller.text = widget.note.title;
      editing = false;
      error = null;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void save() {
    final value = controller.text.trim();
    if (value.isEmpty) {
      setState(() => error = 'Please enter some text.');
    } else if (value == widget.note.title) {
      setState(() => editing = false);
    } else {
      widget.onEdit?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    final theme = Theme.of(context);
    return Card(
      color: note.isCompleted
          ? Color.alphaBlend(
              theme.colorScheme.primary.withValues(alpha: 0.045),
              theme.colorScheme.surface,
            )
          : null,
      margin: const EdgeInsets.only(bottom: 12),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: note.isCompleted,
                onChanged: widget.onToggle == null
                    ? null
                    : (_) => widget.onToggle!(),
                semanticLabel: 'Complete ${note.title}',
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (editing) ...[
                        TextField(
                          controller: controller,
                          autofocus: true,
                          enabled: widget.onEdit != null,
                          minLines: 1,
                          maxLines: 5,
                          maxLength: 500,
                          decoration: InputDecoration(
                            labelText: 'Edit note',
                            errorText: error,
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          children: [
                            TextButton(
                              onPressed: widget.onEdit == null
                                  ? null
                                  : () => setState(() {
                                      editing = false;
                                      error = null;
                                      controller.text = note.title;
                                    }),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: widget.onEdit == null ? null : save,
                              child: const Text('Save note'),
                            ),
                          ],
                        ),
                      ] else
                        Text(
                          note.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            height: 1.4,
                            fontSize: 15,
                            color: note.isCompleted
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.colorScheme.onSurface,
                            decoration: note.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        '${note.dateText}  •  ${note.isCompleted ? 'Completed' : 'Active'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Edit note',
                              onPressed: widget.onEdit == null || editing
                                  ? null
                                  : () => setState(() => editing = true),
                              icon: const Icon(Icons.edit_outlined, size: 18),
                            ),
                            IconButton(
                              tooltip: 'Delete note',
                              onPressed: widget.onDelete,
                              icon: const Icon(Icons.delete_outline, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
