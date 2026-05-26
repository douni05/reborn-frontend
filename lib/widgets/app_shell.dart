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
  final _mainPageKey = GlobalKey<MainPageScreenState>();
  final _reformHistoryKey = GlobalKey<ReformHistoryScreenState>();
  final _myPageKey = GlobalKey<MyPageScreenState>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) {
      _mainPageKey.currentState?.reload();
    }
    if (index == 1) {
      _reformHistoryKey.currentState?.reload();
    }
    if (index == 4) {
      _myPageKey.currentState?.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          MainPageScreen(key: _mainPageKey),
          ReformHistoryScreen(key: _reformHistoryKey),
          const SizedBox.shrink(), // 인덱스 2: 가운데 버튼 (BottomNavBar에서 직접 처리)
          const ExpertConnectScreen(),
          MyPageScreen(key: _myPageKey),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChanged: _onTabChanged,
      ),
    );
  }
}
