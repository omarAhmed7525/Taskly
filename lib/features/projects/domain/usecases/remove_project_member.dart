import '../../../../core/errors/result.dart';
import '../repositories/projects_repository.dart';

class RemoveProjectMemberUseCase {
  final ProjectsRepository _repository;
  RemoveProjectMemberUseCase(this._repository);

  Future<Result<void>> call({
    required String projectId,
    required String memberUserId,
  }) {
    return _repository.removeProjectMember(
      projectId: projectId,
      memberUserId: memberUserId,
    );
  }
}
