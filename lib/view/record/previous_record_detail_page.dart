import 'package:flutter/material.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/view/record/record_summary_page.dart';
import 'package:safehi_yc/widget/appbar/default_back_appbar.dart';
import 'package:safehi_yc/widget/button/bottom_two_btn.dart';

class PreviousRecordDetailPage extends StatelessWidget {
  final int targetId;

  const PreviousRecordDetailPage({super.key, required this.targetId});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

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
              const DefaultBackAppBar(title: '상세 보기'),
              SizedBox(height: responsive.sectionSpacing),

              /// 프로필 카드
              Container(
                padding: EdgeInsets.all(responsive.cardSpacing),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "STT 제목",
                      style: TextStyle(
                        fontSize: responsive.fontLarge,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: responsive.itemSpacing),
                    _buildDetailRow(
                      '날짜',
                      "2024-05-01",
                      Icons.calendar_month_rounded,
                      responsive,
                    ),
                    SizedBox(height: responsive.itemSpacing),
                    _buildDetailRow(
                      '시간',
                      "15:00",
                      Icons.punch_clock_rounded,
                      responsive,
                    ),
                  ],
                ),
              ),

              SizedBox(height: responsive.sectionSpacing + 4),
              Text(
                '상담 내용 전체',
                style: TextStyle(
                  fontSize: responsive.fontBase + 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: responsive.itemSpacing),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(responsive.cardSpacing),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      '''안녕하세요, 오늘은 서울시 복지 혜택에 대해 안내드렸습니다.

- 대상자는 기존 기초연금 수급자이며, 금년부터 에너지바우처 대상자에 해당됩니다.
- 주소 이전 관련 행정 절차도 문의하였으며, 구청 내 민원실에서 처리할 수 있도록 안내했습니다.
- 청각장애로 인해 민원소통이 어려운 부분을 STT 자막으로 충분히 보완하였습니다.

상담을 마무리하며, 다음 방문 시에도 동일한 방식으로 소통 예정입니다.

''',
                      style: TextStyle(
                        fontSize: responsive.fontSmall,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
        child: BottomTwoButton(
          buttonText1: '이전',
          buttonText2: '요약된 내용 보러가기',
          onButtonTap1: () {
            Navigator.pop(context);
          },
          onButtonTap2: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecordSummaryPage(targetId: targetId),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Responsive responsive,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: AppColors().primary),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: responsive.fontSmall,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: responsive.fontSmall,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
