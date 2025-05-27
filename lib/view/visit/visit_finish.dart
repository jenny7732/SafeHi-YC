import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/provider/nav/bottom_nav_provider.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/widget/appbar/default_back_appbar.dart';
import 'package:safehi_yc/widget/button/bottom_one_btn.dart';
import 'package:safehi_yc/main_screen.dart';

class VisitFinish extends StatefulWidget {
  const VisitFinish({super.key});

  @override
  State<VisitFinish> createState() => _VisitFinishState();
}

class _VisitFinishState extends State<VisitFinish> {
  @override
  void initState() {
    super.initState();
  }

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
            children: [
              const DefaultBackAppBar(title: '실시간 대화'),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: responsive.sectionSpacing * 2),

                        // ✅ 완료 안내 텍스트
                        Text(
                          '종료되었습니다.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.fontXL,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: responsive.itemSpacing),
                        Text(
                          '안내된 내용을 기록으로 확인해보세요.',
                          style: TextStyle(
                            color: const Color(0xFFB3A5A5),
                            fontSize: responsive.fontBase,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: responsive.sectionSpacing * 3),

                        // ✅ 이미지
                        Image.asset(
                          'assets/images/logo.png',
                          width: responsive.isTablet ? 300 : 230,
                          height: responsive.isTablet ? 300 : 230,
                        ),
                        SizedBox(height: responsive.sectionSpacing * 2),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ✅ 기록 보러가기 버튼
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
        child: BottomOneButton(
          buttonText: '기록 보러가기',
          onButtonTap: () {
            context.read<BottomNavProvider>().setIndex(1);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
              (route) => false,
            );
          },
        ),
      ),
    );
  }
}
