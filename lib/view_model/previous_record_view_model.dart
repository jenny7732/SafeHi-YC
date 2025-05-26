import 'package:flutter/foundation.dart';
import '../model/previous_record_model.dart';
import '../repository/previous_record_repository.dart';

class PreviousRecordViewModel extends ChangeNotifier {
  final PreviousRecordRepository repository;

  List<PreviousRecord> _records = []; // ✅ 전체 report 저장
  List<PreviousRecord> get records => _records;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PreviousRecordViewModel({required this.repository});

  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();

    try {
      _records = await repository.fetchAllRecords(); // ✅ 전체 기록 받아오기
    } catch (e) {
      debugPrint('에러: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ 중복 제거된 대상자 리스트 반환
  List<TargetInfo> get uniqueTargets {
    final Map<int, TargetInfo> map = {};
    for (var record in _records) {
      map[record.target.targetId] = record.target;
    }
    return map.values.toList();
  }

  /// ✅ targetId에 해당하는 모든 리포트
  List<PreviousRecord> getReportsByTarget(int targetId) {
    return _records.where((r) => r.target.targetId == targetId).toList();
  }

  /// ✅ targetId에 해당하는 대상자 정보
  TargetInfo? getTargetById(int targetId) {
    try {
      return _records.firstWhere((r) => r.target.targetId == targetId).target;
    } catch (e) {
      return null;
    }
  }
}
