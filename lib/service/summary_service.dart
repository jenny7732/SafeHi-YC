const String baseUrl = 'http://211.188.55.88:3000';

class SummaryService {
  /// 대화 요약 호출
  /// 나중에 실제 서버로 요청 시:
  /// 1) Uri.parse('$baseUrl/...')
  /// 2) await http.get(...)
  Future<dynamic> fetchSummaryData() async {
    // final response = await http.get(Uri.parse('$baseUrl/conversation-summary'));
    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   final decoded = json.decode(response.body);
    //   return decoded;
    // } else {
    //   throw Exception('Failed to load conversation summary');
    // }

    // 지금은 더미 데이터 반환
    return [
      {
        "title": "사회적 고립 상태 평가",
        "content": ["사람 만남 꺼림, 의욕 상실", "외로움 무기력 심화"],
      },
      {
        "title": "정신적/감정적 건강",
        "content": ["스트레스, 수면 장애"],
      },
    ];
  }
}
