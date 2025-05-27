import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/view/login/login_page.dart';
import 'package:safehi_yc/view/mypage/mypage_modify.dart';
import 'package:safehi_yc/view_model/user_view_model.dart';
import 'package:safehi_yc/widget/appbar/default_appbar.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final userVM = context.watch<UserViewModel>();
    final username = userVM.user?.name ?? 'OOO';
    final useremail = userVM.user?.email ?? '이메일이 없습니다.';

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors().background,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: responsive.paddingHorizontal),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final userVM = Provider.of<UserViewModel>(
                    context,
                    listen: false,
                  );
                  await userVM.logout();

                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout,
                      size: responsive.iconSize * 0.9,
                      color: const Color(0xFFB3A5A5),
                    ),
                    SizedBox(width: responsive.itemSpacing * 0.7),
                    Text(
                      '로그아웃',
                      style: TextStyle(
                        fontSize: responsive.fontBase,
                        color: const Color(0xFFB3A5A5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.itemSpacing),
              const Divider(color: Color(0xFFE0DCDC)),
              SizedBox(height: responsive.itemSpacing * 0.6),
              Text(
                '(주) 안심하이\n서울시 중구 퇴계로\n대표: 김민수\n이메일: cs@safehi.co.kr',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.fontSmall,
                  color: const Color(0xFFB3A5A5),
                ),
              ),
              SizedBox(height: responsive.itemSpacing * 0.8),
            ],
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.paddingHorizontal,
          ),
          children: [
            DefaultAppBar(title: '마이페이지'),
            SizedBox(height: responsive.sectionSpacing * 0.7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: responsive.iconSize,
                      backgroundColor: const Color(0xFFFFF8F8),
                      child: Icon(
                        Icons.account_circle,
                        size: responsive.iconSize * 1.7,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    SizedBox(width: responsive.itemSpacing * 0.8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$username님',
                          style: TextStyle(
                            fontSize: responsive.fontLarge,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF433A3A),
                          ),
                        ),
                        Text(
                          useremail,
                          style: TextStyle(
                            fontSize: responsive.fontBase,
                            color: const Color(0xFFB3A5A5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (_) => const MypageModify()),
                //     );
                //   },
                //   child: Text(
                //     '내 정보 수정',
                //     style: TextStyle(
                //       fontSize: responsive.fontSmall,
                //       fontWeight: FontWeight.bold,
                //       color: const Color(0xFFB3A5A5),
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: responsive.sectionSpacing),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.paddingHorizontal * 0.5,
              ),
              child: Column(
                children: [
                  _buildListTile(Icons.phone, '고객센터', responsive),
                  SizedBox(height: responsive.itemSpacing),
                  _buildListTile(Icons.document_scanner, '공지사항', responsive),
                  SizedBox(height: responsive.itemSpacing),
                  _buildListTile(Icons.chat, '자주 묻는 질문', responsive),
                  SizedBox(height: responsive.itemSpacing),
                  _buildListTile(Icons.settings, '약관 및 동의', responsive),
                ],
              ),
            ),
            SizedBox(height: responsive.sectionSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, Responsive responsive) {
    return Row(
      children: [
        Icon(icon, size: responsive.iconSize * 0.9, color: AppColors().primary),
        SizedBox(width: responsive.itemSpacing * 0.6),
        Text(
          title,
          style: TextStyle(
            fontSize: responsive.fontBase,
            color: const Color(0xFF433A3A),
          ),
        ),
        const Spacer(),
        Icon(
          Icons.arrow_forward_ios,
          size: responsive.fontSmall + 2,
          color: const Color(0xFFB3A5A5),
        ),
      ],
    );
  }
}
