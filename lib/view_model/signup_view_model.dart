import 'package:flutter/material.dart';
import 'package:safehi_yc/model/user_register_model.dart';
import 'package:safehi_yc/repository/signup_repository.dart';
import 'package:safehi_yc/service/signup_service.dart';

class SignupViewModel extends ChangeNotifier {
  bool isLoading = false;
  final SignupService _signupService = SignupService();
  final SignupRepository _repository = SignupRepository();

  Future<Map<String, dynamic>> signup(UserRegisterModel user) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _signupService.register(user);
      isLoading = false;
      notifyListeners();
      return {
        'success': response['status'] == true,
        'msg': response['msg'] ?? '오류가 발생했습니다.',
      };
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return {'success': false, 'msg': '회원가입 중 오류가 발생했습니다.'};
    }
  }

  // 이메일 중복 확인

  bool _isEmailChecked = false;
  bool get isEmailChecked => _isEmailChecked;

  Future<String> checkEmail(String email) async {
    final response = await _repository.checkEmailDuplicate(email);
    final isDuplicate = response['msg'] == '이메일이 중복됩니다.';

    _isEmailChecked = !isDuplicate;
    return response['msg'];
  }
}
