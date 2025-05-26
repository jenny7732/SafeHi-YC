import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/provider/nav/bottom_nav_provider.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/widget/appbar/default_back_appbar.dart';
import 'package:safehi_yc/widget/button/bottom_two_btn.dart';
import 'package:safehi_yc/main_screen.dart';

class RecordSummaryPage extends StatelessWidget {
  final int targetId;

  const RecordSummaryPage({super.key, required this.targetId});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    // ✅ 더미 데이터
    final List<Map<String, String>> dummySummaries = [
      {
        'title': '민원 요약',
        'abstract': '서울시 복지 정책 안내 및 상담 진행',
        'detail': '''
에너지바우처 신청 대상 안내
주소 이전 관련 민원처리 절차 설명
민원인 요청에 따른 수어 통역 제공''',
      },
      {
        'title': '생활지원 안내',
        'abstract': '주거급여 대상자 선정 기준 설명',
        'detail': '''
임대차 계약서 기준 소득 조회
보장 기관별 신청 절차 안내''',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors().background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.paddingHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DefaultBackAppBar(title: '대화 내용 요약'),
              SizedBox(height: responsive.sectionSpacing),

              // ✅ 하나의 큰 요약 카드
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(responsive.sectionSpacing),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFFDD8DA),
                          blurRadius: 4,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          dummySummaries.map((summary) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: responsive.sectionSpacing,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 제목
                                  Text(
                                    '[${summary['title']}]',
                                    style: TextStyle(
                                      color: AppColors().primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsive.fontBase,
                                    ),
                                  ),
                                  SizedBox(height: responsive.itemSpacing / 2),

                                  // 요약 문장
                                  Text(
                                    summary['abstract']!,
                                    style: TextStyle(
                                      fontSize: responsive.fontSmall,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: responsive.itemSpacing),

                                  // 세부 내용 (줄바꿈마다 • 처리)
                                  ...summary['detail']!
                                      .split('\n')
                                      .map(
                                        (line) => Text(
                                          '\u2022 $line',
                                          style: TextStyle(
                                            fontSize: responsive.fontSmall,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ✅ 하단 버튼
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
        child: BottomTwoButton(
          buttonText1: '이전',
          buttonText2: '홈으로 이동',
          onButtonTap1: () {
            Navigator.pop(context);
          },
          onButtonTap2: () {
            Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false,
            );
          },
        ),
      ),
    );
  }
}
