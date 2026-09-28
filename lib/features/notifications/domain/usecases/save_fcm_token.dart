import '../../../../core/errors/result.dart';
import '../repositories/notification_repository.dart';

class SaveFcmTokenUseCase {
  final NotificationRepository _repository;
  SaveFcmTokenUseCase(this._repository);

  Future<Result<void>> call({required String uid, required String token}) {
    return _repository.saveToken(uid: uid, token: token);
  }
}
