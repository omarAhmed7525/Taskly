import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/dependency_injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../projects/domain/entities/project_member.dart';
import '../../../projects/domain/repositories/projects_repository.dart';
import '../../domain/entities/subtask.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../bloc/tasks_state.dart';

class CreateTaskPage extends StatefulWidget {
  final String projectId;

  const CreateTaskPage({super.key, required this.projectId});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subtaskInputController = TextEditingController();

  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _selectedDueDate;
  String? _selectedAssigneeId;
  String? _selectedAssigneeName;

  final List<Subtask> _subtasks = [];
  List<ProjectMember> _projectMembers = [];
  bool _isLoadingMembers = true;

  @override
  void initState() {
    super.initState();
    _loadProjectMembers();
  }

  void _loadProjectMembers() {
    sl<ProjectsRepository>()
        .getProjectMembersStream(projectId: widget.projectId)
        .listen(
      (members) {
        if (mounted) {
          setState(() {
            _projectMembers = members;
            _isLoadingMembers = false;
          });
        }
      },
      onError: (_) {
        if (mounted) {
          setState(() {
            _isLoadingMembers = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subtaskInputController.dispose();
    super.dispose();
  }

  void _addSubtask() {
    final text = _subtaskInputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _subtasks.add(Subtask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: text,
      ));
      _subtaskInputController.clear();
    });
  }

  void _removeSubtask(String id) {
    setState(() {
      _subtasks.removeWhere((s) => s.id == id);
    });
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final currentUserId = context.read<AuthBloc>().state.user?.uid ?? '';

    context.read<TasksBloc>().add(
          TaskCreateSubmitted(
            projectId: widget.projectId,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            createdBy: currentUserId,
            priority: _selectedPriority,
            dueDate: _selectedDueDate,
            assignedTo: _selectedAssigneeId,
            assigneeName: _selectedAssigneeName,
            subtasks: _subtasks,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
      ),
      body: BlocListener<TasksBloc, TasksState>(
        listener: (context, state) {
          if (state.actionSuccessMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.actionSuccessMessage!)),
            );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title *',
                    hintText: 'e.g. Design app onboarding',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Provide details about this task...',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Icon(Icons.notes),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Priority Selector
                Text(
                  'Priority',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<TaskPriority>(
                  segments: const [
                    ButtonSegment(
                      value: TaskPriority.low,
                      label: Text('Low'),
                      icon: Icon(Icons.arrow_downward, size: 16),
                    ),
                    ButtonSegment(
                      value: TaskPriority.medium,
                      label: Text('Medium'),
                    ),
                    ButtonSegment(
                      value: TaskPriority.high,
                      label: Text('High'),
                      icon: Icon(Icons.arrow_upward, size: 16),
                    ),
                    ButtonSegment(
                      value: TaskPriority.urgent,
                      label: Text('Urgent'),
                      icon: Icon(Icons.priority_high, size: 16),
                    ),
                  ],
                  selected: {_selectedPriority},
                  onSelectionChanged: (set) {
                    setState(() {
                      _selectedPriority = set.first;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Due Date
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: theme.colorScheme.outline.withAlpha(40)),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text('Due Date'),
                    subtitle: Text(
                      _selectedDueDate != null
                          ? DateFormat.yMMMd().format(_selectedDueDate!)
                          : 'No due date chosen',
                    ),
                    trailing: _selectedDueDate != null
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              setState(() {
                                _selectedDueDate = null;
                              });
                            },
                          )
                        : const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _pickDueDate,
                  ),
                ),
                const SizedBox(height: 16),

                // Assignee
                if (!_isLoadingMembers && _projectMembers.isNotEmpty)
                  Card(
                    elevation: 0,
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: theme.colorScheme.outline.withAlpha(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedAssigneeId,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Assign To',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        hint: const Text('Unassigned'),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('Unassigned'),
                          ),
                          ..._projectMembers.map((member) {
                            final displayName = member.name ??
                                member.email ??
                                (member.uid.length > 8
                                    ? member.uid.substring(0, 8)
                                    : member.uid);
                            return DropdownMenuItem<String>(
                              value: member.uid,
                              child: Text(
                                '$displayName (${member.role.name})',
                              ),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _selectedAssigneeId = val;
                            if (val != null) {
                              final member = _projectMembers
                                  .firstWhere((m) => m.uid == val);
                              _selectedAssigneeName = member.name ??
                                  member.email ??
                                  (member.uid.length > 8
                                      ? member.uid.substring(0, 8)
                                      : member.uid);
                            } else {
                              _selectedAssigneeName = null;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Subtasks / Checklist
                Text(
                  'Checklist / Subtasks',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _subtaskInputController,
                        decoration: InputDecoration(
                          hintText: 'Add a subtask...',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onSubmitted: (_) => _addSubtask(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonal(
                      onPressed: _addSubtask,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                if (_subtasks.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _subtasks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final item = _subtasks[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withAlpha(60),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_box_outline_blank, size: 20),
                            const SizedBox(width: 10),
                            Expanded(child: Text(item.title)),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 18, color: Colors.red),
                              onPressed: () => _removeSubtask(item.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 32),

                // Submit Button
                BlocBuilder<TasksBloc, TasksState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: state.isSubmitting ? null : _onSubmit,
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state.isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Create Task',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
