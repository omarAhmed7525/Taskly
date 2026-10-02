import '../../../../core/errors/result.dart';
import '../entities/subtask.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class CreateTaskUseCase {
  final TasksRepository _repository;

  CreateTaskUseCase(this._repository);

  Future<Result<Task>> call({
    required String projectId,
    required String title,
    required String description,
    required String createdBy,
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
    String? assignedTo,
    String? assigneeName,
    List<Subtask> subtasks = const [],
  }) {
    return _repository.createTask(
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
  }
}
