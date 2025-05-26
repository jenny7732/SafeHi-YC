import 'package:flutter/material.dart';
import 'package:safehi_yc/view/home/home_page.dart';
import 'package:safehi_yc/view/mypage/mypage.dart';
import 'package:safehi_yc/view/record/previous_record_page.dart';

class BottomNavProvider extends ChangeNotifier {
  // 현재 탭 인덱스
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // 변경: Widget 리스트 → 함수형 빌더로
  final List<Widget Function()> pageBuilders = [
    () => const HomePage(),
    () => const PreviousRecordsPage(),
    () => const MyPage(),
  ];

  // 탭 변경 함수
  void setIndex(int newIndex) {
    if (newIndex >= 0 && newIndex < pageBuilders.length) {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }
}
