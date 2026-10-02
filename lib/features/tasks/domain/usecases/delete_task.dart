import '../../../../core/errors/result.dart';
import '../repositories/tasks_repository.dart';

class DeleteTaskUseCase {
  final TasksRepository _repository;

  DeleteTaskUseCase(this._repository);

  Future<Result<void>> call({
    required String projectId,
    required String taskId,
  }) {
    return _repository.deleteTask(
      projectId: projectId,
      taskId: taskId,
    );
  }
}
