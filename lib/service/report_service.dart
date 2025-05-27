import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:safehi_yc/model/report_model.dart';
import 'package:safehi_yc/model/user_model.dart';
import 'package:safehi_yc/util/http_helper.dart';

class ReportService {
  final baseUrl = dotenv.env['BASE_URL']!;

  Future<List<ReportTarget>> fetchReportTargets() async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/getDefaultReportList'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((e) => ReportTarget.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load report target list');
    }
  }

  Future<Map<String, dynamic>> uploadDefaultReport({
    required ReportTarget target,
    required UserModel user,
    required String visitType,
    required String endTime,
  }) async {
    final uri = Uri.parse('$baseUrl/db/uploadReportDefaultInfo');
    final headers = await buildAuthHeaders();

    final body = {
      "reportid": target.reportId,
      "reportstatus": 1,
      "visittime": target.visitTime,
      "targetInfo": {
        "targetid": target.targetId,
        "targetname": target.targetName,
        "address1": target.address1,
        "address2": target.address2,
        "targetcallnum": target.phone,
        "gender": target.gender,
        "age": target.age,
      },
      "userInfo": {
        "email": user.email,
        "username": user.name,
        "callnum": user.phoneNumber,
        "birthday": user.birthDate,
        "etc": user.etc,
        "role": user.role,
        "gender": user.gender,
      },
      "visitType": visitType,
      'endTime': endTime,
    };

    debugPrint('[📤 업로드 요청 body] ${jsonEncode(body)}');

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  Future<void> uploadVisitDetail({
    required int reportId,
    required String detail,
  }) async {
    final url = Uri.parse('$baseUrl/db/uploadVisitDetail');
    final headers = await buildAuthHeaders();

    final body = {'reportid': reportId, 'detail': detail};

    debugPrint('[특이사항 업로드 요청] ${jsonEncode(body)}');

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('특이사항 업로드 실패: ${response.statusCode}');
    }
  }

  Future<void> uploadImages({
    required int reportId,
    required List<File> imageFiles,
  }) async {
    final uri = Uri.parse('$baseUrl/db/uploadImages');
    final request = http.MultipartRequest('POST', uri);
    final headers = await buildAuthHeaders();

    request.headers.addAll(headers);
    request.fields['reportid'] = reportId.toString();

    for (var file in imageFiles) {
      final ext = path.extension(file.path).toLowerCase();
      final mimeType = ext == '.png' ? 'png' : 'jpeg';

      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          file.path,
          contentType: MediaType('image', mimeType),
        ),
      );
    }

    final response = await http.Response.fromStream(await request.send());

    debugPrint('[이미지 업로드 응답] ${response.statusCode} - ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('이미지 업로드 실패: ${response.statusCode}');
    }
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

  Future<File> downloadReport(int reportId) async {
    final url = Uri.parse('$baseUrl/db/getReport/$reportId');
    final headers = await buildAuthHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();

      final file = File('${dir.path}/report_$reportId.doc');
      await file.writeAsBytes(bytes);

      return file;
    } else {
      throw Exception('리포트 다운로드 실패: ${response.statusCode}');
    }
  }
}
