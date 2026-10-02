import '../../../../core/errors/result.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class GetTaskUseCase {
  final TasksRepository _repository;

  GetTaskUseCase(this._repository);

  Future<Result<Task>> call({
    required String projectId,
    required String taskId,
  }) {
    return _repository.getTask(
      projectId: projectId,
      taskId: taskId,
    );
  }
}
