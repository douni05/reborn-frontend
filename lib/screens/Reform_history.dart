import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'camera_screen.dart';
import 'Reform_solution.dart';
import 'smart_disposal_solution.dart';

class ReformHistoryScreen extends StatelessWidget {
  const ReformHistoryScreen({super.key});

  static const _dummyItems = [
    {
      'title': '청바지 가방 만들기',
      'date': '2025.04.20',
      'status': '완료',
      'type': 'reform',
    },
    {
      'title': '티셔츠 쿠션 리폼',
      'date': '2025.03.15',
      'status': '진행중',
      'type': 'disposal',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EACD),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '리폼하기',
                          style: TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 30,
                            color: Color(0xFF1F402C),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CameraScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF87A676),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '+ 새로만들기',
                              style: TextStyle(
                                fontFamily: 'RebornFont',
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      '나의 리폼 히스토리를 확인하세요!',
                      style: TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 14,
                        color: Color(0xFF33543C),
                      ),
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
                      child: _dummyItems.isEmpty
                          ? const Center(
                              child: Text(
                                '아직 리폼 내역이 없어요!\n새로만들기를 눌러 시작해보세요.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'RebornFont',
                                  fontSize: 15,
                                  color: Color(0xFF6E7B6E),
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(14, 18, 14, 20),
                              itemCount: _dummyItems.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = _dummyItems[index];
                                return _ReformHistoryItem(
                                  title: item['title']!,
                                  date: item['date']!,
                                  status: item['status']!,
                                  type: item['type']!,
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const BottomNavBar(selectedIndex: 1),
          ],
        ),
      ),
    );
  }
}

class _ReformHistoryItem extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final String type;

  const _ReformHistoryItem({
    required this.title,
    required this.date,
    required this.status,
    required this.type,
  });

  void _onTap(BuildContext context) {
    final page = type == 'reform'
        ? const ReformSolutionScreen()
        : const SmartDisposalSolutionScreen();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDone = status == '완료';
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3E5C45), width: 1),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.checkroom_outlined,
              size: 36,
              color: Color(0xFF87A676),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 16,
                      color: Color(0xFF1F402C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 12,
                      color: Color(0xFF6E7B6E),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDone
                    ? const Color(0xFFD9EACD)
                    : const Color(0xFFFFE0B2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: 12,
                  color: isDone
                      ? const Color(0xFF1F402C)
                      : const Color(0xFF8D4E00),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
