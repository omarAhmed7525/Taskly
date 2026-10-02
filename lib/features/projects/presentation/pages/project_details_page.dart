import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/bloc/tasks_bloc.dart';
import '../../../tasks/presentation/bloc/tasks_event.dart';
import '../../../tasks/presentation/bloc/tasks_state.dart';
import '../../../tasks/presentation/widgets/task_card.dart';
import '../../domain/entities/project.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';
import '../widgets/project_status_chip.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Project project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  TaskStatus? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    context.read<TasksBloc>().add(
          TasksSubscriptionRequested(projectId: widget.project.id),
        );
  }

  void _showDeleteDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteProjectConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context
                  .read<ProjectsBloc>()
                  .add(ProjectDeleteRequested(projectId: widget.project.id));
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentUserId = context.read<AuthBloc>().state.user?.uid ?? '';
    final isOwner = widget.project.ownerId == currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        actions: [
          if (isOwner)
            PopupMenuButton<String>(
              onSelected: (val) {
                if (val == 'edit') {
                  context.push(
                    '/projects/${widget.project.id}/edit',
                    extra: widget.project,
                  );
                } else if (val == 'delete') {
                  _showDeleteDialog(context, l10n);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.edit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline,
                          size: 20, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(l10n.delete,
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/projects/${widget.project.id}/tasks/create');
        },
        icon: const Icon(Icons.add_task),
        label: const Text('Add Task'),
      ),
      body: BlocListener<ProjectsBloc, ProjectsState>(
        listener: (context, state) {
          if (state.actionSuccessMessage == 'Project deleted successfully') {
            context.pop();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.project.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ProjectStatusChip(status: widget.project.status),
                ],
              ),
              const SizedBox(height: 12),

              if (widget.project.description.isNotEmpty) ...[
                Text(
                  widget.project.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Meta row (Deadline & Members)
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      color: theme.colorScheme.surfaceContainerHighest
                          .withAlpha(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.project.deadline != null
                                    ? DateFormat.MMMd()
                                        .format(widget.project.deadline!)
                                    : l10n.noDeadline,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      color: theme.colorScheme.surfaceContainerHighest
                          .withAlpha(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          context.push(
                            '/projects/${widget.project.id}/members',
                            extra: {
                              'projectId': widget.project.id,
                              'isOwner': isOwner,
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.people_outline, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.members,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tasks Section with Progress and Filter
              BlocBuilder<TasksBloc, TasksState>(
                builder: (context, state) {
                  final allTasks = state.tasks;
                  final filteredTasks = _selectedStatusFilter == null
                      ? allTasks
                      : allTasks
                          .where((t) => t.status == _selectedStatusFilter)
                          .toList();

                  final completedCount =
                      allTasks.where((t) => t.status == TaskStatus.done).length;
                  final progress = allTasks.isEmpty
                      ? 0.0
                      : completedCount / allTasks.length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tasks Section Title & Progress
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tasks (${allTasks.length})',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (allTasks.isNotEmpty)
                            Text(
                              '${(progress * 100).toInt()}% Done',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (allTasks.isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress == 1.0
                                  ? Colors.green
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Status Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FilterChip(
                              label: const Text('All'),
                              selected: _selectedStatusFilter == null,
                              onSelected: (_) {
                                setState(() {
                                  _selectedStatusFilter = null;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            FilterChip(
                              label: const Text('To Do'),
                              selected:
                                  _selectedStatusFilter == TaskStatus.todo,
                              onSelected: (_) {
                                setState(() {
                                  _selectedStatusFilter =
                                      _selectedStatusFilter == TaskStatus.todo
                                          ? null
                                          : TaskStatus.todo;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            FilterChip(
                              label: const Text('In Progress'),
                              selected:
                                  _selectedStatusFilter == TaskStatus.inProgress,
                              onSelected: (_) {
                                setState(() {
                                  _selectedStatusFilter =
                                      _selectedStatusFilter ==
                                              TaskStatus.inProgress
                                          ? null
                                          : TaskStatus.inProgress;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            FilterChip(
                              label: const Text('In Review'),
                              selected:
                                  _selectedStatusFilter == TaskStatus.review,
                              onSelected: (_) {
                                setState(() {
                                  _selectedStatusFilter =
                                      _selectedStatusFilter == TaskStatus.review
                                          ? null
                                          : TaskStatus.review;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            FilterChip(
                              label: const Text('Done'),
                              selected:
                                  _selectedStatusFilter == TaskStatus.done,
                              onSelected: (_) {
                                setState(() {
                                  _selectedStatusFilter =
                                      _selectedStatusFilter == TaskStatus.done
                                          ? null
                                          : TaskStatus.done;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tasks List or Empty State
                      if (state.status == TasksStatus.loading &&
                          allTasks.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (filteredTasks.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withAlpha(40),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.outline.withAlpha(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withAlpha(150),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _selectedStatusFilter != null
                                    ? 'No tasks found for this filter'
                                    : 'No tasks created yet',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Add tasks to start organizing project work.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return TaskCard(
                              task: task,
                              onTap: () {
                                context.push(
                                  '/projects/${widget.project.id}/tasks/${task.id}',
                                  extra: task,
                                );
                              },
                              onStatusChanged: (newStatus) {
                                context.read<TasksBloc>().add(
                                      TaskStatusChanged(
                                        projectId: widget.project.id,
                                        taskId: task.id,
                                        status: newStatus,
                                      ),
                                    );
                              },
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
