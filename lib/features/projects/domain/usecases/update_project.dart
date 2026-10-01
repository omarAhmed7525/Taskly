import '../../../../core/errors/result.dart';
import '../entities/project.dart';
import '../repositories/projects_repository.dart';

class UpdateProjectUseCase {
  final ProjectsRepository _repository;
  UpdateProjectUseCase(this._repository);

  Future<Result<void>> call({
    required String projectId,
    String? name,
    String? description,
    ProjectStatus? status,
    DateTime? deadline,
  }) {
    return _repository.updateProject(
      projectId: projectId,
      name: name,
      description: description,
      status: status,
      deadline: deadline,
    );
  }
}
