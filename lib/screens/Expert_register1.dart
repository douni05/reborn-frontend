import 'package:flutter/material.dart';
import 'Expert_register2.dart';

class ExpertRegister1Screen extends StatelessWidget {
  const ExpertRegister1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAED),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 22),
              decoration: const BoxDecoration(
                color: Color(0xFFD9EACD),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '전문가 등록',
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 30,
                      color: Color(0xFF1F402C),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '업사이클링 전문가로 등록하고 고객과 연결되세요!',
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 13,
                      color: Color(0xFF33543C),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          '📋',
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '사업자 정보',
                          style: TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 28,
                            color: Color(0xFF1F402C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      '공방/작업실 이름',
                      style: TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 18,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _inputBox(hint: '예: 지미의 공방'),
                    const SizedBox(height: 18),
                    const Text(
                      '사업자등록번호',
                      style: TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 18,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _inputBox(hint: '000-00-00000'),
                    const SizedBox(height: 18),
                    const Text(
                      '대표자명',
                      style: TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 18,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _inputBox(hint: '홍길동'),
                    const SizedBox(height: 18),
                    const Text(
                      '연락처',
                      style: TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 18,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _inputBox(hint: '010-0000-0000'),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const ExpertRegister2Screen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF87A676),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(
                              color: Color(0xFF6E8B64),
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Text(
                          '다음단계',
                          style: TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const _RegisterBottomNav(),
          ],
        ),
      ),
    );
  }

  static Widget _inputBox({required String hint}) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF3E5C45),
          width: 1,
        ),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        style: const TextStyle(
          fontFamily: 'RebornFont',
          fontSize: 16,
          color: Color(0xFF1F402C),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'RebornFont',
            fontSize: 16,
            color: Color(0xFF9AA39A),
          ),
        ),
      ),
    );
  }
}

class _RegisterBottomNav extends StatelessWidget {
  const _RegisterBottomNav();

  @override
  Widget build(BuildContext context) {
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
              _BottomNavItem(icon: Icons.home_outlined, label: '홈'),
              _BottomNavItem(icon: Icons.build_outlined, label: '리폼하기'),
              SizedBox(width: 60),
              _BottomNavItem(icon: Icons.article_outlined, label: '전문가연결'),
              _BottomNavItem(icon: Icons.person_outline, label: '마이페이지'),
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