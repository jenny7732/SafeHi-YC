import 'package:safehi_yc/model/stt_result_model.dart';
import 'package:safehi_yc/model/visit_detail_model.dart';
import 'package:safehi_yc/service/visit_service.dart';

class VisitRepository {
  final VisitService service;

  VisitRepository({required this.service});

  /// 방문 상세
  Future<VisitDetail> getVisitDetail(int reportId) {
    return service.getTargetDetail(reportId);
  }

  final VisitService _service = VisitService();

  Future<Map<String, dynamic>> uploadSttTitle(String title) {
    return _service.uploadSttTitle(title);
  }

  Future<List<SttResult>> getSttResultList() {
    return service.fetchSttResultList();
  }

  Future<String> getConversationText(int reportId) {
    return service.getConversationText(reportId);
  }
}
