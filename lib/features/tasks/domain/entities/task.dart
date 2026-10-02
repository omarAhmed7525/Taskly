import 'package:equatable/equatable.dart';
import 'subtask.dart';

enum TaskStatus {
  todo,
  inProgress,
  review,
  done;

  String toMapString() => name;

  static TaskStatus fromString(String? value) {
    return TaskStatus.values.firstWhere(
      (e) => e.name == value?.toLowerCase(),
      orElse: () => TaskStatus.todo,
    );
  }
}

enum TaskPriority {
  low,
  medium,
  high,
  urgent;

  String toMapString() => name;

  static TaskPriority fromString(String? value) {
    return TaskPriority.values.firstWhere(
      (e) => e.name == value?.toLowerCase(),
      orElse: () => TaskPriority.medium,
    );
  }
}

class Task extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final String? assignedTo;
  final String? assigneeName;
  final String createdBy;
  final List<Subtask> subtasks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Task({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    this.status = TaskStatus.todo,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.assignedTo,
    this.assigneeName,
    required this.createdBy,
    this.subtasks = const [],
    this.createdAt,
    this.updatedAt,
  });

  Task copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    String? assignedTo,
    String? assigneeName,
    String? createdBy,
    List<Subtask>? subtasks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      assignedTo: assignedTo ?? this.assignedTo,
      assigneeName: assigneeName ?? this.assigneeName,
      createdBy: createdBy ?? this.createdBy,
      subtasks: subtasks ?? this.subtasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get completedSubtasksCount =>
      subtasks.where((s) => s.isCompleted).length;

  double get progressPercentage =>
      subtasks.isEmpty ? (status == TaskStatus.done ? 1.0 : 0.0) : completedSubtasksCount / subtasks.length;

  bool get isOverdue =>
      dueDate != null &&
      status != TaskStatus.done &&
      DateTime.now().isAfter(dueDate!);

  @override
  List<Object?> get props => [
        id,
        projectId,
        title,
        description,
        status,
        priority,
        dueDate,
        assignedTo,
        assigneeName,
        createdBy,
        subtasks,
        createdAt,
        updatedAt,
      ];
}
