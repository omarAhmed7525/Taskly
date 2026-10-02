import '../../../../core/errors/result.dart';
import '../entities/subtask.dart';
import '../entities/task.dart';

abstract class TasksRepository {
  Stream<List<Task>> getTasksStream({
    required String projectId,
    TaskStatus? statusFilter,
    TaskPriority? priorityFilter,
    String? assigneeFilter,
  });

  Future<Result<Task>> getTask({
    required String projectId,
    required String taskId,
  });

  Future<Result<Task>> createTask({
    required String projectId,
    required String title,
    required String description,
    required String createdBy,
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
    String? assignedTo,
    String? assigneeName,
    List<Subtask> subtasks = const [],
  });

  Future<Result<void>> updateTask({
    required String projectId,
    required String taskId,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    String? assignedTo,
    String? assigneeName,
    List<Subtask>? subtasks,
  });

  Future<Result<void>> updateTaskStatus({
    required String projectId,
    required String taskId,
    required TaskStatus status,
  });

  Future<Result<void>> toggleSubtask({
    required String projectId,
    required String taskId,
    required String subtaskId,
    required bool isCompleted,
  });

  Future<Result<void>> deleteTask({
    required String projectId,
    required String taskId,
  });
}
