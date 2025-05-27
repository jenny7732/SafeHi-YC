import 'package:flutter/material.dart';
import 'package:safehi_yc/model/visit_summary_model.dart';
import 'package:safehi_yc/repository/visit_summary_repository.dart';
import 'package:safehi_yc/service/visit_summary_service.dart';

class VisitSummaryViewModel extends ChangeNotifier {
  final VisitSummaryRepository repository;

  VisitSummaryViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<VisitSummary> _summaries = [];
  List<VisitSummary> get summaries => _summaries;

  String? _statusMessage; // ✅ 상태 메시지
  String? get statusMessage => _statusMessage;

  Future<void> fetchSummary(int reportId) async {
    _isLoading = true;
    _statusMessage = null;
    notifyListeners();

    try {
      final response = await repository.getSummary(reportId);
      _summaries = response.items;
      _statusMessage = null;
    } on SummaryPendingException {
      _summaries = [];
      _statusMessage = '요약이 아직 진행 중입니다.'; // ✅ 여기에 정확히 넣기
    } catch (e) {
      _summaries = [];
      _statusMessage = '서버 오류가 발생했습니다. 관리자에게 문의해주세요.';
      debugPrint('[방문 요약 에러] $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
