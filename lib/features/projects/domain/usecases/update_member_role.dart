import '../../../../core/errors/result.dart';
import '../entities/project.dart';
import '../repositories/projects_repository.dart';

class UpdateMemberRoleUseCase {
  final ProjectsRepository _repository;
  UpdateMemberRoleUseCase(this._repository);

  Future<Result<void>> call({
    required String projectId,
    required String memberUserId,
    required ProjectRole newRole,
  }) {
    return _repository.updateMemberRole(
      projectId: projectId,
      memberUserId: memberUserId,
      newRole: newRole,
    );
  }
}
