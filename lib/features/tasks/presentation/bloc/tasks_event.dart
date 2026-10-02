import 'package:equatable/equatable.dart';
import '../../domain/entities/subtask.dart';
import '../../domain/entities/task.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class TasksSubscriptionRequested extends TasksEvent {
  final String projectId;

  const TasksSubscriptionRequested({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class TaskFilterChanged extends TasksEvent {
  final TaskStatus? statusFilter;
  final TaskPriority? priorityFilter;
  final String? searchQuery;

  const TaskFilterChanged({
    this.statusFilter,
    this.priorityFilter,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [statusFilter, priorityFilter, searchQuery];
}

class TaskCreateSubmitted extends TasksEvent {
  final String projectId;
  final String title;
  final String description;
  final String createdBy;
  final TaskPriority priority;
  final DateTime? dueDate;
  final String? assignedTo;
  final String? assigneeName;
  final List<Subtask> subtasks;

  const TaskCreateSubmitted({
    required this.projectId,
    required this.title,
    required this.description,
    required this.createdBy,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.assignedTo,
    this.assigneeName,
    this.subtasks = const [],
  });

  @override
  List<Object?> get props => [
        projectId,
        title,
        description,
        createdBy,
        priority,
        dueDate,
        assignedTo,
        assigneeName,
        subtasks,
      ];
}

class TaskUpdateSubmitted extends TasksEvent {
  final String projectId;
  final String taskId;
  final String? title;
  final String? description;
  final TaskStatus? status;
  final TaskPriority? priority;
  final DateTime? dueDate;
  final String? assignedTo;
  final String? assigneeName;
  final List<Subtask>? subtasks;

  const TaskUpdateSubmitted({
    required this.projectId,
    required this.taskId,
    this.title,
    this.description,
    this.status,
    this.priority,
    this.dueDate,
    this.assignedTo,
    this.assigneeName,
    this.subtasks,
  });

  @override
  List<Object?> get props => [
        projectId,
        taskId,
        title,
        description,
        status,
        priority,
        dueDate,
        assignedTo,
        assigneeName,
        subtasks,
      ];
}

class TaskStatusChanged extends TasksEvent {
  final String projectId;
  final String taskId;
  final TaskStatus status;

  const TaskStatusChanged({
    required this.projectId,
    required this.taskId,
    required this.status,
  });

  @override
  List<Object?> get props => [projectId, taskId, status];
}

class TaskSubtaskToggled extends TasksEvent {
  final String projectId;
  final String taskId;
  final String subtaskId;
  final bool isCompleted;

  const TaskSubtaskToggled({
    required this.projectId,
    required this.taskId,
    required this.subtaskId,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [projectId, taskId, subtaskId, isCompleted];
}

class TaskDeleteRequested extends TasksEvent {
  final String projectId;
  final String taskId;

  const TaskDeleteRequested({
    required this.projectId,
    required this.taskId,
  });

  @override
  List<Object?> get props => [projectId, taskId];
}
