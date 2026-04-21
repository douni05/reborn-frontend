import 'package:flutter/material.dart';

class ExpertDashboardScreen extends StatefulWidget {
  const ExpertDashboardScreen({super.key});

  @override
  State<ExpertDashboardScreen> createState() => _ExpertDashboardScreenState();
}

class _ExpertDashboardScreenState extends State<ExpertDashboardScreen> {
  String selectedTab = '신규요청';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EACD),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 22),
              decoration: const BoxDecoration(
                color: Color(0xFFD1EAC3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '전문가 대시보드',
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 30,
                      color: Color(0xFF1F402C),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '답변을 기다리는 의뢰와 진행 중인 작업을 확인하세요.',
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 14,
                      color: Color(0xFF33543C),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0xFFF8FAED),
              child: Row(
                children: [
                  _buildTab('신규요청'),
                  _buildTab('진행 중'),
                  _buildTab('완료'),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF8FAED),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 20),
                  child: _buildCurrentTabContent(),
                ),
              ),
            ),
            const _BottomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    final isSelected = selectedTab == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: 19,
                  color: const Color(0xFF1F402C),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 3,
                color: isSelected
                    ? const Color(0xFF1F402C)
                    : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    if (selectedTab == '신규요청') {
      return Column(
        children: [
          _requestCard(
            statusButtonText: '요청 수락',
            statusButtonFilled: true,
            showEstimateButton: true,
          ),
          const SizedBox(height: 12),
          _requestCard(
            statusButtonText: '요청 수락',
            statusButtonFilled: true,
            showEstimateButton: true,
          ),
          const SizedBox(height: 12),
          _requestCard(
            statusButtonText: '요청 수락',
            statusButtonFilled: true,
            showEstimateButton: true,
          ),
          const SizedBox(height: 12),
          _requestCard(
            statusButtonText: '요청 수락',
            statusButtonFilled: true,
            showEstimateButton: true,
          ),
        ],
      );
    }

    if (selectedTab == '진행 중') {
      return Column(
        children: [
          _requestCard(
            statusButtonText: '작업 중',
            statusButtonFilled: true,
            showEstimateButton: false,
          ),
          const SizedBox(height: 12),
          _requestCard(
            statusButtonText: '작업 중',
            statusButtonFilled: true,
            showEstimateButton: false,
          ),
          const SizedBox(height: 12),
          _requestCard(
            statusButtonText: '작업 중',
            statusButtonFilled: true,
            showEstimateButton: false,
          ),
        ],
      );
    }

    return Column(
      children: [
        _requestCard(
          statusButtonText: '작업 완료',
          statusButtonFilled: true,
          showEstimateButton: false,
          onStatusTap: () {
            _showCompleteConfirmModal(context);
          },
        ),
      ],
    );
  }

  Widget _requestCard({
    required String statusButtonText,
    required bool statusButtonFilled,
    required bool showEstimateButton,
    VoidCallback? onStatusTap,
  }) {
    return GestureDetector(
      onTap: () {
        _showRequestDetailModal(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF5C775E),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  '닉네임',
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 22,
                    color: Color(0xFF1F402C),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '2026-00-00 00:00',
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 12,
                    color: Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 15,
                  color: Color(0xFF1F402C),
                ),
                SizedBox(width: 4),
                Text(
                  '요청 사항',
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 14,
                    color: Color(0xFF1F402C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              '입지 않는 청바지를 크로스백으로 만들고 싶어요. AI가 추천한 디자인이 마음에 들어서 의뢰합니다.',
              style: TextStyle(
                fontFamily: 'RebornFont',
                fontSize: 12,
                color: Color(0xFF8A8A8A),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.play_circle_outline,
                  size: 15,
                  color: Color(0xFF87A676),
                ),
                const SizedBox(width: 4),
                const Text(
                  'AI 제작 가이드 보기',
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 13,
                    color: Color(0xFF87A676),
                  ),
                ),
                const Spacer(),
                if (showEstimateButton)
                  Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF5C775E),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '요청 거절',
                      style: TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 13,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                  ),
                if (showEstimateButton) const SizedBox(width: 8),
                GestureDetector(
                  onTap: onStatusTap,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: statusButtonFilled
                          ? const Color(0xFF87A676)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF87A676),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      statusButtonText,
                      style: TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 13,
                        color: statusButtonFilled
                            ? Colors.white
                            : const Color(0xFF1F402C),
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
  }

  void _showRequestDetailModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAED),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '요청 상세 정보 & 견적',
                        style: TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 28,
                          color: Color(0xFF1F402C),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 26,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  '요청 내용',
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 18,
                    color: Color(0xFF1F402C),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF5C775E),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    '입지 않는 청바지를 크로스백으로 만들고 싶어요.\nAI가 추천한 디자인이 마음에 들어서 의뢰합니다.',
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 16,
                      color: Color(0xFF8A8A8A),
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'AI 제작 가이드',
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 18,
                    color: Color(0xFF1F402C),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 164,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCFE4C6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF87A676),
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  '고객에게 전달 메시지',
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 18,
                    color: Color(0xFF1F402C),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF5C775E),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    '예상 카카오톡 메시지나 네이버톡 보내주세요.\n배송 정보와 가격, 소요시간은 카카오톡에서 확인 부탁드립니다.',
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 15,
                      color: Color(0xFF8A8A8A),
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF87A676),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      '요청 수락하기',
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
        );
      },
    );
  }

  void _showCompleteConfirmModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAED),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '작업 완료 확인',
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 28,
                    color: Color(0xFF1F402C),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  '이 요청을 \'완료\' 상태로 변경하시겠습니까?\n완료된 작업은 \'완료\' 탭에서 확인할 수 있습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 15,
                    color: Color(0xFF1F402C),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF87A676),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            '예',
                            style: TextStyle(
                              fontFamily: 'RebornFont',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF7F7F7),
                            foregroundColor: const Color(0xFF1F402C),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(
                                color: Color(0xFF5C775E),
                                width: 1,
                              ),
                            ),
                          ),
                          child: const Text(
                            '아니요.',
                            style: TextStyle(
                              fontFamily: 'RebornFont',
                              fontSize: 20,
                              color: Color(0xFF1F402C),
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

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

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
          Icon(icon, size: 24, color: const Color(0xFF1F402C)),
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