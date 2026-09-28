import '../../../../core/errors/result.dart';
import '../entities/project.dart';
import '../repositories/projects_repository.dart';

class GetProjectUseCase {
  final ProjectsRepository _repository;
  GetProjectUseCase(this._repository);

  Future<Result<Project>> call({required String projectId}) {
    return _repository.getProject(projectId: projectId);
  }
}
