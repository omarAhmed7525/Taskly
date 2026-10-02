import 'package:flutter/material.dart';
import '../../domain/entities/subtask.dart';

class SubtasksChecklist extends StatelessWidget {
  final List<Subtask> subtasks;
  final bool isInteractive;
  final void Function(String subtaskId, bool isCompleted)? onToggle;
  final void Function(String subtaskId)? onDelete;

  const SubtasksChecklist({
    super.key,
    required this.subtasks,
    this.isInteractive = true,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (subtasks.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subtasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 6),
          itemBuilder: (context, index) {
            final subtask = subtasks[index];
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.outline.withAlpha(30),
                ),
              ),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                leading: Checkbox(
                  value: subtask.isCompleted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: isInteractive && onToggle != null
                      ? (val) => onToggle!(subtask.id, val ?? false)
                      : null,
                ),
                title: Text(
                  subtask.title,
                  style: TextStyle(
                    decoration: subtask.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: subtask.isCompleted
                        ? theme.colorScheme.onSurfaceVariant.withAlpha(150)
                        : theme.colorScheme.onSurface,
                    fontWeight: subtask.isCompleted
                        ? FontWeight.normal
                        : FontWeight.w500,
                  ),
                ),
                trailing: onDelete != null
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => onDelete!(subtask.id),
                        tooltip: 'Remove subtask',
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
