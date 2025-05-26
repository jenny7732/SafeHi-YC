import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/format_phone.dart';
import 'package:safehi_yc/view_model/user_view_model.dart';
import 'package:safehi_yc/widget/appbar/default_back_appbar.dart';

class MypageModify extends StatelessWidget {
  const MypageModify({super.key});

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final username = userVM.user?.name ?? 'OOO';
    final useremail = userVM.user?.email ?? '이메일이 없습니다.';
    final rawPhone = userVM.user?.phoneNumber ?? '';
    final userphone =
        rawPhone.isNotEmpty ? formatPhoneNumber(rawPhone) : '전화번호가 없습니다.';

    return Scaffold(
      backgroundColor: AppColors().background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DefaultBackAppBar(title: '내 정보 수정하기'),
              const SizedBox(height: 24),

              // ✅ 프로필 이미지 제거됨
              const SizedBox(height: 12),
              const Text(
                '기본정보',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _buildLabel('이름'),
              _buildInputField(hint: username),
              const SizedBox(height: 12),
              _buildLabel('아이디(이메일)'),
              _buildInputField(hint: useremail, enabled: false),
              const SizedBox(height: 12),
              _buildLabel('전화번호'),
              _buildInputField(hint: userphone, enabled: false),

              // ✅ 연락처 및 인증 버튼 제거됨
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              const Text(
                '비밀번호',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _buildLabel('현재 비밀번호'),
              _buildInputField(hint: '현재 비밀번호 입력', obscure: true),
              const SizedBox(height: 12),
              _buildLabel('새로운 비밀번호'),
              _buildInputField(hint: '비밀번호를 입력해 주세요.', obscure: true),
              const SizedBox(height: 12),
              _buildLabel('새로운 비밀번호 확인'),
              _buildInputField(hint: '비밀번호를 한번 더 입력해 주세요.', obscure: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '수정하기',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('회원탈퇴', style: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    bool enabled = true,
    bool obscure = false,
  }) {
    return TextField(
      enabled: enabled,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
