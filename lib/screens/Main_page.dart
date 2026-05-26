import 'package:flutter/material.dart';
import '../core/network/api_client.dart';
import '../core/storage/auth_storage.dart';
import '../services/member_service.dart';
import '../core/constants/level_constants.dart';


void _showGamificationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFFF8FAED),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (_, controller) => SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '레벨 & 보상 안내',
              style: TextStyle(
                fontFamily: 'RebornFont',
                fontSize: 22,
                color: Color(0xFF1F402C),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'XP 획득 방법',
              style: TextStyle(
                fontFamily: 'RebornFont',
                fontSize: 15,
                color: Color(0xFF1F402C),
              ),
            ),
            const SizedBox(height: 10),
            _xpRow('AI 분석', '10 XP', sub: '첫 분석은 50 XP'),
            _xpRow('리폼 등록', '100 XP'),
            _xpRow('폐기물 처리', '50 XP'),
            _xpRow('전문가 매칭', '150 XP'),
            const SizedBox(height: 24),
            const Text(
              '칭호 획득 조건',
              style: TextStyle(
                fontFamily: 'RebornFont',
                fontSize: 15,
                color: Color(0xFF1F402C),
              ),
            ),
            const SizedBox(height: 10),
            _titleRow('🌱', 'Lv.1', '새싹 지구 지킴이'),
            _titleRow('♻️', 'Lv.6', '주니어 리포머'),
            _titleRow('🌿', 'Lv.16', '프로 환경러'),
            _titleRow('🌍', 'Lv.31', '에코 마스터'),
            _titleRow('🏆', 'Lv.50', '지구 수호자'),
            const SizedBox(height: 16),
            const Text(
              '특별 칭호',
              style: TextStyle(
                fontFamily: 'RebornFont',
                fontSize: 15,
                color: Color(0xFF1F402C),
              ),
            ),
            const SizedBox(height: 10),
            _titleRow('⚒️', '리폼 5회', '맥가이버'),
            _titleRow('🏆', '리폼 10회', '패션 아이콘'),
            _titleRow('🤝', '전문가 매칭 3회', '공방 단골손님'),
            _titleRow('📍', '폐기물 처리 5회', '분리배출의 신'),
          ],
        ),
      ),
    ),
  );
}

Widget _xpRow(String action, String xp, {String? sub}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              action,
              style: const TextStyle(
                fontFamily: 'RebornFont',
                fontSize: 14,
                color: Color(0xFF1F402C),
              ),
            ),
            if (sub != null)
              Text(
                sub,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8A8A8A),
                ),
              ),
          ],
        ),
        Text(
          xp,
          style: const TextStyle(
            fontFamily: 'RebornFont',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF173C2A),
          ),
        ),
      ],
    ),
  );
}

Widget _titleRow(String icon, String condition, String title) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 14,
              color: Color(0xFF1F402C),
            ),
          ),
        ),
        Text(
          condition,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8A8A8A),
          ),
        ),
      ],
    ),
  );
}

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({super.key});

  @override
  State<MainPageScreen> createState() => MainPageScreenState();
}

class MainPageScreenState extends State<MainPageScreen> {
  String? _tip;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadTip();
  }

  void reload() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await MemberService().getMyProfile();
      final storage = AuthStorage();
      storage.nickname = profile.nickname;
      storage.totalXp = profile.totalXp;
      storage.currentLevel = profile.currentLevel;
      await storage.save();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('프로필 로드 실패: $e');
    }
  }

  Future<void> _loadTip() async {
    try {
      final dio = ApiClient().dio;
      final response = await dio.get('/api/v1/tips/today');
      if (!mounted) return;
      setState(() => _tip = response.data['tip'] as String?);
    } catch (_) {
      if (mounted) setState(() => _tip = '오늘도 환경을 위한 작은 실천을 해보세요 🌱');
    }
  }

  String _getCharacterImage(int level) {
    if (level >= 50) return 'assets/images/ch_5.png';
    if (level >= 31) return 'assets/images/ch_4.png';
    if (level >= 16) return 'assets/images/ch_3.png';
    if (level >= 6)  return 'assets/images/ch_2.png';
    return 'assets/images/ch_1.png';
  }

  @override
  Widget build(BuildContext context) {
    final storage = AuthStorage();
    final nickname = storage.nickname ?? '';
    final totalXp = storage.totalXp;
    final currentLevel = storage.currentLevel;

    final idx = (currentLevel - 1).clamp(0, levelThresholds.length - 2);
    final xpInLevel = totalXp - levelThresholds[idx];
    final xpNeeded = levelThresholds[idx + 1] - levelThresholds[idx];
    final xpProgress = (xpInLevel / xpNeeded).clamp(0.0, 1.0);
    final titleName = getTitleForLevel(currentLevel);

    return Scaffold(
      backgroundColor: const Color(0xFFD9EACD),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: 160,
                height: 160,
                child: Image.asset(
                  _getCharacterImage(currentLevel),
                  fit: BoxFit.contain,
                ),
              ),
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
                                Text(
                                  getTitleEmoji(titleName),
                                  style: const TextStyle(fontSize: 16),
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
                            GestureDetector(
                              onTap: () => _showGamificationSheet(context),
                              child: Column(
                                children: [
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
                                      Row(
                                        children: [
                                          Text(
                                            '$xpInLevel / $xpNeeded XP',
                                            style: const TextStyle(
                                              fontFamily: 'RebornFont',
                                              fontSize: 12,
                                              color: Color(0xFF223B2B),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.info_outline,
                                            size: 14,
                                            color: Color(0xFF8A8A8A),
                                          ),
                                        ],
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
                                                topRight: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '오늘의 실천 Tip!',
                              style: TextStyle(
                                fontFamily: 'RebornFont',
                                fontSize: 13,
                                color: Color(0xFF223B2B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _tip == null
                                ? const SizedBox(
                                    height: 20,
                                    child: Center(
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF173C2A),
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    _tip!,
                                    style: const TextStyle(
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
          ],
        ),
      ),
    );
  }
}