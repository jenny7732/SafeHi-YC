import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/view/login/login_page.dart';
import 'package:safehi_yc/view/mypage/mypage_modify.dart';
import 'package:safehi_yc/view_model/user_view_model.dart';
import 'package:safehi_yc/widget/appbar/default_appbar.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final username = userVM.user?.name ?? 'OOO';
    final useremail = userVM.user?.email ?? '이메일이 없습니다.';

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors().background,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.logout, size: 25, color: Color(0xFFB3A5A5)),
                    SizedBox(width: 10),
                    Text(
                      '로그아웃',
                      style: TextStyle(fontSize: 15, color: Color(0xFFB3A5A5)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE0DCDC)),
              const SizedBox(height: 8),
              const Text(
                '(주) 안심하이\n서울시 중구 퇴계로\n대표: 김민수\n이메일: cs@safehi.co.kr',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFFB3A5A5)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          children: [
            DefaultAppBar(title: '마이페이지'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xFFFFF8F8),
                      child: Icon(
                        Icons.account_circle,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$username님',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF433A3A),
                          ),
                        ),
                        Text(
                          useremail,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFB3A5A5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MypageModify()),
                    );
                  },
                  child: const Text(
                    '내 정보 수정',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB3A5A5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _buildListTile(Icons.phone, '고객센터'),
                  const SizedBox(height: 20),
                  _buildListTile(Icons.document_scanner, '공지사항'),
                  const SizedBox(height: 20),
                  _buildListTile(Icons.chat, '자주 묻는 질문'),
                  const SizedBox(height: 20),
                  _buildListTile(Icons.settings, '약관 및 동의'),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 30, color: AppColors().primary),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 18, color: Color(0xFF433A3A)),
        ),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFB3A5A5)),
      ],
    );
  }
}
