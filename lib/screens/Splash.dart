import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/storage/auth_storage.dart';
import 'Login.dart';
import 'Main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    // 저장된 토큰 불러오기
    final isLoggedIn = await AuthStorage().load();

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const MainPageScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAED),
      body: Stack(
        children: [
          // Ellipse 18 - 큰 연두색 블러 원 (좌상단)
          Positioned(
            left: size.width * 0.094,
            top: size.height * 0.306,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                width: size.width * 0.377,
                height: size.width * 0.377,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFDAF3D1),
                ),
              ),
            ),
          ),
          // Ellipse 20 - 작은 밝은 녹색 블러 원 (우하단)
          Positioned(
            left: size.width * 0.674,
            top: size.height * 0.436,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                width: size.width * 0.165,
                height: size.width * 0.165,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF96FF72).withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          // Re:Born 텍스트
          Align(
            alignment: const Alignment(0, -0.1),
            child: Text(
              'Re:Born',
              style: TextStyle(
                fontFamily: 'RebornFont',
                fontSize: size.width * 0.178,
                color: const Color(0xFF143424),
                height: 1.08,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
