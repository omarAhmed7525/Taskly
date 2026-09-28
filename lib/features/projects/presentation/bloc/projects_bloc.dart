import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_project.dart';
import '../../domain/usecases/delete_project.dart';
import '../../domain/usecases/get_projects.dart';
import '../../domain/usecases/update_project.dart';
import 'projects_event.dart';
import 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final GetProjectsUseCase _getProjectsUseCase;
  final CreateProjectUseCase _createProjectUseCase;
  final UpdateProjectUseCase _updateProjectUseCase;
  final DeleteProjectUseCase _deleteProjectUseCase;

  StreamSubscription? _projectsSubscription;

  ProjectsBloc({
    required GetProjectsUseCase getProjectsUseCase,
    required CreateProjectUseCase createProjectUseCase,
    required UpdateProjectUseCase updateProjectUseCase,
    required DeleteProjectUseCase deleteProjectUseCase,
  })  : _getProjectsUseCase = getProjectsUseCase,
        _createProjectUseCase = createProjectUseCase,
        _updateProjectUseCase = updateProjectUseCase,
        _deleteProjectUseCase = deleteProjectUseCase,
        super(const ProjectsState()) {
    on<ProjectsSubscriptionRequested>(_onSubscriptionRequested);
    on<ProjectCreateSubmitted>(_onCreateSubmitted);
    on<ProjectUpdateSubmitted>(_onUpdateSubmitted);
    on<ProjectDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onSubscriptionRequested(
    ProjectsSubscriptionRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(status: ProjectsStatus.loading));
    await _projectsSubscription?.cancel();
    await emit.forEach(
      _getProjectsUseCase(userId: event.userId),
      onData: (projects) => state.copyWith(
        status: ProjectsStatus.success,
        projects: projects,
      ),
      onError: (error, stackTrace) => state.copyWith(
        status: ProjectsStatus.failure,
        errorMessage: error.toString(),
      ),
    );
  }

  Future<void> _onCreateSubmitted(
    ProjectCreateSubmitted event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    final result = await _createProjectUseCase(
      name: event.name,
      description: event.description,
      ownerId: event.ownerId,
      deadline: event.deadline,
    );
    result.fold(
      (error) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: error,
      )),
      (project) => emit(state.copyWith(
        isSubmitting: false,
        actionSuccessMessage: 'Project created successfully',
      )),
    );
  }

  Future<void> _onUpdateSubmitted(
    ProjectUpdateSubmitted event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    final result = await _updateProjectUseCase(
      projectId: event.projectId,
      name: event.name,
      description: event.description,
      status: event.status,
      deadline: event.deadline,
    );
    result.fold(
      (error) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: error,
      )),
      (_) => emit(state.copyWith(
        isSubmitting: false,
        actionSuccessMessage: 'Project updated successfully',
      )),
    );
  }

  Future<void> _onDeleteRequested(
    ProjectDeleteRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    final result = await _deleteProjectUseCase(projectId: event.projectId);
    result.fold(
      (error) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: error,
      )),
      (_) => emit(state.copyWith(
        isSubmitting: false,
        actionSuccessMessage: 'Project deleted successfully',
      )),
    );
  }

  @override
  Future<void> close() {
    _projectsSubscription?.cancel();
    return super.close();
  }
}
