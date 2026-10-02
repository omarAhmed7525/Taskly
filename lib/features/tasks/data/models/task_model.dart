import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task.dart';
import 'subtask_model.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.projectId,
    required super.title,
    required super.description,
    super.status,
    super.priority,
    super.dueDate,
    super.assignedTo,
    super.assigneeName,
    required super.createdBy,
    super.subtasks,
    super.createdAt,
    super.updatedAt,
  });

  factory TaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    required String projectId,
  }) {
    final data = doc.data() ?? {};
    final subtasksRaw = data['subtasks'] as List<dynamic>? ?? [];
    final subtasks = subtasksRaw
        .map((s) => SubtaskModel.fromMap(Map<String, dynamic>.from(s as Map)))
        .toList();

    return TaskModel(
      id: doc.id,
      projectId: (data['projectId'] as String?) ?? projectId,
      title: (data['title'] as String?) ?? '',
      description: (data['description'] as String?) ?? '',
      status: TaskStatus.fromString(data['status'] as String?),
      priority: TaskPriority.fromString(data['priority'] as String?),
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      assignedTo: data['assignedTo'] as String?,
      assigneeName: data['assigneeName'] as String?,
      createdBy: (data['createdBy'] as String?) ?? '',
      subtasks: subtasks,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'projectId': projectId,
      'title': title,
      'description': description,
      'status': status.toMapString(),
      'priority': priority.toMapString(),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'assignedTo': assignedTo,
      'assigneeName': assigneeName,
      'createdBy': createdBy,
      'subtasks': subtasks
          .map((s) => SubtaskModel.fromEntity(s).toMap())
          .toList(),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Task toEntity() {
    return Task(
      id: id,
      projectId: projectId,
      title: title,
      description: description,
      status: status,
      priority: priority,
      dueDate: dueDate,
      assignedTo: assignedTo,
      assigneeName: assigneeName,
      createdBy: createdBy,
      subtasks: subtasks,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
