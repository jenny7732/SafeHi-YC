import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safehi_yc/model/visit_summary_model.dart';
import 'package:safehi_yc/util/http_helper.dart';

class SummaryPendingException implements Exception {
  const SummaryPendingException();

  @override
  String toString() => '요약이 아직 진행중입니다.';
}

class VisitSummaryService {
  final baseUrl = dotenv.env['BASE_URL']!;

  Future<VisitSummaryResponse> fetchVisitSummary(int reportId) async {
    final headers = await buildAuthHeaders(); // ✅ 토큰 헤더
    final response = await http.get(
      Uri.parse('$baseUrl/db/yangchun_stt_abstract/$reportId'),
      headers: headers,
    );

    final Map<String, dynamic> json = jsonDecode(
      utf8.decode(response.bodyBytes),
    );
    debugPrint('[방문 요약 응답] $json');

    if (json['msg'] == '요약이 진행중입니다.') {
      throw const SummaryPendingException(); // ✅ 이게 먼저여야 함
    }

    if (response.statusCode != 200) {
      throw Exception('방문 요약 정보를 불러오는 데 실패했습니다.');
    }

    if (json['status'] == false) {
      throw Exception(json['msg'] ?? '요약 정보를 가져오는 중 서버 오류가 발생했습니다.');
    }

    return VisitSummaryResponse.fromJson(json);
  }

  Future<void> uploadVisitSummaryEdit({
    required int reportId,
    required List<VisitSummary> summaries,
  }) async {
    final url = Uri.parse('$baseUrl/db/uploadEditAbstract');
    final headers = await buildAuthHeaders(); // ✅ 토큰 헤더

    final body = {
      'reportid': reportId,
      'items':
          summaries
              .map(
                (summary) => {
                  'subject': summary.subject,
                  'abstract': summary.abstract,
                  'detail': summary.detail,
                },
              )
              .toList(),
    };

    debugPrint('[요약 업로드 요청] ${jsonEncode(body)}');

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('요약 수정 업로드 실패: ${response.statusCode}');
    }
  }
}
