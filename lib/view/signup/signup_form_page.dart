import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/model/user_register_model.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/view/login/login_page.dart';
import 'package:safehi_yc/view_model/signup_view_model.dart';
import 'package:safehi_yc/widget/appbar/default_back_appbar.dart';
import 'package:safehi_yc/widget/button/bottom_one_btn.dart';

class SignupFormPage extends StatefulWidget {
  const SignupFormPage({super.key});

  @override
  State<SignupFormPage> createState() => _SignupFormPageState();
}

class _SignupFormPageState extends State<SignupFormPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthController = TextEditingController();
  DateTime? _selectedBirthDate;

  bool _isEmailChecked = false;
  String _gender = '남';
  bool _isObscurePassword = true;
  bool _isObscureConfirm = true;

  bool? _isEmailAvailable; // 서버 응답 기준 중복 여부
  String? _emailCheckMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _isEmailChecked &&
        _isEmailAvailable == true &&
        _validateEmail(_emailController.text) &&
        _validatePassword(_passwordController.text) == null &&
        _passwordController.text == _confirmPasswordController.text &&
        _nameController.text.isNotEmpty &&
        _validatePhoneNumber(_phoneController.text) &&
        _birthController.text.isNotEmpty;
  }

  String? _validatePassword(String value) {
    String pattern =
        r'^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,15}$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return '비밀번호를 입력하세요';
    } else if (value.length < 8) {
      return '비밀번호는 8자리 이상이어야 합니다';
    } else if (!regExp.hasMatch(value)) {
      return '특수문자, 문자, 숫자 포함 \n8자 이상 15자 이내로 입력하세요.';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final passwordMatch =
        _passwordController.text == _confirmPasswordController.text;
    final passwordError = _validatePassword(_passwordController.text);

    return Scaffold(
      backgroundColor: AppColors().background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.paddingHorizontal,
          ),
          child: Column(
            children: [
              DefaultBackAppBar(title: '회원 가입'),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: responsive.sectionSpacing),
                      _buildEmailField(),
                      if (_isEmailChecked &&
                          _isEmailAvailable == true &&
                          _validateEmail(_emailController.text))
                        _helperText('사용 가능한 이메일입니다.'),

                      if (_isEmailChecked &&
                          (_isEmailAvailable == false ||
                              !_validateEmail(_emailController.text)))
                        _helperText(
                          _emailCheckMessage ?? '이메일을 다시 확인해주세요.',
                          isError: true,
                        ),

                      _buildPasswordField(
                        '비밀번호',
                        _passwordController,
                        _isObscurePassword,
                        () {
                          setState(
                            () => _isObscurePassword = !_isObscurePassword,
                          );
                        },
                      ),
                      if (passwordError != null)
                        _helperText(passwordError, isError: true),
                      _buildPasswordField(
                        '비밀번호 확인',
                        _confirmPasswordController,
                        _isObscureConfirm,
                        () {
                          setState(
                            () => _isObscureConfirm = !_isObscureConfirm,
                          );
                        },
                      ),
                      if (_passwordController.text.isNotEmpty &&
                          _confirmPasswordController.text.isNotEmpty)
                        _helperText(
                          passwordMatch ? '비밀번호가 일치합니다.' : '비밀번호가 일치하지 않습니다.',
                          isError: !passwordMatch,
                        ),
                      _buildTextField(label: '이름', controller: _nameController),
                      _buildTextField(
                        label: '전화번호',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        hintText: '예시) 010-1234-5678',
                      ),
                      if (_phoneController.text.isNotEmpty &&
                          !_validatePhoneNumber(_phoneController.text))
                        _helperText('전화번호 형식이 올바르지 않습니다.', isError: true),
                      _buildBirthField(),
                      SizedBox(height: responsive.itemSpacing),
                      _buildGenderSelection(),
                      SizedBox(height: responsive.sectionSpacing),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: responsive.paddingHorizontal),
        child: BottomOneButton(
          buttonText: '가입하기',
          isEnabled: _isFormValid,
          onButtonTap: () async {
            if (_isFormValid) {
              final genderValue = _gender == '남' ? 1 : 0;

              final user = UserRegisterModel(
                name: _nameController.text.trim(),
                phoneNumber: _phoneController.text.trim(),
                email: _emailController.text.trim(),
                birthdate: _birthController.text.trim(),
                gender: genderValue,
                password: _passwordController.text.trim(),
              );

              final viewModel = Provider.of<SignupViewModel>(
                context,
                listen: false,
              );
              final result = await viewModel.signup(user);
              final success = result['success'] as bool;
              final msg = result['msg'] as String;

              if (success) {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (_) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: AppColors().background,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: AppColors().primary,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                '회원가입이 완료되었습니다!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // 팝업 닫기
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginPage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors().primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    '확인',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                );
              } else {
                showErrorDialog(context, msg);
              }
            }
          },
        ),
      ),
    );
  }

  bool _validateEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  bool _validatePhoneNumber(String phone) {
    return RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(phone);
  }

  Widget _buildEmailField() {
    return _buildTextField(
      label: '이메일',
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      suffixIcon: TextButton(
        onPressed: () async {
          final viewModel = context.read<SignupViewModel>();
          final msg = await viewModel.checkEmail(_emailController.text);

          setState(() {
            _isEmailChecked = true;
            _isEmailAvailable = viewModel.isEmailChecked;
            _emailCheckMessage = msg;
          });
        },

        child: const Text('중복확인', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool isObscure,
    VoidCallback toggle,
  ) {
    return _buildTextField(
      label: label,
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      obscure: isObscure,
      suffixIcon: IconButton(
        onPressed: toggle,
        icon: Icon(
          isObscure
              ? FontAwesomeIcons.solidEyeSlash
              : FontAwesomeIcons.solidEye,
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
    String? hintText,
  }) {
    final responsive = Responsive(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelText(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
          style: TextStyle(fontSize: responsive.fontBase),
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: const Color(0xFFF9F6F6),
            filled: true,
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFEBE7E7)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFEBE7E7), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: responsive.itemSpacing),
      ],
    );
  }

  Widget _buildBirthField() {
    final responsive = Responsive(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelText('생년월일'),
        const SizedBox(height: 6),
        TextField(
          controller: _birthController,
          readOnly: true,
          style: TextStyle(fontSize: responsive.fontBase),
          decoration: InputDecoration(
            hintText: 'YYYY-MM-DD',
            fillColor: const Color(0xFFF9F6F6),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFEBE7E7)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFEBE7E7), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onTap: () async {
            FocusScope.of(context).unfocus();
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedBirthDate ?? DateTime(now.year - 20),
              firstDate: DateTime(1900),
              lastDate: now,
            );
            if (picked != null) {
              setState(() {
                _selectedBirthDate = picked;
                _birthController.text = _formatDate(picked);
              });
            }
          },
        ),
        SizedBox(height: responsive.itemSpacing),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Widget _buildGenderSelection() {
    final responsive = Responsive(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelText('성별'),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildRadioButton('남'),
            SizedBox(width: responsive.itemSpacing),
            _buildRadioButton('여'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioButton(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _gender,
          onChanged: (val) => setState(() => _gender = val!),
          activeColor: Colors.red,
        ),
        Text(value),
      ],
    );
  }

  Widget _buildLabelText(String label) {
    final responsive = Responsive(context);
    return Text.rich(
      TextSpan(
        text: label,
        style: TextStyle(fontSize: responsive.fontM),
        children: [TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
      ),
    );
  }

  Widget _helperText(String message, {bool isError = false}) {
    final responsive = Responsive(context);
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.itemSpacing),
      child: Row(
        children: [
          Icon(
            isError ? Icons.close : Icons.check,
            size: responsive.fontSmall,
            color: isError ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 4),
          Text(
            message,
            style: TextStyle(
              color: isError ? Colors.red : Colors.green,
              fontSize: responsive.fontSmall,
            ),
          ),
        ],
      ),
    );
  }
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors().background,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors().primary,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}
