import 'package:equatable/equatable.dart';
import '../../domain/entities/project.dart';

enum ProjectsStatus { initial, loading, success, failure }

class ProjectsState extends Equatable {
  final ProjectsStatus status;
  final List<Project> projects;
  final String? errorMessage;
  final String? actionSuccessMessage;
  final bool isSubmitting;

  const ProjectsState({
    this.status = ProjectsStatus.initial,
    this.projects = const [],
    this.errorMessage,
    this.actionSuccessMessage,
    this.isSubmitting = false,
  });

  ProjectsState copyWith({
    ProjectsStatus? status,
    List<Project>? projects,
    String? errorMessage,
    String? actionSuccessMessage,
    bool? isSubmitting,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      errorMessage: errorMessage,
      actionSuccessMessage: actionSuccessMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        status,
        projects,
        errorMessage,
        actionSuccessMessage,
        isSubmitting,
      ];
}
