import '../entities/project.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUseCase {
  final ProjectsRepository _repository;
  GetProjectsUseCase(this._repository);

  Stream<List<Project>> call({required String userId}) {
    return _repository.getProjectsStream(userId: userId);
  }
}
