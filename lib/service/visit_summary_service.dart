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
    // final headers = await buildAuthHeaders(); // ✅ 토큰 헤더
    // final response = await http.get(
    //   Uri.parse('$baseUrl/db/yangchun_stt_abstract/$reportId'),
    //   headers: headers,
    // );

    // final Map<String, dynamic> json = jsonDecode(
    //   utf8.decode(response.bodyBytes),
    // );
    // debugPrint('[방문 요약 응답] $json');

    // if (json['msg'] == '요약이 진행중입니다.') {
    //   throw const SummaryPendingException(); // ✅ 이게 먼저여야 함
    // }

    // if (response.statusCode != 200) {
    //   throw Exception('방문 요약 정보를 불러오는 데 실패했습니다.');
    // }

    // if (json['status'] == false) {
    //   throw Exception(json['msg'] ?? '요약 정보를 가져오는 중 서버 오류가 발생했습니다.');
    // }

    // return VisitSummaryResponse.fromJson(json);

    // 더미데이터
    debugPrint('[방문 요약 요청] reportId: $reportId');

    // ✅ 테스트 지연 (선택)
    await Future.delayed(const Duration(milliseconds: 500));

    // ✅ 더미 JSON 데이터
    final Map<String, dynamic> json = {
      "reportid": reportId,
      "items": [
        {
          "subject": "건강",
          "abstract": "소화 관련 불편 지속적 호소",
          "detail": "자세한 소화장애 증상 및 시간대별 변화 설명",
        },
        {
          "subject": "경제",
          "abstract": "공과금 부담, 경제적 스트레스 존재",
          "detail": "전기/수도요금 미납 상태 및 긴급지원 필요사항",
        },
        {
          "subject": "생활",
          "abstract": "외출 빈도 급감, 활동량 저하 및 무기력감",
          "detail": "최근 외출 기록 없음, 식사 준비도 소홀",
        },
        {
          "subject": "기타",
          "abstract": "가족과의 거리감, 사회활동 회피",
          "detail": "전화 연락도 거의 없음, 이웃과 접촉도 줄어듦",
        },
      ],
    };
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
