import '../../../../core/errors/result.dart';
import '../entities/project.dart';
import '../repositories/projects_repository.dart';

class CreateProjectUseCase {
  final ProjectsRepository _repository;
  CreateProjectUseCase(this._repository);

  Future<Result<Project>> call({
    required String name,
    required String description,
    required String ownerId,
    DateTime? deadline,
  }) {
    return _repository.createProject(
      name: name,
      description: description,
      ownerId: ownerId,
      deadline: deadline,
    );
  }
}
