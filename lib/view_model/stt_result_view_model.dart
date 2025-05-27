import 'package:flutter/material.dart';
import 'package:safehi_yc/model/stt_result_model.dart';
import 'package:safehi_yc/repository/visit_repository.dart';

class SttResultViewModel extends ChangeNotifier {
  final VisitRepository repository;

  SttResultViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<SttResult> _results = [];
  List<SttResult> get results => _results;

  String? _error;
  String? get error => _error;

  Future<void> fetchResults() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _results = await repository.getSttResultList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
