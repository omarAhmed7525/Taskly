import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

class TaskStatusChip extends StatelessWidget {
  final TaskStatus status;
  final bool isInteractive;
  final ValueChanged<TaskStatus>? onSelected;

  const TaskStatusChip({
    super.key,
    required this.status,
    this.isInteractive = false,
    this.onSelected,
  });

  Color _getBackgroundColor(BuildContext context) {
    switch (status) {
      case TaskStatus.todo:
        return Colors.blueGrey.withAlpha(40);
      case TaskStatus.inProgress:
        return Colors.blue.withAlpha(40);
      case TaskStatus.review:
        return Colors.orange.withAlpha(40);
      case TaskStatus.done:
        return Colors.green.withAlpha(40);
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (status) {
      case TaskStatus.todo:
        return Colors.blueGrey;
      case TaskStatus.inProgress:
        return Colors.blue.shade700;
      case TaskStatus.review:
        return Colors.orange.shade800;
      case TaskStatus.done:
        return Colors.green.shade700;
    }
  }

  String _getLabel() {
    switch (status) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.review:
        return 'In Review';
      case TaskStatus.done:
        return 'Completed';
    }
  }

  IconData _getIcon() {
    switch (status) {
      case TaskStatus.todo:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.timelapse;
      case TaskStatus.review:
        return Icons.rate_review_outlined;
      case TaskStatus.done:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getTextColor(context).withAlpha(60),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(),
            size: 14,
            color: _getTextColor(context),
          ),
          const SizedBox(width: 5),
          Text(
            _getLabel(),
            style: TextStyle(
              color: _getTextColor(context),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );

    if (!isInteractive || onSelected == null) {
      return chip;
    }

    return PopupMenuButton<TaskStatus>(
      onSelected: onSelected,
      tooltip: 'Change Status',
      itemBuilder: (context) => TaskStatus.values.map((s) {
        return PopupMenuItem<TaskStatus>(
          value: s,
          child: Row(
            children: [
              TaskStatusChip(status: s),
              if (s == status) ...[
                const Spacer(),
                const Icon(Icons.check, size: 18),
              ],
            ],
          ),
        );
      }).toList(),
      child: chip,
    );
  }
}
