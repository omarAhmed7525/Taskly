import '../../../../core/errors/result.dart';
import '../repositories/tasks_repository.dart';

class ToggleSubtaskUseCase {
  final TasksRepository _repository;

  ToggleSubtaskUseCase(this._repository);

  Future<Result<void>> call({
    required String projectId,
    required String taskId,
    required String subtaskId,
    required bool isCompleted,
  }) {
    return _repository.toggleSubtask(
      projectId: projectId,
      taskId: taskId,
      subtaskId: subtaskId,
      isCompleted: isCompleted,
    );
  }
}
