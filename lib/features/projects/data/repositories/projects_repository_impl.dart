import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/project_member.dart';
import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_remote_datasource.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsRemoteDataSource _remoteDataSource;

  ProjectsRepositoryImpl({required ProjectsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<List<Project>> getProjectsStream({required String userId}) {
    return _remoteDataSource
        .getProjectsStream(userId: userId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Result<Project>> getProject({required String projectId}) async {
    try {
      final model = await _remoteDataSource.getProject(projectId: projectId);
      return Result.success(model.toEntity());
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to get project ().');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Project>> createProject({
    required String name,
    required String description,
    required String ownerId,
    DateTime? deadline,
  }) async {
    try {
      final model = await _remoteDataSource.createProject(
        name: name,
        description: description,
        ownerId: ownerId,
        deadline: deadline,
      );
      return Result.success(model.toEntity());
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to create project ().');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> updateProject({
    required String projectId,
    String? name,
    String? description,
    ProjectStatus? status,
    DateTime? deadline,
  }) async {
    try {
      await _remoteDataSource.updateProject(
        projectId: projectId,
        name: name,
        description: description,
        status: status,
        deadline: deadline,
      );
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to update project ().');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> deleteProject({required String projectId}) async {
    try {
      await _remoteDataSource.deleteProject(projectId: projectId);
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to delete project ().');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Stream<List<ProjectMember>> getProjectMembersStream({required String projectId}) {
    return _remoteDataSource
        .getProjectMembersStream(projectId: projectId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Result<void>> addProjectMember({
    required String projectId,
    required String memberUserId,
    required ProjectRole role,
  }) async {
    try {
      await _remoteDataSource.addProjectMember(
        projectId: projectId,
        memberUserId: memberUserId,
        role: role,
      );
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to add project member ().');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> updateMemberRole({
    required String projectId,
    required String memberUserId,
    required ProjectRole newRole,
  }) async {
    try {
      await _remoteDataSource.updateMemberRole(
        projectId: projectId,
        memberUserId: memberUserId,
        newRole: newRole,
      );
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to update member role ().');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> removeProjectMember({
    required String projectId,
    required String memberUserId,
  }) async {
    try {
      await _remoteDataSource.removeProjectMember(
        projectId: projectId,
        memberUserId: memberUserId,
      );
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to remove member ().');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
