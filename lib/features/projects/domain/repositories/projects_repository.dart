import '../../../../core/errors/result.dart';
import '../entities/project.dart';
import '../entities/project_member.dart';

abstract class ProjectsRepository {
  Stream<List<Project>> getProjectsStream({required String userId});
  Future<Result<Project>> getProject({required String projectId});
  Future<Result<Project>> createProject({
    required String name,
    required String description,
    required String ownerId,
    DateTime? deadline,
  });
  Future<Result<void>> updateProject({
    required String projectId,
    String? name,
    String? description,
    ProjectStatus? status,
    DateTime? deadline,
  });
  Future<Result<void>> deleteProject({required String projectId});

  Stream<List<ProjectMember>> getProjectMembersStream({required String projectId});
  Future<Result<void>> addProjectMember({
    required String projectId,
    required String memberUserId,
    required ProjectRole role,
  });
  Future<Result<void>> updateMemberRole({
    required String projectId,
    required String memberUserId,
    required ProjectRole newRole,
  });
  Future<Result<void>> removeProjectMember({
    required String projectId,
    required String memberUserId,
  });
}
