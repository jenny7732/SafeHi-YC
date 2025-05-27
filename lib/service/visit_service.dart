import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safehi_yc/model/stt_result_model.dart';
import 'package:safehi_yc/model/visit_detail_model.dart';
import 'package:safehi_yc/model/visit_model.dart';
import 'package:safehi_yc/util/http_helper.dart';

class VisitService {
  final baseUrl = dotenv.env['BASE_URL']!;

  /// 특정 방문 대상자 기본 정보 조회
  static Future<Visit> fetchVisitDetail(int targetId) async {
    final headers = await buildAuthHeaders(); // ✅ 토큰 헤더 추가
    final baseUrl = dotenv.env['BASE_URL']!;

    final response = await http.get(
      Uri.parse('$baseUrl/db/getTargetInfo/$targetId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Visit.fromJson(data);
    } else {
      throw Exception('Failed to load target info');
    }
  }

  /// 특정 방문자의 상세 정보
  Future<VisitDetail> getTargetDetail(int reportId) async {
    final headers = await buildAuthHeaders();
    final baseUrl = dotenv.env['BASE_URL']!;

    final response = await http.get(
      Uri.parse('$baseUrl/db/getTargetInfo/$reportId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return VisitDetail.fromJson(jsonData);
    } else {
      throw Exception('상세 정보 요청 실패: ${response.statusCode}');
    }
  }

  // stt 제목 post 요청
  Future<Map<String, dynamic>> uploadSttTitle(String title) async {
    final url = Uri.parse('$baseUrl/db/yangchun_stt_upload');
    final headers = await buildAuthHeaders();

    final body = {'stt_file_name': title};

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    final result = jsonDecode(utf8.decode(response.bodyBytes));
    debugPrint('[STT 제목 업로드 응답] $result');

    if (response.statusCode != 200 || result['status'] != true) {
      throw Exception(result['msg'] ?? '서버 오류 발생');
    }

    return result; // ✅ 변경된 부분
  }

  Future<List<SttResult>> fetchSttResultList() async {
    final headers = await buildAuthHeaders();
    final url = Uri.parse('$baseUrl/db/yangchun_getResultList');

    final response = await http.get(url, headers: headers);
    debugPrint('response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('STT 결과 리스트 요청 실패: ${response.statusCode}');
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));

    // ✅ 응답이 리스트 그 자체임
    if (decoded is! List) {
      throw Exception('예상하지 못한 응답 형식입니다. List가 아님');
    }

    return decoded.map((e) => SttResult.fromJson(e)).toList();
  }

  Future<String> getConversationText(int reportId) async {
    final url = Uri.parse(
      '$baseUrl/db/getYangChunConverstationSTTtxt/$reportId',
    );
    final headers = await buildAuthHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('상담 텍스트 불러오기 실패: ${response.statusCode}');
    }
  }
}
