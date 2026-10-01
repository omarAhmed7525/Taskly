import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/project.dart';
import '../models/project_member_model.dart';
import '../models/project_model.dart';

abstract class ProjectsRemoteDataSource {
  Stream<List<ProjectModel>> getProjectsStream({required String userId});
  Future<ProjectModel> getProject({required String projectId});
  Future<ProjectModel> createProject({
    required String name,
    required String description,
    required String ownerId,
    DateTime? deadline,
  });
  Future<void> updateProject({
    required String projectId,
    String? name,
    String? description,
    ProjectStatus? status,
    DateTime? deadline,
  });
  Future<void> deleteProject({required String projectId});

  Stream<List<ProjectMemberModel>> getProjectMembersStream({required String projectId});
  Future<void> addProjectMember({
    required String projectId,
    required String memberUserId,
    required ProjectRole role,
  });
  Future<void> updateMemberRole({
    required String projectId,
    required String memberUserId,
    required ProjectRole newRole,
  });
  Future<void> removeProjectMember({
    required String projectId,
    required String memberUserId,
  });
}

class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProjectsRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _projectsCollection =>
      _firestore.collection('projects');

  @override
  Stream<List<ProjectModel>> getProjectsStream({required String userId}) {
    // Listen to projects where user is owner or listed in member queries
    return _projectsCollection
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProjectModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<ProjectModel> getProject({required String projectId}) async {
    final doc = await _projectsCollection.doc(projectId).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Project not found');
    }
    return ProjectModel.fromFirestore(doc);
  }

  @override
  Future<ProjectModel> createProject({
    required String name,
    required String description,
    required String ownerId,
    DateTime? deadline,
  }) async {
    final docRef = _projectsCollection.doc();
    final now = DateTime.now();

    final model = ProjectModel(
      id: docRef.id,
      ownerId: ownerId,
      name: name.trim(),
      description: description.trim(),
      status: ProjectStatus.active,
      deadline: deadline,
      createdAt: now,
      updatedAt: now,
    );

    final batch = _firestore.batch();
    batch.set(docRef, model.toFirestore());

    // Also add the owner as an owner member in the subcollection
    final memberRef = docRef.collection('members').doc(ownerId);
    batch.set(memberRef, {
      'role': ProjectRole.owner.toMapString(),
      'joinedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
    return model;
  }

  @override
  Future<void> updateProject({
    required String projectId,
    String? name,
    String? description,
    ProjectStatus? status,
    DateTime? deadline,
  }) async {
    final Map<String, dynamic> updates = {
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (name != null) updates['name'] = name.trim();
    if (description != null) updates['description'] = description.trim();
    if (status != null) updates['status'] = status.toMapString();
    if (deadline != null) {
      updates['deadline'] = Timestamp.fromDate(deadline);
    }

    await _projectsCollection.doc(projectId).update(updates);
  }

  @override
  Future<void> deleteProject({required String projectId}) async {
    // Clean up members subcollection then project doc
    final membersSnapshot =
        await _projectsCollection.doc(projectId).collection('members').get();
    final batch = _firestore.batch();
    for (var memberDoc in membersSnapshot.docs) {
      batch.delete(memberDoc.reference);
    }
    batch.delete(_projectsCollection.doc(projectId));
    await batch.commit();
  }

  @override
  Stream<List<ProjectMemberModel>> getProjectMembersStream({required String projectId}) {
    return _projectsCollection
        .doc(projectId)
        .collection('members')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProjectMemberModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<void> addProjectMember({
    required String projectId,
    required String memberUserId,
    required ProjectRole role,
  }) async {
    // Optionally fetch user email or name from users collection
    String? email;
    String? name;
    try {
      final userDoc = await _firestore.collection('users').doc(memberUserId).get();
      if (userDoc.exists) {
        email = userDoc.data()?['email'] as String?;
        name = userDoc.data()?['name'] as String?;
      }
    } catch (_) {}

    final data = <String, dynamic>{
      'role': role.toMapString(),
      'joinedAt': FieldValue.serverTimestamp(),
    };
    if (email != null) data['email'] = email;
    if (name != null) data['name'] = name;

    await _projectsCollection
        .doc(projectId)
        .collection('members')
        .doc(memberUserId)
        .set(data);
  }

  @override
  Future<void> updateMemberRole({
    required String projectId,
    required String memberUserId,
    required ProjectRole newRole,
  }) async {
    await _projectsCollection
        .doc(projectId)
        .collection('members')
        .doc(memberUserId)
        .update({
      'role': newRole.toMapString(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeProjectMember({
    required String projectId,
    required String memberUserId,
  }) async {
    await _projectsCollection
        .doc(projectId)
        .collection('members')
        .doc(memberUserId)
        .delete();
  }
}
