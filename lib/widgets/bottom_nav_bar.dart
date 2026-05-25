import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/Main_page.dart';
import '../screens/Reform_history.dart';
import '../screens/Expert_connect.dart';
import '../screens/My_page.dart';
import '../screens/AI_camera_result.dart';

/// 앱 공통 하단 네비게이션 바
/// [selectedIndex] 0=홈, 1=리폼하기, 2=중앙버튼, 3=전문가연결, 4=마이페이지
/// [onTabChanged] AppShell에서 IndexedStack 탭 전환 시 사용
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabChanged;

  static const _mlkitChannel = MethodChannel('com.jimmy.reborn.reborn_fe/mlkit');

  const BottomNavBar({super.key, this.selectedIndex = 0, this.onTabChanged});

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;

    if (onTabChanged != null) {
      onTabChanged!(index);
      return;
    }

    // 서브페이지에서 사용할 때 (AppShell 밖) — 기존 방식 유지
    Widget page;
    switch (index) {
      case 0:
        page = const MainPageScreen();
        break;
      case 1:
        page = const ReformHistoryScreen();
        break;
      case 3:
        page = const ExpertConnectScreen();
        break;
      case 4:
        page = const MyPageScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 78,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 78,
              color: const Color(0xFFD9EACD),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    label: '홈',
                    selected: selectedIndex == 0,
                    onTap: () => _onItemTapped(context, 0),
                  ),
                  _NavItem(
                    icon: Icons.build_outlined,
                    label: '리폼하기',
                    selected: selectedIndex == 1,
                    onTap: () => _onItemTapped(context, 1),
                  ),
                  const SizedBox(width: 60),
                  _NavItem(
                    icon: Icons.article_outlined,
                    label: '전문가연결',
                    selected: selectedIndex == 3,
                    onTap: () => _onItemTapped(context, 3),
                  ),
                  _NavItem(
                    icon: Icons.person_outline,
                    label: '마이페이지',
                    selected: selectedIndex == 4,
                    onTap: () => _onItemTapped(context, 4),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -12,
              child: GestureDetector(
                onTap: () async {
                  try {
                    final result = await _mlkitChannel.invokeMethod<Map>('launchMLKit');
                    if (result == null) return;
                    final label = result['label'] as String? ?? '';
                    final confidence = (result['confidence'] as num?)?.toDouble() ?? 0.0;
                    final imagePath = result['imagePath'] as String? ?? '';
                    if (label.isEmpty) return;
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AICameraResultScreen(
                            detectedLabel: label,
                            confidence: confidence,
                            imagePath: imagePath,
                          ),
                        ),
                      );
                    }
                  } on PlatformException catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('카메라 실행 실패: ${e.message ?? e.code}')),
                      );
                    }
                  }
                },
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA8C88E),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD9EACD),
                      width: 5,
                    ),
                  ),
                  child: const Icon(
                    Icons.recycling,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? const Color(0xFF1F402C)
        : const Color(0xFF1F402C).withValues(alpha: 0.45);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'RebornFont',
                fontSize: 11,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
