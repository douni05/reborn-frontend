import 'package:flutter/material.dart';
import '../core/storage/auth_storage.dart';
import '../widgets/bottom_nav_bar.dart';

class MainPageScreen extends StatelessWidget {
  const MainPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = AuthStorage();
    final nickname = storage.nickname ?? '';
    final totalXp = storage.totalXp;
    final currentLevel = storage.currentLevel;

    final xpForNextLevel = currentLevel * 200;
    final xpProgress = ((totalXp % xpForNextLevel) / xpForNextLevel).clamp(0.0, 1.0);
    final titleName = currentLevel >= 10
        ? '지구 수호자'
        : currentLevel >= 5
            ? '환경 지킴이'
            : '새싹 지구 지킴이';

    return Scaffold(
      backgroundColor: const Color(0xFFD9EACD),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset('assets/icons/pot.png', width: 150),
            ),
            const SizedBox(height: 20),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Column(
                    children: [
                      // 프로필 카드
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nickname,
                              style: const TextStyle(
                                fontFamily: 'RebornFont',
                                fontSize: 28,
                                color: Color(0xFF223B2B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Color(0xFF223B2B),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  titleName,
                                  style: const TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 16,
                                    color: Color(0xFF223B2B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Level $currentLevel',
                                  style: const TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 12,
                                    color: Color(0xFF223B2B),
                                  ),
                                ),
                                Text(
                                  '$totalXp/$xpForNextLevel XP',
                                  style: const TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 12,
                                    color: Color(0xFF223B2B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: double.infinity,
                                height: 20,
                                color: const Color(0xFFE6E8E9),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: xpProgress,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF173C2A),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 팁 카드
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
                                fontSize: 13,
                                color: Color(0xFF223B2B),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '솜이불은 헌 옷 수거함에 버리면 안돼요!\n종량제 봉투 or 대형 폐기물',
                              style: TextStyle(
                                fontFamily: 'RebornFont',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF223B2B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 이미지 카드 2개
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    'assets/icons/jeans.png',
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  '청바지로 나만의\n개성있는 가방 만들기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 13,
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
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  '병뚜껑으로 나만의\n귀여운 키링 만들기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 13,
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
            const BottomNavBar(selectedIndex: 0),
          ],
        ),
      ),
    );
  }
}