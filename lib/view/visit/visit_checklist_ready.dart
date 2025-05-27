import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/view/visit/visit_process.dart';
import 'package:safehi_yc/view_model/visit_view_model.dart';
import 'package:safehi_yc/widget/appbar/default_back_appbar.dart';
import 'package:safehi_yc/widget/button/bottom_one_btn.dart';

class CheckListReady extends StatefulWidget {
  const CheckListReady({super.key});

  @override
  State<CheckListReady> createState() => _CheckListReadyState();
}

class _CheckListReadyState extends State<CheckListReady> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<VisitUploadViewModel>();
      _titleController.text = vm.title;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<VisitUploadViewModel>().resetTitle();
      }
    });
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final vm = context.watch<VisitUploadViewModel>();

    return Scaffold(
      backgroundColor: AppColors().background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.paddingHorizontal,
          ),
          child: Column(
            children: [
              const DefaultBackAppBar(title: '실시간 대화'),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '실시간 자막을 시작합니다.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: responsive.fontXL,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: responsive.itemSpacing),
                      Text(
                        '민원 내용을 자막으로 안내해드릴게요.',
                        style: TextStyle(
                          color: const Color(0xFFB3A5A5),
                          fontSize: responsive.fontBase,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: responsive.sectionSpacing * 2.5),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors().primary.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'STT 제목을 입력해주세요',
                              style: TextStyle(
                                color: AppColors().primary,
                                fontSize: responsive.fontBase,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: responsive.itemSpacing),
                            TextField(
                              controller: _titleController,
                              onChanged: vm.setTitle,
                              style: const TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                hintText: '예: 노인 민원 자막 안내',
                                hintStyle: const TextStyle(
                                  color: Color(0xFFB3A5A5),
                                ),
                                prefixIcon: const Icon(
                                  Icons.edit_note_rounded,
                                  color: Color(0xFFB3A5A5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF9F9F9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(height: responsive.itemSpacing * 0.7),
                            Text(
                              '입력하지 않으면 기본 제목으로 저장됩니다.',
                              style: TextStyle(
                                fontSize: responsive.fontSmall,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
        child: BottomOneButton(
          buttonText: '시작하기',
          onButtonTap: () async {
            final title =
                vm.title.trim().isEmpty ? '구청 민원 응대기록' : vm.title.trim();
            try {
              final result = await vm.uploadSttTitle(title);
              final reportId = result['reportid'];
              if (reportId == null) {
                throw Exception('서버 응답에 reportid가 없습니다.');
              }

              debugPrint('[✅ STT 제목 업로드 성공 / reportid: $reportId]');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VisitProcess(reportId: reportId),
                ),
              );
            } catch (e) {
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('오류'),
                      content: Text(e.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('확인'),
                        ),
                      ],
                    ),
              );
            }
          },
        ),
      ),
    );
  }
}
