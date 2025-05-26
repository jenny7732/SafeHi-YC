import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:safehi_yc/util/http_helper.dart';
import 'package:safehi_yc/util/login_storage_helper.dart';

class UserService {
  final baseUrl = dotenv.env['BASE_URL']!;

  /// 로그인 요청 (서버 연동 주석 처리 + 더미 데이터 제공)
  Future<Map<String, dynamic>> login(String email, String password) async {
    debugPrint('[로그인 요청 시작]');
    debugPrint('보낸 데이터: {email: $email, password: $password}');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/db/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      debugPrint('응답 코드: ${response.statusCode}');
      debugPrint('응답 바디: ${utf8.decode(response.bodyBytes)}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = json['token'];
        final user = json['user'];

        if (token != null && user != null) {
          await LoginStorageHelper.saveToken(token);
          return {
            "status": true,
            "msg": json['message'] ?? "로그인 성공",
            "user": user,
          };
        } else {
          return {"status": false, "msg": "서버 응답에 사용자 정보가 포함되어 있지 않습니다."};
        }
      } else if (response.statusCode == 401) {
        return {"status": false, "msg": "아이디 또는 비밀번호가 올바르지 않습니다."};
      } else if (response.statusCode >= 500) {
        return {"status": false, "msg": "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."};
      } else {
        return {"status": false, "msg": json['message'] ?? '로그인 실패'};
      }
    } catch (e) {
      debugPrint('[로그인 예외 발생] $e');
      return {"status": false, "msg": "서버에 연결할 수 없습니다. 인터넷 상태를 확인해주세요."};
    }

    // ------ 더미 응답 ------
    // await Future.delayed(const Duration(seconds: 1)); // 테스트용 지연

    // return {
    //   "status": true,
    //   "msg": "테스트용 로그인 성공",
    //   "user": {
    //     "user_id": 4,
    //     "name": "yujin",
    //     "phone_number": "01043830203",
    //     "email": "jenny7732@naver.com",
    //     "birthdate": "2002-02-02T15:00:00.000Z",
    //     "gender": 0,
    //     "permission": 1,
    //   }
    // };
  }

  /// 자동 로그인 시 사용자 정보 요청
  Future<Map<String, dynamic>> fetchUserInfo() async {
    try {
      final headers = await buildAuthHeaders(); // ✅ 토큰 포함 헤더

      final response = await http.get(
        Uri.parse('$baseUrl/db/users'),
        headers: headers,
      );

      debugPrint('[fetchUserInfo] 응답 코드: ${response.statusCode}');
      debugPrint('[fetchUserInfo] 응답 body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json is List && json.isNotEmpty) {
          return json[0]; // ✅ 첫 번째 사용자 정보 반환
        } else {
          throw Exception('사용자 정보가 존재하지 않습니다.');
        }
      } else {
        throw Exception('사용자 정보 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('사용자 정보 요청 중 오류 발생: $e');
    }
  }

  // return {
  //   "user_id": userid,
  //   "name": "yujin",
  //   "phone_number": "01043830203",
  //   "email": "jenny7732@naver.com",
  //   "birthdate": "2002-02-02T15:00:00.000Z",
  //   "gender": 0,
  //   "permission": 1,
  // };
}
