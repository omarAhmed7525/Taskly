import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class GetTasksUseCase {
  final TasksRepository _repository;

  GetTasksUseCase(this._repository);

  Stream<List<Task>> call({
    required String projectId,
    TaskStatus? statusFilter,
    TaskPriority? priorityFilter,
    String? assigneeFilter,
  }) {
    return _repository.getTasksStream(
      projectId: projectId,
      statusFilter: statusFilter,
      priorityFilter: priorityFilter,
      assigneeFilter: assigneeFilter,
    );
  }
}
