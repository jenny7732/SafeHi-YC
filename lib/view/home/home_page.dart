import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/view/visit/visit_checklist_ready.dart';
import 'package:safehi_yc/view_model/user_view_model.dart';
import 'package:safehi_yc/widget/appbar/default_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final userVM = context.watch<UserViewModel>();
    final username = userVM.user?.name ?? 'OOO';

    return Scaffold(
      backgroundColor: AppColors().background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.paddingHorizontal,
            vertical: responsive.sectionSpacing,
          ),
          child: Column(
            children: [
              const DefaultAppBar(title: '양천구청'),

              // 화면 높이 중앙 배치
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 인사 문구 (카드 밖)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          '$username님, 반갑습니다 👋🏻',
                          style: TextStyle(
                            fontSize: responsive.fontBase,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // 인사 카드
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.waving_hand_rounded,
                              color: Colors.orange,
                              size: 30,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '양천구청 STT 자막 서비스를 시작해볼까요?',
                                style: TextStyle(
                                  fontSize: responsive.fontBase,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // STT 안내 카드
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors().primary.withOpacity(0.2),
                              blurRadius: 12,
                              spreadRadius: 3,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '민원 음성이 자막으로 실시간 표시됩니다.',
                              style: TextStyle(
                                fontSize: responsive.fontBase,
                                fontWeight: FontWeight.bold,
                                color: AppColors().primary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '편하게 민원 안내를 받을 수 있도록 도와드립니다.',
                              style: TextStyle(
                                fontSize: responsive.fontSmall,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const CheckListReady(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.mic),
                                label: const Text('실시간 자막 시작하기'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors().primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  textStyle: TextStyle(
                                    fontSize: responsive.fontSmall,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
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
    );
  }
}
