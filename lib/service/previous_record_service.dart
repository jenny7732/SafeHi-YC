import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safehi_yc/model/previous_record_model.dart';
import 'package:safehi_yc/util/http_helper.dart';

class PreviousRecordService {
  final baseUrl = dotenv.env['BASE_URL']!;

  Future<List<PreviousRecord>> fetchAllRecords() async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/getResultReportList'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final resbody = response.body;
      debugPrint('[DEBUG] 받은 json: $resbody');

      return jsonList.map((e) => PreviousRecord.fromJson(e)).toList();
    } else {
      throw Exception('기록 불러오기 실패: ${response.statusCode}');
    }
  }
}
