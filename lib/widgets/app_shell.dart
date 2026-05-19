import 'package:flutter/material.dart';
import '../screens/Main_page.dart';
import '../screens/Reform_history.dart';
import '../screens/Expert_connect.dart';
import '../screens/My_page.dart';
import 'bottom_nav_bar.dart';

class AppShell extends StatefulWidget {
  final int initialIndex;
  const AppShell({super.key, this.initialIndex = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          MainPageScreen(),
          ReformHistoryScreen(),
          SizedBox.shrink(), // 인덱스 2: 가운데 버튼 (BottomNavBar에서 직접 처리)
          ExpertConnectScreen(),
          MyPageScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChanged: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
