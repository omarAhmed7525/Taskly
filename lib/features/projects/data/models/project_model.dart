import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.ownerId,
    required super.name,
    required super.description,
    super.status,
    super.deadline,
    super.createdAt,
    super.updatedAt,
  });

  factory ProjectModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ProjectModel(
      id: doc.id,
      ownerId: (data['ownerId'] as String?) ?? '',
      name: (data['name'] as String?) ?? '',
      description: (data['description'] as String?) ?? '',
      status: ProjectStatus.fromString(data['status'] as String?),
      deadline: (data['deadline'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProjectModel(
      id: docId,
      ownerId: (map['ownerId'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      status: ProjectStatus.fromString(map['status'] as String?),
      deadline: (map['deadline'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'status': status.toMapString(),
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Project toEntity() {
    return Project(
      id: id,
      ownerId: ownerId,
      name: name,
      description: description,
      status: status,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
