import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safehi_yc/model/user_register_model.dart';

class SignupService {
  final baseUrl = dotenv.env['BASE_URL']!;

  Future<Map<String, dynamic>> register(UserRegisterModel user) async {
    debugPrint('[회원가입 요청 시작]');
    debugPrint('요청 바디: ${jsonEncode(user.toJson())}');

    // ------ 실제 서버 요청 코드 (주석 처리됨) ------

    final url = Uri.parse('$baseUrl/db/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      debugPrint('응답 코드: ${response.statusCode}');
      debugPrint('응답 바디: ${utf8.decode(response.bodyBytes)}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        return {'status': false, 'msg': errorBody['msg'] ?? '회원가입에 실패했습니다.'};
      }
    } catch (e) {
      debugPrint('[예외 발생] $e');
      return {'status': false, 'msg': '회원가입 요청 중 오류가 발생했습니다.\n${e.toString()}'};
    }

    // ------ 더미 응답 (서버 없이 테스트용) ------
    // await Future.delayed(const Duration(seconds: 1)); // 시뮬레이션 지연

    // return {
    //   "status": true,
    //   "message": "User registered successfully",
    //   "user": {
    //     "user_id": 123,
    //     "name": user.name,
    //     "phone_number": user.phoneNumber,
    //     "email": user.email,
    //     "birthdate": user.birthdate,
    //     "gender": user.gender,
    //     "permission": user.permission,
    //   }
    // };
  }

  Future<Map<String, dynamic>> checkEmailDuplicate(String email) async {
    final url = Uri.parse('$baseUrl/db/email_check');
    debugPrint('요청 URL: $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      debugPrint('이메일 중복 확인 응답: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': false,
          'msg': '이메일 중복 확인 실패: 서버 오류 (${response.statusCode})',
        };
      }
    } catch (e) {
      debugPrint('[예외 발생 - 이메일 중복 확인] $e');
      return {
        'status': false,
        'msg': '이메일 중복 확인 중 오류가 발생했습니다.\n${e.toString()}',
      };
    }
  }
}
