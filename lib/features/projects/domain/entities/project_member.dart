import 'package:equatable/equatable.dart';
import 'project.dart';

class ProjectMember extends Equatable {
  final String uid;
  final ProjectRole role;
  final DateTime? joinedAt;
  final String? email;
  final String? name;

  const ProjectMember({
    required this.uid,
    required this.role,
    this.joinedAt,
    this.email,
    this.name,
  });

  @override
  List<Object?> get props => [uid, role, joinedAt, email, name];
}
