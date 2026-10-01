import '../../../../core/errors/result.dart';
import '../repositories/projects_repository.dart';

class DeleteProjectUseCase {
  final ProjectsRepository _repository;
  DeleteProjectUseCase(this._repository);

  Future<Result<void>> call({required String projectId}) {
    return _repository.deleteProject(projectId: projectId);
  }
}
