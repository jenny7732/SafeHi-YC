import 'package:flutter/material.dart';
import 'package:safehi_yc/model/user_model.dart';
import 'package:safehi_yc/service/user_service.dart';
import 'package:safehi_yc/util/login_storage_helper.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _service;
  UserModel? _user;
  bool isLoading = false;

  UserViewModel(this._service);

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> loadUser(int userId) async {
    isLoading = true;
    notifyListeners();
    try {
      final userInfo = await _service.fetchUserInfo();
      _user = UserModel.fromJson(userInfo);
    } catch (e) {
      debugPrint('User fetch error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    final stored = await LoginStorageHelper.readLogin();
    final loginStatus = stored['loginStatus'];

    final token = await LoginStorageHelper.readToken();
    if (token == null) {
      debugPrint('[자동 로그인 실패] 저장된 토큰 없음');
      return;
    }

    if (loginStatus == 'true') {
      try {
        final userInfo = await _service.fetchUserInfo();
        _user = UserModel.fromJson(userInfo);
        notifyListeners();
      } catch (e) {
        debugPrint('[자동 로그인 실패] $e');
        await LoginStorageHelper.clear();
      }
    } else {
      debugPrint('[자동 로그인 조건 미달] loginStatus=$loginStatus');
    }
  }

  Future<void> saveLogin(int userId) async {
    await LoginStorageHelper.saveLogin(userid: userId);
  }

  Future<Map<String, dynamic>> login(
    String email,
    String password, {
    bool saveLogin = false,
  }) async {
    try {
      final loginResponse = await _service.login(email, password);

      final userInfo = loginResponse['user'];

      if (loginResponse['status'] == true && userInfo != null) {
        _user = UserModel.fromJson(userInfo);

        if (saveLogin) {
          await this.saveLogin(_user!.userId);
        }

        notifyListeners();

        return {'success': true, 'msg': '로그인 성공'};
      } else {
        return {'success': false, 'msg': loginResponse['msg'] ?? '로그인 실패'};
      }
    } catch (e) {
      return {'success': false, 'msg': '로그인 실패: $e'};
    }
  }

  Future<void> logout() async {
    await LoginStorageHelper.clear(); // 기존 로그인 정보
    await LoginStorageHelper.clearToken(); // 🔐 토큰 삭제
    _user = null;
    notifyListeners();
  }
}
