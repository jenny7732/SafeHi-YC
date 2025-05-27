import 'package:flutter/material.dart';
import 'package:safehi_yc/repository/visit_repository.dart';

class VisitUploadViewModel extends ChangeNotifier {
  final VisitRepository repository;

  VisitUploadViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _uploadMessage;
  String? get uploadMessage => _uploadMessage;

  bool _uploadSuccess = false;
  bool get uploadSuccess => _uploadSuccess;

  String _title = '';
  String get title => _title;

  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void resetTitle() {
    _title = '';
    notifyListeners();
  }

  /// STT 제목 업로드 함수
  Future<Map<String, dynamic>> uploadSttTitle(String title) async {
    _isLoading = true;
    _uploadMessage = null;
    _uploadSuccess = false;
    notifyListeners();

    try {
      final result = await repository.uploadSttTitle(title);
      _uploadSuccess = result['status'] == true;
      _uploadMessage = result['msg'];
      return result; // ✅ reportid 포함된 전체 응답 반환
    } catch (e) {
      _uploadMessage = e.toString();
      _uploadSuccess = false;
      rethrow; // ✅ 오류 던지기
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 상태 초기화 (선택)
  void reset() {
    _uploadMessage = null;
    _uploadSuccess = false;
    _isLoading = false;
    notifyListeners();
  }

  String? _conversationText;
  String? get conversationText => _conversationText;

  Future<void> fetchConversationText(int reportId) async {
    _conversationText = await repository.getConversationText(reportId);
    notifyListeners();
  }
}
