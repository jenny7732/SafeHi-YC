import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/view/record/previous_record_detail_page.dart';
import 'package:safehi_yc/view/record/widget/visit_record_card.dart';
import 'package:safehi_yc/view_model/previous_record_view_model.dart';
import 'package:safehi_yc/widget/appbar/default_appbar.dart';

class PreviousRecordsPage extends StatelessWidget {
  const PreviousRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    // ✅ title + date 형태로 더미 데이터 구성
    final List<Map<String, dynamic>> dummyRecords = [
      {'id': 1, 'title': '청각장애인 민원 응대', 'date': '2024.05.01'},
      {'id': 2, 'title': '노인 대상 자막 안내', 'date': '2024.04.28'},
      {'id': 3, 'title': '수어 통역 요청 기록', 'date': '2024.04.25'},
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors().background,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.paddingHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DefaultAppBar(title: '이전 기록'),
              SizedBox(height: responsive.sectionSpacing),

              // ✅ 리스트 렌더링
              Expanded(
                child: ListView.separated(
                  itemCount: dummyRecords.length,
                  separatorBuilder:
                      (_, __) => SizedBox(height: responsive.itemSpacing),
                  itemBuilder: (context, index) {
                    final record = dummyRecords[index];
                    return VisitRecordCard(
                      id: record['id'],
                      title: record['title'],
                      date: record['date'],
                      isTablet: responsive.isTablet,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => PreviousRecordDetailPage(targetId: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
