import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

enum TasksStatus {
  initial,
  loading,
  success,
  failure,
}

class TasksState extends Equatable {
  final TasksStatus status;
  final List<Task> tasks;
  final TaskStatus? statusFilter;
  final TaskPriority? priorityFilter;
  final String searchQuery;
  final bool isSubmitting;
  final String? errorMessage;
  final String? actionSuccessMessage;

  const TasksState({
    this.status = TasksStatus.initial,
    this.tasks = const [],
    this.statusFilter,
    this.priorityFilter,
    this.searchQuery = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.actionSuccessMessage,
  });

  List<Task> get filteredTasks {
    return tasks.where((task) {
      if (statusFilter != null && task.status != statusFilter) {
        return false;
      }
      if (priorityFilter != null && task.priority != priorityFilter) {
        return false;
      }
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final matchesTitle = task.title.toLowerCase().contains(query);
        final matchesDesc = task.description.toLowerCase().contains(query);
        if (!matchesTitle && !matchesDesc) return false;
      }
      return true;
    }).toList();
  }

  int get totalTasksCount => tasks.length;
  int get completedTasksCount =>
      tasks.where((t) => t.status == TaskStatus.done).length;
  double get projectProgress =>
      tasks.isEmpty ? 0.0 : completedTasksCount / tasks.length;

  TasksState copyWith({
    TasksStatus? status,
    List<Task>? tasks,
    TaskStatus? Function()? statusFilter,
    TaskPriority? Function()? priorityFilter,
    String? searchQuery,
    bool? isSubmitting,
    String? Function()? errorMessage,
    String? Function()? actionSuccessMessage,
  }) {
    return TasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
      priorityFilter:
          priorityFilter != null ? priorityFilter() : this.priorityFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      actionSuccessMessage: actionSuccessMessage != null
          ? actionSuccessMessage()
          : this.actionSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tasks,
        statusFilter,
        priorityFilter,
        searchQuery,
        isSubmitting,
        errorMessage,
        actionSuccessMessage,
      ];
}
