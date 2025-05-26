import 'package:safehi_yc/service/signup_service.dart';

class SignupRepository {
  final SignupService _service = SignupService();

  Future<Map<String, dynamic>> checkEmailDuplicate(String email) {
    return _service.checkEmailDuplicate(email);
  }
}
