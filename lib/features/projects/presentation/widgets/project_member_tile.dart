import 'package:flutter/material.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/project_member.dart';

class ProjectMemberTile extends StatelessWidget {
  final ProjectMember member;
  final VoidCallback? onRemove;
  final ValueChanged<ProjectRole>? onRoleChanged;
  final bool canManage;

  const ProjectMemberTile({
    super.key,
    required this.member,
    this.onRemove,
    this.onRoleChanged,
    this.canManage = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          (member.name?.isNotEmpty ?? false)
              ? member.name![0].toUpperCase()
              : member.uid.substring(0, 1).toUpperCase(),
        ),
      ),
      title: Text(member.name ?? member.email ?? member.uid),
      subtitle: Text('Role: '),
      trailing: canManage && member.role != ProjectRole.owner
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onRoleChanged != null)
                  PopupMenuButton<ProjectRole>(
                    icon: const Icon(Icons.shield_outlined),
                    onSelected: onRoleChanged,
                    itemBuilder: (context) => ProjectRole.values
                        .where((r) => r != ProjectRole.owner)
                        .map(
                          (r) => PopupMenuItem(
                            value: r,
                            child: Text(r.name),
                          ),
                        )
                        .toList(),
                  ),
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onRemove,
                  ),
              ],
            )
          : null,
    );
  }
}
