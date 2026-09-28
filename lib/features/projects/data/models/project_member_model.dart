import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/project_member.dart';

class ProjectMemberModel extends ProjectMember {
  const ProjectMemberModel({
    required super.uid,
    required super.role,
    super.joinedAt,
    super.email,
    super.name,
  });

  factory ProjectMemberModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ProjectMemberModel(
      uid: doc.id,
      role: ProjectRole.fromString(data['role'] as String?),
      joinedAt: (data['joinedAt'] as Timestamp?)?.toDate(),
      email: data['email'] as String?,
      name: data['name'] as String?,
    );
  }

  factory ProjectMemberModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProjectMemberModel(
      uid: docId,
      role: ProjectRole.fromString(map['role'] as String?),
      joinedAt: (map['joinedAt'] as Timestamp?)?.toDate(),
      email: map['email'] as String?,
      name: map['name'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'role': role.toMapString(),
      'joinedAt': joinedAt != null ? Timestamp.fromDate(joinedAt!) : FieldValue.serverTimestamp(),
      if (email != null) 'email': email,
      if (name != null) 'name': name,
    };
  }

  ProjectMember toEntity() {
    return ProjectMember(
      uid: uid,
      role: role,
      joinedAt: joinedAt,
      email: email,
      name: name,
    );
  }
}
