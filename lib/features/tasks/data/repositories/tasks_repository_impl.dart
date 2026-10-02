import '../../../../core/errors/result.dart';
import '../../domain/entities/subtask.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_datasource.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource _remoteDataSource;

  TasksRepositoryImpl({required TasksRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<List<Task>> getTasksStream({
    required String projectId,
    TaskStatus? statusFilter,
    TaskPriority? priorityFilter,
    String? assigneeFilter,
  }) {
    return _remoteDataSource
        .getTasksStream(
          projectId: projectId,
          statusFilter: statusFilter,
          priorityFilter: priorityFilter,
          assigneeFilter: assigneeFilter,
        )
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Result<Task>> getTask({
    required String projectId,
    required String taskId,
  }) async {
    try {
      final model = await _remoteDataSource.getTask(
        projectId: projectId,
        taskId: taskId,
      );
      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
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
  }) async {
    try {
      final model = await _remoteDataSource.createTask(
        projectId: projectId,
        title: title,
        description: description,
        createdBy: createdBy,
        priority: priority,
        dueDate: dueDate,
        assignedTo: assignedTo,
        assigneeName: assigneeName,
        subtasks: subtasks,
      );
      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
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
  }) async {
    try {
      await _remoteDataSource.updateTask(
        projectId: projectId,
        taskId: taskId,
        title: title,
        description: description,
        status: status,
        priority: priority,
        dueDate: dueDate,
        assignedTo: assignedTo,
        assigneeName: assigneeName,
        subtasks: subtasks,
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> updateTaskStatus({
    required String projectId,
    required String taskId,
    required TaskStatus status,
  }) async {
    try {
      await _remoteDataSource.updateTaskStatus(
        projectId: projectId,
        taskId: taskId,
        status: status,
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> toggleSubtask({
    required String projectId,
    required String taskId,
    required String subtaskId,
    required bool isCompleted,
  }) async {
    try {
      await _remoteDataSource.toggleSubtask(
        projectId: projectId,
        taskId: taskId,
        subtaskId: subtaskId,
        isCompleted: isCompleted,
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> deleteTask({
    required String projectId,
    required String taskId,
  }) async {
    try {
      await _remoteDataSource.deleteTask(
        projectId: projectId,
        taskId: taskId,
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
