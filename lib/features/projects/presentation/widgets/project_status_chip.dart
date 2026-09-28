import 'package:flutter/material.dart';
import '../../domain/entities/project.dart';

class ProjectStatusChip extends StatelessWidget {
  final ProjectStatus status;

  const ProjectStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
      case ProjectStatus.active:
        bg = Colors.green.withAlpha(40);
        fg = Colors.green.shade800;
        break;
      case ProjectStatus.completed:
        bg = Colors.blue.withAlpha(40);
        fg = Colors.blue.shade800;
        break;
      case ProjectStatus.archived:
        bg = Colors.grey.withAlpha(50);
        fg = Colors.grey.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
