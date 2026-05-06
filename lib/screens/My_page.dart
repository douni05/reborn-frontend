import 'package:flutter/material.dart';
import '../core/user_session.dart';
import '../widgets/bottom_nav_bar.dart';
import 'Reform_history.dart';
import 'Expert_register1.dart';
import 'Expert_dashboard.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String _nickname = UserSession.nickname.isNotEmpty ? UserSession.nickname : '닉네임';

  void _showNicknameEditDialog() {
    final controller = TextEditingController(text: _nickname);
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAED),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '닉네임 수정',
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 20,
                    color: Color(0xFF1F402C),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  style: const TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 15,
                    color: Color(0xFF1F402C),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          final newName = controller.text.trim();
                          if (newName.isNotEmpty) {
                            setState(() {
                              _nickname = newName;
                              UserSession.nickname = newName;
                            });
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3E5C45),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Center(
                            child: Text(
                              '저장',
                              style: TextStyle(
                                fontFamily: 'RebornFont',
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFB7B7B7)),
                          ),
                          child: const Center(
                            child: Text(
                              '취소',
                              style: TextStyle(
                                fontFamily: 'RebornFont',
                                fontSize: 14,
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

  void _showTitleChangeDialog() {
    final titles = ['새싹 지구 지킴이', '초록 지구 수호자', '에코 히어로', '지구 마스터'];
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAED),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '칭호 변경',
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 20,
                    color: Color(0xFF1F402C),
                  ),
                ),
                const SizedBox(height: 14),
                ...titles.map((title) => GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 14,
                            color: Color(0xFF1F402C),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
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
                        onTap: () => Navigator.pop(context),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Column(
                    children: [
                      _buildProfileCard(),
                      const SizedBox(height: 20),
                      _buildMenuButton(
                        text: '나의 리폼 히스토리',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReformHistoryScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMenuButton(
                        text: '닉네임 수정',
                        onTap: _showNicknameEditDialog,
                      ),
                      const SizedBox(height: 10),
                      _buildMenuButton(
                        text: '칭호 변경',
                        onTap: _showTitleChangeDialog,
                      ),
                      const SizedBox(height: 22),
                      _buildMenuButton(
                        text: '전문가 등록',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ExpertRegister1Screen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMenuButton(
                        text: '전문가 대시보드',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ExpertDashboardScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      _buildWithdrawButton(),
                    ],
                  ),
                ),
              ),
            ),
            const BottomNavBar(selectedIndex: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _nickname,
            style: const TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 26,
              color: Color(0xFF1F402C),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.star, size: 16, color: Colors.black),
              SizedBox(width: 6),
              Text(
                '새싹 지구 지킴이',
                style: TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: 15,
                  color: Color(0xFF1F402C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level 1',
                style: TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: 11,
                  color: Color(0xFF1F402C),
                ),
              ),
              Text(
                '1/200',
                style: TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: 11,
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
              height: 22,
              color: const Color(0xFFE6E8E9),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 18,
                  height: 22,
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

  Widget _buildMenuButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '• $text',
          style: const TextStyle(
            fontFamily: 'RebornFont',
            fontSize: 16,
            color: Color(0xFF1F402C),
          ),
        ),
      ),
    );
  }

  Widget _buildWithdrawButton() {
    return GestureDetector(
      onTap: _showWithdrawDialog,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '• 탈퇴',
          style: TextStyle(
            fontFamily: 'RebornFont',
            fontSize: 16,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}