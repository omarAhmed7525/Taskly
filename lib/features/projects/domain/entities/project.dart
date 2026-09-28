import 'package:equatable/equatable.dart';

enum ProjectStatus {
  active,
  completed,
  archived;

  String toMapString() => name;

  static ProjectStatus fromString(String? value) {
    return ProjectStatus.values.firstWhere(
      (e) => e.name == value?.toLowerCase(),
      orElse: () => ProjectStatus.active,
    );
  }
}

enum ProjectRole {
  owner,
  manager,
  member,
  viewer;

  String toMapString() => name;

  static ProjectRole fromString(String? value) {
    return ProjectRole.values.firstWhere(
      (e) => e.name == value?.toLowerCase(),
      orElse: () => ProjectRole.member,
    );
  }
}

class Project extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final ProjectStatus status;
  final DateTime? deadline;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Project({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    this.status = ProjectStatus.active,
    this.deadline,
    this.createdAt,
    this.updatedAt,
  });

  Project copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    ProjectStatus? status,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ownerId,
        name,
        description,
        status,
        deadline,
        createdAt,
        updatedAt,
      ];
}
