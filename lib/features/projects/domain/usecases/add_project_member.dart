import '../../../../core/errors/result.dart';
import '../entities/project.dart';
import '../repositories/projects_repository.dart';

class AddProjectMemberUseCase {
  final ProjectsRepository _repository;
  AddProjectMemberUseCase(this._repository);

  Future<Result<void>> call({
    required String projectId,
    required String memberUserId,
    required ProjectRole role,
  }) {
    return _repository.addProjectMember(
      projectId: projectId,
      memberUserId: memberUserId,
      role: role,
    );
  }
}
