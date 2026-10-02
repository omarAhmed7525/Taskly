import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/subtask.dart';
import '../../domain/entities/task.dart';
import '../models/task_model.dart';

abstract class TasksRemoteDataSource {
  Stream<List<TaskModel>> getTasksStream({
    required String projectId,
    TaskStatus? statusFilter,
    TaskPriority? priorityFilter,
    String? assigneeFilter,
  });

  Future<TaskModel> getTask({
    required String projectId,
    required String taskId,
  });

  Future<TaskModel> createTask({
    required String projectId,
    required String title,
    required String description,
    required String createdBy,
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
    String? assignedTo,
    String? assigneeName,
    List<Subtask> subtasks = const [],
  });

  Future<void> updateTask({
    required String projectId,
    required String taskId,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    String? assignedTo,
    String? assigneeName,
    List<Subtask>? subtasks,
  });

  Future<void> updateTaskStatus({
    required String projectId,
    required String taskId,
    required TaskStatus status,
  });

  Future<void> toggleSubtask({
    required String projectId,
    required String taskId,
    required String subtaskId,
    required bool isCompleted,
  });

  Future<void> deleteTask({
    required String projectId,
    required String taskId,
  });
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final FirebaseFirestore _firestore;

  TasksRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _tasksCollection(String projectId) =>
      _firestore.collection('projects').doc(projectId).collection('tasks');

  @override
  Stream<List<TaskModel>> getTasksStream({
    required String projectId,
    TaskStatus? statusFilter,
    TaskPriority? priorityFilter,
    String? assigneeFilter,
  }) {
    Query<Map<String, dynamic>> query = _tasksCollection(projectId);

    if (statusFilter != null) {
      query = query.where('status', isEqualTo: statusFilter.toMapString());
    }
    if (priorityFilter != null) {
      query = query.where('priority', isEqualTo: priorityFilter.toMapString());
    }
    if (assigneeFilter != null) {
      query = query.where('assignedTo', isEqualTo: assigneeFilter);
    }

    return query.snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc, projectId: projectId))
          .toList();
      // Client-side sorting: by dueDate ascending (nulls last) or createdAt descending
      list.sort((a, b) {
        if (a.dueDate != null && b.dueDate != null) {
          return a.dueDate!.compareTo(b.dueDate!);
        }
        if (a.dueDate != null) return -1;
        if (b.dueDate != null) return 1;
        final aCreated = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bCreated = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bCreated.compareTo(aCreated);
      });
      return list;
    });
  }

  @override
  Future<TaskModel> getTask({
    required String projectId,
    required String taskId,
  }) async {
    final doc = await _tasksCollection(projectId).doc(taskId).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Task not found');
    }
    return TaskModel.fromFirestore(doc, projectId: projectId);
  }

  @override
  Future<TaskModel> createTask({
    required String projectId,
    required String title,
    required String description,
    required String createdBy,
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
    String? assignedTo,
    String? assigneeName,
    List<Subtask> subtasks = const [],
  }) async {
    final docRef = _tasksCollection(projectId).doc();
    final taskModel = TaskModel(
      id: docRef.id,
      projectId: projectId,
      title: title,
      description: description,
      status: TaskStatus.todo,
      priority: priority,
      dueDate: dueDate,
      assignedTo: assignedTo,
      assigneeName: assigneeName,
      createdBy: createdBy,
      subtasks: subtasks,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await docRef.set(taskModel.toFirestore());
    return taskModel;
  }

  @override
  Future<void> updateTask({
    required String projectId,
    required String taskId,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    String? assignedTo,
    String? assigneeName,
    List<Subtask>? subtasks,
  }) async {
    final Map<String, dynamic> updates = {
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (title != null) updates['title'] = title;
    if (description != null) updates['description'] = description;
    if (status != null) updates['status'] = status.toMapString();
    if (priority != null) updates['priority'] = priority.toMapString();
    if (dueDate != null) {
      updates['dueDate'] = Timestamp.fromDate(dueDate);
    }
    if (assignedTo != null) updates['assignedTo'] = assignedTo;
    if (assigneeName != null) updates['assigneeName'] = assigneeName;
    if (subtasks != null) {
      updates['subtasks'] = subtasks
          .map((s) => {'id': s.id, 'title': s.title, 'isCompleted': s.isCompleted})
          .toList();
    }

    await _tasksCollection(projectId).doc(taskId).update(updates);
  }

  @override
  Future<void> updateTaskStatus({
    required String projectId,
    required String taskId,
    required TaskStatus status,
  }) async {
    await _tasksCollection(projectId).doc(taskId).update({
      'status': status.toMapString(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> toggleSubtask({
    required String projectId,
    required String taskId,
    required String subtaskId,
    required bool isCompleted,
  }) async {
    final docRef = _tasksCollection(projectId).doc(taskId);
    final doc = await docRef.get();
    if (!doc.exists) throw Exception('Task not found');

    final data = doc.data() ?? {};
    final subtasksRaw = data['subtasks'] as List<dynamic>? ?? [];
    final updatedSubtasks = subtasksRaw.map((s) {
      final map = Map<String, dynamic>.from(s as Map);
      if (map['id'] == subtaskId) {
        map['isCompleted'] = isCompleted;
      }
      return map;
    }).toList();

    await docRef.update({
      'subtasks': updatedSubtasks,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteTask({
    required String projectId,
    required String taskId,
  }) async {
    await _tasksCollection(projectId).doc(taskId).delete();
  }
}
