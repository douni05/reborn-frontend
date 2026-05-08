import 'dart:ui';
import 'package:flutter/material.dart';
import 'Signup.dart';
import 'Main_page.dart';
import '../services/member_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final MemberService _memberService = MemberService();

  void _goToSignup(BuildContext context, {String? email}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupNameScreen(email: email)),
    );
  }

  void _goToMain(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainPageScreen()),
      (route) => false,
    );
  }

  void _showGoogleEmailInput(BuildContext context) {
    final controller = TextEditingController();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF8FAED),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 28,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '이메일로 계속하기',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF223B2B),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'example@gmail.com',
                  hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF4A5A4D)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF4A5A4D)),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final email = controller.text.trim();
                          if (!email.contains('@')) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(content: Text('올바른 이메일을 입력해주세요')),
                            );
                            return;
                          }
                          setModalState(() => isLoading = true);
                          try {
                            final exists = await _memberService.checkEmailExists(email);
                            if (!context.mounted) return;
                            Navigator.pop(ctx);
                            if (exists) {
                              await _memberService.join(
                                email: email,
                                nickname: '',
                                role: 'USER',
                              );
                              if (context.mounted) _goToMain(context);
                            } else {
                              _goToSignup(context, email: email);
                            }
                          } catch (e) {
                            setModalState(() => isLoading = false);
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text('오류가 발생했습니다: $e')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF86A874),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          '계속',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAED),
      extendBody: true,
      body: Stack(
          children: [
            // 하단 잎사귀
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(
                'assets/icons/main_icon.png',
                width: w,
                fit: BoxFit.fitWidth,
              ),
            ),

            // 흐린 원 1
            Positioned(
              left: w * 0.097,
              top: h * 0.216,
              child: _BlurCircle(
                size: w * 0.331,
                color: const Color(0x6639FF14),
                sigma: 35,
              ),
            ),

            // 흐린 원 2
            Positioned(
              left: w * 0.611,
              top: h * 0.317,
              child: _BlurCircle(
                size: w * 0.204,
                color: const Color(0x8058FF2A),
                sigma: 25,
              ),
            ),

            // 로고
            Positioned(
              left: w * 0.216,
              top: h * 0.282,
              child: Text(
                'Re:Born',
                style: TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: w * 0.168,
                  color: const Color(0xFF143424),
                ),
              ),
            ),

            // 로그인 버튼 그룹
            Positioned(
              left: w * 0.079,
              top: h * 0.588,
              child: Column(
                children: [
                  _LoginButton(
                    width: w * 0.840,
                    color: const Color(0xFFF1F1F1),
                    text: '구글로 로그인',
                    textColor: const Color(0xFF7B7A7C),
                    iconPath: 'assets/icons/ic_google.png',
                    onTap: () => _showGoogleEmailInput(context),
                  ),
                  SizedBox(height: h * 0.024),
                  _LoginButton(
                    width: w * 0.840,
                    color: const Color(0xFFFDDC3F),
                    text: '카카오로 로그인',
                    textColor: const Color(0xFF7A6E37),
                    iconPath: 'assets/icons/ic_kakao.png',
                    onTap: () => _goToSignup(context),
                  ),
                  SizedBox(height: h * 0.024),
                  _LoginButton(
                    width: w * 0.840,
                    color: const Color(0xFF03C75A),
                    text: '네이버로 로그인',
                    textColor: const Color(0xFFB8EFCD),
                    iconPath: 'assets/icons/ic_naver.png',
                    onTap: () => _goToSignup(context),
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double sigma;

  const _BlurCircle({
    required this.size,
    required this.color,
    required this.sigma,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final double width;
  final Color color;
  final String text;
  final Color textColor;
  final String iconPath;
  final VoidCallback onTap;

  const _LoginButton({
    required this.width,
    required this.color,
    required this.text,
    required this.textColor,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 58,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(19),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Image.asset(iconPath, width: 24, height: 24),
            Expanded(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(-10, 0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
