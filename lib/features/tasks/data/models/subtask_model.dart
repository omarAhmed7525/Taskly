import '../../domain/entities/subtask.dart';

class SubtaskModel extends Subtask {
  const SubtaskModel({
    required super.id,
    required super.title,
    super.isCompleted,
  });

  factory SubtaskModel.fromMap(Map<String, dynamic> map) {
    return SubtaskModel(
      id: (map['id'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      isCompleted: (map['isCompleted'] as bool?) ?? false,
    );
  }

  factory SubtaskModel.fromEntity(Subtask entity) {
    return SubtaskModel(
      id: entity.id,
      title: entity.title,
      isCompleted: entity.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  Subtask toEntity() {
    return Subtask(
      id: id,
      title: title,
      isCompleted: isCompleted,
    );
  }
}
