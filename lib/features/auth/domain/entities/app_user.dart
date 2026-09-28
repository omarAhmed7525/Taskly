import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [uid, name, email, photoUrl, createdAt, updatedAt];
}
