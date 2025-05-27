import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/provider/nav/bottom_nav_provider.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/view_model/visit_summary_view_model.dart';
import 'package:safehi_yc/widget/appbar/default_back_appbar.dart';
import 'package:safehi_yc/widget/button/bottom_two_btn.dart';
import 'package:safehi_yc/main_screen.dart';

class RecordSummaryPage extends StatefulWidget {
  final int targetId;

  const RecordSummaryPage({super.key, required this.targetId});

  @override
  State<RecordSummaryPage> createState() => _RecordSummaryPageState();
}

class _RecordSummaryPageState extends State<RecordSummaryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<VisitSummaryViewModel>().fetchSummary(widget.targetId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final vm = context.watch<VisitSummaryViewModel>();

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

              if (vm.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),

              if (!vm.isLoading && vm.statusMessage != null)
                Expanded(
                  child: Center(
                    child: Text(
                      vm.statusMessage!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

              if (!vm.isLoading && vm.statusMessage == null)
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
                            vm.summaries.map((summary) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: responsive.sectionSpacing,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '[${summary.subject}]',
                                      style: TextStyle(
                                        color: AppColors().primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: responsive.fontBase,
                                      ),
                                    ),
                                    SizedBox(
                                      height: responsive.itemSpacing / 2,
                                    ),
                                    Text(
                                      summary.abstract,
                                      style: TextStyle(
                                        fontSize: responsive.fontSmall,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: responsive.itemSpacing),
                                    ...summary.detail
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
