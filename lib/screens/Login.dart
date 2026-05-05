import 'dart:ui';
import 'package:flutter/material.dart';
import 'Signup.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupNameScreen()),
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
                    onTap: () => _goToSignup(context),
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
