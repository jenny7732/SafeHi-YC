import 'package:flutter/material.dart';
import 'package:safehi_yc/model/user_register_model.dart';
import 'package:safehi_yc/service/signup_service.dart';

class SignupViewModel extends ChangeNotifier {
  bool isLoading = false;
  final SignupService _signupService = SignupService();

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
}
