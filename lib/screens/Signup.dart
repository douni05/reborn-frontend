import 'package:flutter/material.dart';
import 'Main_page.dart';
import '../services/api_service.dart';
import '../core/user_session.dart';

class SignupNameScreen extends StatefulWidget {  // StatefulWidget으로 변경
  const SignupNameScreen({super.key});

  @override
  State<SignupNameScreen> createState() => _SignupNameScreenState();
}

class _SignupNameScreenState extends State<SignupNameScreen> {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _goToMain() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.length < 2 || nickname.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임은 2자 이상 8자 이하로 입력해주세요')),
      );
      return;
    }

    try {
      final result = await ApiService().join(nickname);
      // 서버에서 받은 userId 저장
      UserSession.init(result['userId'], result['nickname']);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MainPageScreen(),
        ),
      );
    } catch (e) {
      // 서버 꺼져있어도 로컬로 진행
      UserSession.init(1, nickname);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MainPageScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27),
          child: Column(
            children: [
              const SizedBox(height: 140),
              const Text(
                '반가워요!\n당신의 이름은 무엇인가요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF223B2B),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  border: Border.all(
                    color: const Color(0xFF4A5A4D),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _nicknameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: '2자 이상 8자 이하',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF223B2B),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _goToMain,  // 닉네임 검증 후 이동
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF86A874),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    '완료',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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