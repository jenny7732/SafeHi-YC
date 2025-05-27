import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/view/record/record_summary_page.dart';
import 'package:safehi_yc/widget/appbar/default_back_appbar.dart';
import 'package:safehi_yc/widget/button/bottom_two_btn.dart';
import 'package:safehi_yc/view_model/visit_view_model.dart';

class PreviousRecordDetailPage extends StatefulWidget {
  final int targetId;
  final String sttTitle;
  final String startTime;

  const PreviousRecordDetailPage({
    super.key,
    required this.targetId,
    required this.sttTitle,
    required this.startTime,
  });

  @override
  State<PreviousRecordDetailPage> createState() =>
      _PreviousRecordDetailPageState();
}

class _PreviousRecordDetailPageState extends State<PreviousRecordDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VisitUploadViewModel>().fetchConversationText(
        widget.targetId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final vm = context.watch<VisitUploadViewModel>();
    final date = widget.startTime.split(' ')[0].replaceAll('-', '.');
    final time =
        widget.startTime.split(' ').length > 1
            ? widget.startTime.split(' ')[1].substring(0, 5)
            : '';

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

              /// STT 카드
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
                      widget.sttTitle,
                      style: TextStyle(
                        fontSize: responsive.fontLarge,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: responsive.itemSpacing),
                    _buildDetailRow(
                      '날짜',
                      date,
                      Icons.calendar_month_rounded,
                      responsive,
                    ),
                    SizedBox(height: responsive.itemSpacing),
                    _buildDetailRow(
                      '시작 시각',
                      time,
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
                    child:
                        vm.conversationText == null
                            ? const Center(child: CircularProgressIndicator())
                            : Text(
                              vm.conversationText!.isEmpty
                                  ? '내용이 없습니다.'
                                  : vm.conversationText!,
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
          onButtonTap1: () => Navigator.pop(context),
          onButtonTap2: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecordSummaryPage(targetId: widget.targetId),
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
        const SizedBox(width: 8),
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
