import '../../../../core/errors/result.dart';
import '../entities/subtask.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskUseCase {
  final TasksRepository _repository;

  UpdateTaskUseCase(this._repository);

  Future<Result<void>> call({
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
  }) {
    return _repository.updateTask(
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
  }
}
