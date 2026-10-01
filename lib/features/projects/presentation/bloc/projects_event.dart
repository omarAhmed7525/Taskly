import 'package:equatable/equatable.dart';
import '../../domain/entities/project.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

class ProjectsSubscriptionRequested extends ProjectsEvent {
  final String userId;
  const ProjectsSubscriptionRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ProjectCreateSubmitted extends ProjectsEvent {
  final String name;
  final String description;
  final String ownerId;
  final DateTime? deadline;

  const ProjectCreateSubmitted({
    required this.name,
    required this.description,
    required this.ownerId,
    this.deadline,
  });

  @override
  List<Object?> get props => [name, description, ownerId, deadline];
}

class ProjectUpdateSubmitted extends ProjectsEvent {
  final String projectId;
  final String? name;
  final String? description;
  final ProjectStatus? status;
  final DateTime? deadline;

  const ProjectUpdateSubmitted({
    required this.projectId,
    this.name,
    this.description,
    this.status,
    this.deadline,
  });

  @override
  List<Object?> get props => [projectId, name, description, status, deadline];
}

class ProjectDeleteRequested extends ProjectsEvent {
  final String projectId;
  const ProjectDeleteRequested({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}
