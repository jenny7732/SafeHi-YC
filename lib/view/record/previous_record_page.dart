import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/view/record/previous_record_detail_page.dart';
import 'package:safehi_yc/view/record/widget/visit_record_card.dart';
import 'package:safehi_yc/view_model/stt_result_view_model.dart';
import 'package:safehi_yc/widget/appbar/default_appbar.dart';

class PreviousRecordsPage extends StatefulWidget {
  const PreviousRecordsPage({super.key});

  @override
  State<PreviousRecordsPage> createState() => _PreviousRecordsPageState();
}

class _PreviousRecordsPageState extends State<PreviousRecordsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SttResultViewModel>().fetchResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final vm = context.watch<SttResultViewModel>();

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

              if (vm.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),

              if (vm.error != null)
                Expanded(child: Center(child: Text('오류 발생: ${vm.error}'))),

              if (!vm.isLoading && vm.error == null)
                Expanded(
                  child:
                      vm.results.isEmpty
                          ? const Center(child: Text('기록이 없습니다.'))
                          : ListView.separated(
                            itemCount: vm.results.length,
                            separatorBuilder:
                                (_, __) =>
                                    SizedBox(height: responsive.itemSpacing),
                            itemBuilder: (context, index) {
                              final record = vm.results[index];
                              return VisitRecordCard(
                                id: record.reportId,
                                title: record.sttFileName,
                                date: record.startTime
                                    .split(' ')[0]
                                    .replaceAll('-', '.'),
                                isTablet: responsive.isTablet,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => PreviousRecordDetailPage(
                                            targetId: record.reportId,
                                            sttTitle: record.sttFileName,
                                            startTime: record.startTime,
                                          ),
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
