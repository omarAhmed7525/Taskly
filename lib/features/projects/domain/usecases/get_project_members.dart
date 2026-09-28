import '../entities/project_member.dart';
import '../repositories/projects_repository.dart';

class GetProjectMembersUseCase {
  final ProjectsRepository _repository;
  GetProjectMembersUseCase(this._repository);

  Stream<List<ProjectMember>> call({required String projectId}) {
    return _repository.getProjectMembersStream(projectId: projectId);
  }
}
