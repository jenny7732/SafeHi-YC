import 'package:flutter/material.dart';
import 'package:safehi_yc/model/visit_summary_model.dart';
import 'package:safehi_yc/repository/visit_summary_repository.dart';

class VisitSummaryViewModel extends ChangeNotifier {
  final VisitSummaryRepository repository;

  VisitSummaryViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<VisitSummary> _summaries = [];
  List<VisitSummary> get summaries => _summaries;

  Future<void> fetchSummary(int reportId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await repository.getSummary(reportId);
      _summaries = response.items;
    } catch (e) {
      debugPrint('[방문 요약 에러] $e');
      _summaries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadAllSummaries(int reportId) async {
    try {
      await repository.uploadEditedSummary(
        reportId: reportId,
        summaries: _summaries,
      );
      debugPrint('[요약 업로드 완료]');
    } catch (e) {
      debugPrint('[요약 업로드 실패] $e');
      rethrow;
    }
  }
}
