import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../bloc/tasks_state.dart';
import '../widgets/subtasks_checklist.dart';
import '../widgets/task_priority_chip.dart';
import '../widgets/task_status_chip.dart';

class TaskDetailsPage extends StatelessWidget {
  final Task initialTask;

  const TaskDetailsPage({super.key, required this.initialTask});

  void _showDeleteDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text(
          'Are you sure you want to permanently delete this task?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<TasksBloc>().add(
                    TaskDeleteRequested(
                      projectId: task.projectId,
                      taskId: task.id,
                    ),
                  );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<TasksBloc, TasksState>(
      listener: (context, state) {
        if (state.actionSuccessMessage == 'Task deleted successfully') {
          context.pop();
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        // Find latest updated task from state if available
        final task = state.tasks.firstWhere(
          (t) => t.id == initialTask.id,
          orElse: () => initialTask,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Task Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Task',
                onPressed: () {
                  context.push(
                    '/projects/${task.projectId}/tasks/${task.id}/edit',
                    extra: task,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Delete Task',
                onPressed: () => _showDeleteDialog(context, task),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Status & Priority
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TaskPriorityChip(priority: task.priority),
                    TaskStatusChip(
                      status: task.status,
                      isInteractive: true,
                      onSelected: (newStatus) {
                        context.read<TasksBloc>().add(
                              TaskStatusChanged(
                                projectId: task.projectId,
                                taskId: task.id,
                                status: newStatus,
                              ),
                            );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  task.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: task.status == TaskStatus.done
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                if (task.description.isNotEmpty) ...[
                  Text(
                    'Description',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.description,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                ],

                // Metadata Cards (Due Date & Assignee)
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Due date
                        Row(
                          children: [
                            Icon(
                              task.isOverdue
                                  ? Icons.warning_amber_rounded
                                  : Icons.calendar_today_outlined,
                              size: 20,
                              color: task.isOverdue
                                  ? Colors.red
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 12),
                            const Text('Due Date'),
                            const Spacer(),
                            Text(
                              task.dueDate != null
                                  ? DateFormat.yMMMd().format(task.dueDate!)
                                  : 'No due date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: task.isOverdue ? Colors.red : null,
                              ),
                            ),
                          ],
                        ),

                        // Assignee
                        if (task.assigneeName != null &&
                            task.assigneeName!.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 20),
                              const SizedBox(width: 12),
                              const Text('Assigned To'),
                              const Spacer(),
                              Text(
                                task.assigneeName!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Checklist / Subtasks Section
                if (task.subtasks.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Checklist',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${task.completedSubtasksCount} of ${task.subtasks.length} done',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: task.progressPercentage,
                      minHeight: 8,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        task.progressPercentage == 1.0
                            ? Colors.green
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SubtasksChecklist(
                    subtasks: task.subtasks,
                    isInteractive: true,
                    onToggle: (subtaskId, isCompleted) {
                      context.read<TasksBloc>().add(
                            TaskSubtaskToggled(
                              projectId: task.projectId,
                              taskId: task.id,
                              subtaskId: subtaskId,
                              isCompleted: isCompleted,
                            ),
                          );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
