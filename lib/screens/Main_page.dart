import 'package:flutter/material.dart';
import 'AI_camera_result.dart';

class MainPageScreen extends StatelessWidget {
  const MainPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EACD),

      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AICameraResultScreen(),
            ),
          );
        },

        child: SafeArea(
          child: Column(
            children: [
              // 상단 영역
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/icons/pot.png',
                      width: 120,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 메인 컨텐츠 박스
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAED),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(34),
                      topRight: Radius.circular(34),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // 닉네임 박스
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '닉네임',
                                style: TextStyle(
                                  fontFamily: 'RebornFont',
                                  fontSize: 20,
                                  color: Color(0xFF223B2B),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                '새싹 지구 지킴이',
                                style: TextStyle(
                                  fontFamily: 'RebornFont',
                                  fontSize: 16,
                                  color: Color(0xFF223B2B),
                                ),
                              ),
                              const SizedBox(height: 10),

                              Image.asset(
                                'assets/icons/LevelBar.png',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Tip 박스
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '오늘의 실천 Tip!',
                                style: TextStyle(
                                  fontFamily: 'RebornFont',
                                  fontSize: 14,
                                  color: Color(0xFF223B2B),
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                '솜이불은 헌 옷 수거함에 버리면 안돼요!\n종량제 봉투 or 대형 폐기물',
                                style: TextStyle(
                                  fontFamily: 'RebornFont',
                                  fontSize: 13,
                                  color: Color(0xFF223B2B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 이미지 카드 영역
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.asset(
                                      'assets/icons/jeans.png',
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    '청바지로 나만의\n개성있는 가방 만들기',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'RebornFont',
                                      fontSize: 12,
                                      color: Color(0xFF223B2B),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.asset(
                                      'assets/icons/bottlecap.png',
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    '병뚜껑으로 나만의\n귀여운 키링 만들기',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'RebornFont',
                                      fontSize: 12,
                                      color: Color(0xFF223B2B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 하단 네비
              Image.asset(
                'assets/icons/navBar.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}