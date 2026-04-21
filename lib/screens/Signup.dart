import 'package:flutter/material.dart';
import 'Main_page.dart'; // 추가

class SignupNameScreen extends StatelessWidget {
  const SignupNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAED),

      // 👇 전체 화면 터치 시 이동
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPageScreen(),
            ),
          );
        },

        child: SafeArea(
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
                  child: const TextField(
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: '2자 이상 8자 이하',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
                    style: TextStyle(
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainPageScreen(),
                        ),
                      );
                    },
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
      ),
    );
  }
}