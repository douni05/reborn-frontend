import 'dart:ui';
import 'package:flutter/material.dart';
import 'Signup.dart'; // 파일명 맞게 확인

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAED),

      // 👇 전체 화면 클릭 시 이동
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignupNameScreen(),
            ),
          );
        },

        child: Center(
          child: SizedBox(
            width: 393,
            height: 852,
            child: Stack(
              children: [
                // 하단 잎사귀
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/icons/main_icon.png',
                    width: 393,
                    fit: BoxFit.fitWidth,
                  ),
                ),

                // 홈 인디케이터
                Positioned(
                  left: 0,
                  bottom: 8,
                  child: Image.asset(
                    'assets/icons/Home_Indicator.png',
                    width: 393,
                  ),
                ),

                // 흐린 원 1
                const Positioned(
                  left: 38,
                  top: 184,
                  child: _BlurCircle(
                    size: 130,
                    color: Color(0x6639FF14),
                    sigma: 35,
                  ),
                ),

                // 흐린 원 2
                const Positioned(
                  left: 240,
                  top: 270,
                  child: _BlurCircle(
                    size: 80,
                    color: Color(0x8058FF2A),
                    sigma: 25,
                  ),
                ),

                // 로고
                const Positioned(
                  left: 85,
                  top: 240,
                  child: Text(
                    'Re:Born',
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 66,
                      color: Color(0xFF143424),
                    ),
                  ),
                ),

                // 구글 버튼
                Positioned(
                  left: 31,
                  top: 501,
                  child: _LoginButton(
                    color: const Color(0xFFF1F1F1),
                    text: '구글로 로그인',
                    textColor: const Color(0xFF7B7A7C),
                    iconPath: 'assets/icons/ic_google.png',
                    onTap: () {
                      _goToSignup(context);
                    },
                  ),
                ),

                // 카카오 버튼
                Positioned(
                  left: 31,
                  top: 579,
                  child: _LoginButton(
                    color: const Color(0xFFFDDC3F),
                    text: '카카오로 로그인',
                    textColor: const Color(0xFF7A6E37),
                    iconPath: 'assets/icons/ic_kakao.png',
                    onTap: () {
                      _goToSignup(context);
                    },
                  ),
                ),

                // 네이버 버튼
                Positioned(
                  left: 31,
                  top: 654,
                  child: _LoginButton(
                    color: const Color(0xFF03C75A),
                    text: '네이버로 로그인',
                    textColor: const Color(0xFFB8EFCD),
                    iconPath: 'assets/icons/ic_naver.png',
                    onTap: () {
                      _goToSignup(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupNameScreen(),
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
  final Color color;
  final String text;
  final Color textColor;
  final String iconPath;
  final VoidCallback onTap;

  const _LoginButton({
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
        width: 330,
        height: 58,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(19),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
            ),
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