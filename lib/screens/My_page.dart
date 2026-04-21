import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EACD),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            const Text(
              '마이페이지',
              style: TextStyle(
                fontFamily: 'RebornFont',
                fontSize: 26,
                color: Color(0xFF1F402C),
              ),
            ),
            const SizedBox(height: 18),
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
                  padding: const EdgeInsets.fromLTRB(12, 18, 12, 0),
                  child: Column(
                    children: [
                      _buildProfileCard(),
                      const SizedBox(height: 16),
                      _buildMenuButton(text: '나의 리폼 히스토리'),
                      const SizedBox(height: 10),
                      _buildMenuButton(text: '나의업 수정'),
                      const SizedBox(height: 10),
                      _buildMenuButton(text: '정보 변경'),
                      const SizedBox(height: 22),
                      _buildMenuButton(text: '전문가 등록'),
                      const SizedBox(height: 10),
                      _buildMenuButton(text: '전문가 대시보드'),
                      const SizedBox(height: 22),
                      _buildWithdrawButton(
                        context: context,
                        text: '탈퇴',
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '닉네임',
            style: TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 22,
              color: Color(0xFF1F402C),
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(
                Icons.star,
                size: 14,
                color: Colors.black,
              ),
              SizedBox(width: 4),
              Text(
                '새싹 지구 지킴이',
                style: TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: 14,
                  color: Color(0xFF1F402C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level 1',
                style: TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: 10,
                  color: Color(0xFF1F402C),
                ),
              ),
              Text(
                '1/200',
                style: TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: 10,
                  color: Color(0xFF1F402C),
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
                child: Container(
                  width: 16,
                  height: 20,
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
        ],
      ),
    );
  }

  Widget _buildMenuButton({required String text}) {
    return Container(
      width: double.infinity,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        '• $text',
        style: const TextStyle(
          fontFamily: 'RebornFont',
          fontSize: 15,
          color: Color(0xFF1F402C),
        ),
      ),
    );
  }

  Widget _buildWithdrawButton({
    required BuildContext context,
    required String text,
  }) {
    return GestureDetector(
      onTap: () {
        _showWithdrawDialog(context);
      },
      child: Container(
        width: double.infinity,
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerLeft,
        child: const Text(
          '• 탈퇴',
          style: TextStyle(
            fontFamily: 'RebornFont',
            fontSize: 15,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 78,
      width: double.infinity,
      color: const Color(0xFFD9EACD),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _BottomNavItem(
                icon: Icons.home_outlined,
                label: '홈',
              ),
              _BottomNavItem(
                icon: Icons.build_outlined,
                label: '리폼하기',
              ),
              SizedBox(width: 60),
              _BottomNavItem(
                icon: Icons.article_outlined,
                label: '전문가연결',
              ),
              _BottomNavItem(
                icon: Icons.person_outline,
                label: '마이페이지',
              ),
            ],
          ),
          Positioned(
            top: -8,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFFA8C88E),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFD9EACD),
                  width: 6,
                ),
              ),
              child: const Icon(
                Icons.recycling,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 18, 12, 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAED),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '정말 탈퇴하실 건가요? 🥺',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 24,
                    color: Color(0xFF1F402C),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '탈퇴 후 되돌릴 순 없습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 13,
                    color: Color(0xFF1F402C),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE57272),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            '탈퇴(지구야 미안해)',
                            style: TextStyle(
                              fontFamily: 'RebornFont',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFB7B7B7),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '취소(지구 지켜야지)',
                              style: TextStyle(
                                fontFamily: 'RebornFont',
                                fontSize: 12,
                                color: Color(0xFF1F402C),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BottomNavItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: const Color(0xFF1F402C),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 11,
              color: Color(0xFF1F402C),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}