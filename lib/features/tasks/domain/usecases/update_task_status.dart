import '../../../../core/errors/result.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskStatusUseCase {
  final TasksRepository _repository;

  UpdateTaskStatusUseCase(this._repository);

  Future<Result<void>> call({
    required String projectId,
    required String taskId,
    required TaskStatus status,
  }) {
    return _repository.updateTaskStatus(
      projectId: projectId,
      taskId: taskId,
      status: status,
    );
  }
}
