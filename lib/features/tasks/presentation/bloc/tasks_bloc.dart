import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/toggle_subtask.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/update_task_status.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetTasksUseCase _getTasksUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final UpdateTaskStatusUseCase _updateTaskStatusUseCase;
  final ToggleSubtaskUseCase _toggleSubtaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  StreamSubscription? _tasksSubscription;

  TasksBloc({
    required GetTasksUseCase getTasksUseCase,
    required CreateTaskUseCase createTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required UpdateTaskStatusUseCase updateTaskStatusUseCase,
    required ToggleSubtaskUseCase toggleSubtaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
  })  : _getTasksUseCase = getTasksUseCase,
        _createTaskUseCase = createTaskUseCase,
        _updateTaskUseCase = updateTaskUseCase,
        _updateTaskStatusUseCase = updateTaskStatusUseCase,
        _toggleSubtaskUseCase = toggleSubtaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        super(const TasksState()) {
    on<TasksSubscriptionRequested>(_onSubscriptionRequested);
    on<TaskFilterChanged>(_onFilterChanged);
    on<TaskCreateSubmitted>(_onCreateSubmitted);
    on<TaskUpdateSubmitted>(_onUpdateSubmitted);
    on<TaskStatusChanged>(_onStatusChanged);
    on<TaskSubtaskToggled>(_onSubtaskToggled);
    on<TaskDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onSubscriptionRequested(
    TasksSubscriptionRequested event,
    Emitter<TasksState> emit,
  ) async {
    emit(state.copyWith(status: TasksStatus.loading));
    await _tasksSubscription?.cancel();
    await emit.forEach(
      _getTasksUseCase(projectId: event.projectId),
      onData: (tasks) => state.copyWith(
        status: TasksStatus.success,
        tasks: tasks,
      ),
      onError: (error, stackTrace) => state.copyWith(
        status: TasksStatus.failure,
        errorMessage: () => error.toString(),
      ),
    );
  }

  void _onFilterChanged(
    TaskFilterChanged event,
    Emitter<TasksState> emit,
  ) {
    emit(state.copyWith(
      statusFilter: () => event.statusFilter,
      priorityFilter: () => event.priorityFilter,
      searchQuery: event.searchQuery ?? state.searchQuery,
    ));
  }

  Future<void> _onCreateSubmitted(
    TaskCreateSubmitted event,
    Emitter<TasksState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: () => null));
    final result = await _createTaskUseCase(
      projectId: event.projectId,
      title: event.title,
      description: event.description,
      createdBy: event.createdBy,
      priority: event.priority,
      dueDate: event.dueDate,
      assignedTo: event.assignedTo,
      assigneeName: event.assigneeName,
      subtasks: event.subtasks,
    );

    result.fold(
      (error) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: () => error,
      )),
      (task) => emit(state.copyWith(
        isSubmitting: false,
        actionSuccessMessage: () => 'Task created successfully',
      )),
    );
  }

  Future<void> _onUpdateSubmitted(
    TaskUpdateSubmitted event,
    Emitter<TasksState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: () => null));
    final result = await _updateTaskUseCase(
      projectId: event.projectId,
      taskId: event.taskId,
      title: event.title,
      description: event.description,
      status: event.status,
      priority: event.priority,
      dueDate: event.dueDate,
      assignedTo: event.assignedTo,
      assigneeName: event.assigneeName,
      subtasks: event.subtasks,
    );

    result.fold(
      (error) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: () => error,
      )),
      (_) => emit(state.copyWith(
        isSubmitting: false,
        actionSuccessMessage: () => 'Task updated successfully',
      )),
    );
  }

  Future<void> _onStatusChanged(
    TaskStatusChanged event,
    Emitter<TasksState> emit,
  ) async {
    final result = await _updateTaskStatusUseCase(
      projectId: event.projectId,
      taskId: event.taskId,
      status: event.status,
    );

    result.fold(
      (error) => emit(state.copyWith(errorMessage: () => error)),
      (_) => null,
    );
  }

  Future<void> _onSubtaskToggled(
    TaskSubtaskToggled event,
    Emitter<TasksState> emit,
  ) async {
    final result = await _toggleSubtaskUseCase(
      projectId: event.projectId,
      taskId: event.taskId,
      subtaskId: event.subtaskId,
      isCompleted: event.isCompleted,
    );

    result.fold(
      (error) => emit(state.copyWith(errorMessage: () => error)),
      (_) => null,
    );
  }

  Future<void> _onDeleteRequested(
    TaskDeleteRequested event,
    Emitter<TasksState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    final result = await _deleteTaskUseCase(
      projectId: event.projectId,
      taskId: event.taskId,
    );

    result.fold(
      (error) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: () => error,
      )),
      (_) => emit(state.copyWith(
        isSubmitting: false,
        actionSuccessMessage: () => 'Task deleted successfully',
      )),
    );
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
