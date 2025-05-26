import '../model/previous_record_model.dart';
import '../service/previous_record_service.dart';

class PreviousRecordRepository {
  final PreviousRecordService service;

  PreviousRecordRepository({required this.service});

  /// ✅ 전체 이전 기록을 그대로 반환
  Future<List<PreviousRecord>> fetchAllRecords() async {
    return await service.fetchAllRecords();
  }
}
