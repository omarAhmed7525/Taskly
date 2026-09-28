import '../../../../core/errors/result.dart';
import '../repositories/notification_repository.dart';

class RemoveFcmTokenUseCase {
  final NotificationRepository _repository;
  RemoveFcmTokenUseCase(this._repository);

  Future<Result<void>> call({required String uid, required String token}) {
    return _repository.removeToken(uid: uid, token: token);
  }
}
