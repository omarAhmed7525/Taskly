import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/dependency_injection.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/project_member.dart';
import '../../domain/usecases/add_project_member.dart';
import '../../domain/usecases/get_project_members.dart';
import '../../domain/usecases/remove_project_member.dart';
import '../../domain/usecases/update_member_role.dart';
import '../widgets/project_member_tile.dart';

class ProjectMembersPage extends StatefulWidget {
  final String projectId;
  final bool isOwner;

  const ProjectMembersPage({
    super.key,
    required this.projectId,
    required this.isOwner,
  });

  @override
  State<ProjectMembersPage> createState() => _ProjectMembersPageState();
}

class _ProjectMembersPageState extends State<ProjectMembersPage> {
  late final GetProjectMembersUseCase _getMembersUseCase;
  late final AddProjectMemberUseCase _addMemberUseCase;
  late final UpdateMemberRoleUseCase _updateRoleUseCase;
  late final RemoveProjectMemberUseCase _removeMemberUseCase;

  @override
  void initState() {
    super.initState();
    _getMembersUseCase = sl<GetProjectMembersUseCase>();
    _addMemberUseCase = sl<AddProjectMemberUseCase>();
    _updateRoleUseCase = sl<UpdateMemberRoleUseCase>();
    _removeMemberUseCase = sl<RemoveProjectMemberUseCase>();
  }

  void _showAddMemberDialog(BuildContext context, AppLocalizations l10n) {
    final userIdController = TextEditingController();
    ProjectRole selectedRole = ProjectRole.member;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.addMember),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userIdController,
                decoration: InputDecoration(
                  labelText: l10n.memberUserId,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ProjectRole>(
                initialValue: selectedRole,
                decoration: InputDecoration(
                  labelText: l10n.memberRole,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: ProjectRole.values
                    .where((r) => r != ProjectRole.owner)
                    .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedRole = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final uid = userIdController.text.trim();
                if (uid.isNotEmpty) {
                  Navigator.of(dialogCtx).pop();
                  final result = await _addMemberUseCase(
                    projectId: widget.projectId,
                    memberUserId: uid,
                    role: selectedRole,
                  );
                  result.fold(
                    (err) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(err), backgroundColor: Colors.red),
                    ),
                    (_) {},
                  );
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.members),
      ),
      floatingActionButton: widget.isOwner
          ? FloatingActionButton(
              onPressed: () => _showAddMemberDialog(context, l10n),
              child: const Icon(Icons.person_add),
            )
          : null,
      body: StreamBuilder<List<ProjectMember>>(
        stream: _getMembersUseCase(projectId: widget.projectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(': '));
          }

          final members = snapshot.data ?? [];
          if (members.isEmpty) {
            return const Center(child: Text('No members found'));
          }

          return ListView.separated(
            padding: const EdgeInsetsDirectional.all(16),
            itemCount: members.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final member = members[index];
              return ProjectMemberTile(
                member: member,
                canManage: widget.isOwner,
                onRoleChanged: (newRole) async {
                  await _updateRoleUseCase(
                    projectId: widget.projectId,
                    memberUserId: member.uid,
                    newRole: newRole,
                  );
                },
                onRemove: () async {
                  await _removeMemberUseCase(
                    projectId: widget.projectId,
                    memberUserId: member.uid,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
