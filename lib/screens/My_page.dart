import 'package:flutter/material.dart';
import '../core/storage/auth_storage.dart';
import '../core/user_session.dart';
import '../models/member_model.dart';
import '../services/member_service.dart';
import '../services/expert_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../core/constants/level_constants.dart';
import 'Login.dart';
import 'Reform_history.dart';
import 'Expert_register1.dart';
import 'Expert_edit.dart';
import 'Expert_dashboard.dart';
import 'My_requests.dart';


class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final MemberService _memberService = MemberService();
  final ExpertService _expertService = ExpertService();
  MemberProfile? _profile;
  bool _isLoading = true;
  late String _nickname;
  String? _selectedTitle;

  bool _isExpert = false;
  Map<String, dynamic>? _expertInfo;
  bool _expertLoading = true;

  @override
  void initState() {
    super.initState();
    _nickname = UserSession.nickname.isNotEmpty ? UserSession.nickname : '닉네임';
    _loadProfile();
    _loadExpertInfo();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _memberService.getMyProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _nickname = profile.nickname;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint('[MyPage] 프로필 로드 실패: $e');
    }
  }

  Future<void> _loadExpertInfo() async {
    try {
      final expert = await _expertService.isExpert();
      if (expert) {
        final info = await _expertService.getMyExpert();
        if (!mounted) return;
        setState(() {
          _isExpert = true;
          _expertInfo = info;
          _expertLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _isExpert = false;
          _expertInfo = null;
          _expertLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _expertLoading = false);
      debugPrint('[MyPage] 전문가 정보 로드 실패: $e');
    }
  }

  double _xpProgress() {
    return calcXpProgress(_profile?.totalXp ?? 0, _profile?.currentLevel ?? 1);
  }

  String _xpLabel() {
    return calcXpLabel(_profile?.totalXp ?? 0, _profile?.currentLevel ?? 1);
  }

  void _showNicknameEditDialog() {
    final controller = TextEditingController(text: _nickname);

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) {
        bool isSaving = false;
        String? errorMessage;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) => Dialog(
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
                    onChanged: (_) {
                      if (errorMessage != null) {
                        setDialogState(() => errorMessage = null);
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: errorMessage != null ? Colors.red : Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: errorMessage != null ? Colors.red : Colors.transparent,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      errorText: errorMessage,
                      errorStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: isSaving
                              ? null
                              : () async {
                                  final newName = controller.text.trim();
                                  if (newName.length < 2 || newName.length > 8) {
                                    setDialogState(() => errorMessage = '닉네임은 2자 이상 8자 이하로 입력해주세요');
                                    return;
                                  }
                                  setDialogState(() => isSaving = true);
                                  try {
                                    await _memberService.updateNickname(newName);
                                    AuthStorage().nickname = newName;
                                    UserSession.nickname = newName;
                                    if (!mounted) return;
                                    setState(() => _nickname = newName);
                                    Navigator.pop(dialogContext);
                                  } catch (e) {
                                    setDialogState(() {
                                      isSaving = false;
                                      errorMessage = e.toString().replaceFirst('Exception: ', '');
                                    });
                                  }
                                },
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3E5C45),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: isSaving
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
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
                          onTap: () => Navigator.pop(dialogContext),
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
          ),
        );
      },
    );
  }

  void _showTitleChangeDialog() {
    final level = _profile?.currentLevel ?? 1;
    final reformCount = _profile?.totalReformCount ?? 0;
    final disposalCount = _profile?.totalDisposalCount ?? 0;
    final unlockedTitles = _profile?.unlockedTitles ?? [];

    final allTitles = [
      {'icon': '🌱', 'name': '새싹 지구 지킴이', 'condition': 'Lv.1',     'unlocked': true},
      {'icon': '♻️', 'name': '주니어 리포머',    'condition': 'Lv.6',     'unlocked': level >= 6},
      {'icon': '🌿', 'name': '프로 환경러',       'condition': 'Lv.16',    'unlocked': level >= 16},
      {'icon': '🌍', 'name': '에코 마스터',       'condition': 'Lv.31',    'unlocked': level >= 31},
      {'icon': '🏆', 'name': '지구 수호자',       'condition': 'Lv.50',    'unlocked': level >= 50},
      {'icon': '⚒️', 'name': '맥가이버',          'condition': '리폼 5회', 'unlocked': reformCount >= 5},
      {'icon': '🏆', 'name': '패션 아이콘',       'condition': '리폼 10회','unlocked': reformCount >= 10},
      {'icon': '🤝', 'name': '공방 단골손님',     'condition': '전문가 연결 3회', 'unlocked': unlockedTitles.contains('공방 단골손님')},
      {'icon': '📍', 'name': '분리배출의 신',     'condition': '처리 5회', 'unlocked': disposalCount >= 5},
    ];

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
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: allTitles.map((t) {
                        final unlocked = t['unlocked'] as bool;
                        final name = t['name'] as String;
                        final icon = t['icon'] as String;
                        final condition = t['condition'] as String;
                        final isCurrent = (_selectedTitle ?? _profile?.titleName) == name;

                        return GestureDetector(
                          onTap: unlocked
                              ? () {
                                  setState(() => _selectedTitle = name);
                                  Navigator.pop(context);
                                }
                              : null,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? const Color(0xFFDFF0D8)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: isCurrent
                                  ? Border.all(color: const Color(0xFF3E5C45))
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  unlocked ? icon : '🔒',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontFamily: 'RebornFont',
                                      fontSize: 14,
                                      color: unlocked
                                          ? const Color(0xFF1F402C)
                                          : const Color(0xFFAAAAAA),
                                    ),
                                  ),
                                ),
                                Text(
                                  unlocked ? (isCurrent ? '착용 중' : '') : condition,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isCurrent
                                        ? const Color(0xFF3E5C45)
                                        : const Color(0xFF8A8A8A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
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

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) {
        bool isWithdrawing = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) => Dialog(
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
                        child: GestureDetector(
                          onTap: isWithdrawing
                              ? null
                              : () async {
                                  setDialogState(() => isWithdrawing = true);
                                  try {
                                    await _memberService.withdraw();
                                    await AuthStorage().clear();
                                    UserSession.init(0, '');
                                    if (!mounted) return;
                                    Navigator.pop(dialogContext);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  } catch (e) {
                                    setDialogState(() => isWithdrawing = false);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                                    );
                                  }
                                },
                          child: Container(
                            height: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE57272),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: isWithdrawing
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
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
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(dialogContext),
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
                        text: '나의 요청 현황',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MyRequestsScreen()),
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
                      _buildExpertSection(),
                      const SizedBox(height: 22),
                      _buildLogoutButton(),
                      const SizedBox(height: 10),
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
    final level = _profile?.currentLevel ?? 1;
    final title = _selectedTitle ?? _profile?.titleName ?? '새싹 지구 지킴이';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: _isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: CircularProgressIndicator(
                  color: Color(0xFF173C2A),
                  strokeWidth: 2,
                ),
              ),
            )
          : Column(
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
                Row(
                  children: [
                    Text(
                      getTitleEmoji(title),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 15,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level $level',
                      style: const TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 11,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                    Text(
                      _xpLabel(),
                      style: const TextStyle(
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
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _xpProgress(),
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
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFE6E8E9), height: 1),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('♻️', '리폼', _profile?.totalReformCount ?? 0),
                    _buildStatDivider(),
                    _buildStatItem('🗑️', '분리배출', _profile?.totalDisposalCount ?? 0),
                    _buildStatDivider(),
                    _buildStatItem('🤝', '전문가 연결', _profile?.expertConnectionCount ?? 0),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildExpertSection() {
    if (_expertLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: CircularProgressIndicator(
            color: Color(0xFF87A676),
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (!_isExpert) {
      // 전문가 아닌 경우 → 등록 버튼
      return _buildMenuButton(
        text: '전문가 등록',
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ExpertRegister1Screen()),
          );
          _loadExpertInfo();
        },
      );
    }

    // 전문가인 경우 → 정보 카드
    final info = _expertInfo!;
    final imageUrl = info['imageUrl'] as String?;
    final shopName = info['shopName'] ?? '';
    final category = info['category'] ?? '';
    final address = info['address'] ?? '';
    final phone = info['phone'] ?? '';
    final introduction = info['introduction'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            '🏪 내 전문가 정보',
            style: TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 16,
              color: Color(0xFF1F402C),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF87A676), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지
              if (imageUrl != null && imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14)),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9EACD),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: const Icon(Icons.storefront_outlined,
                      size: 36, color: Color(0xFF87A676)),
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shopName,
                      style: const TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 20,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (category.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.checkroom_outlined,
                              size: 15, color: Color(0xFF6E7B6E)),
                          const SizedBox(width: 5),
                          Text(category,
                              style: const TextStyle(
                                  fontFamily: 'RebornFont',
                                  fontSize: 13,
                                  color: Color(0xFF6E7B6E))),
                        ],
                      ),
                    if (address.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 15, color: Color(0xFF6E7B6E)),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(address,
                                style: const TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 13,
                                    color: Color(0xFF6E7B6E)),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                    if (phone.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined,
                              size: 15, color: Color(0xFF6E7B6E)),
                          const SizedBox(width: 5),
                          Text(phone,
                              style: const TextStyle(
                                  fontFamily: 'RebornFont',
                                  fontSize: 13,
                                  color: Color(0xFF6E7B6E))),
                        ],
                      ),
                    ],
                    if (introduction.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        introduction,
                        style: const TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 12,
                          color: Color(0xFF888888),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final updated = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ExpertEditScreen(expert: info),
                                ),
                              );
                              if (updated == true) {
                                setState(() => _expertLoading = true);
                                _loadExpertInfo();
                              }
                            },
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF87A676),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  '정보 수정',
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
                            onTap: _showExpertDeleteDialog,
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.red.shade300, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  '등록 취소',
                                  style: TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 14,
                                    color: Colors.red.shade400,
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
            ],
          ),
        ),
        const SizedBox(height: 10),
        _buildMenuButton(
          text: '전문가 대시보드',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ExpertDashboardScreen()),
          ),
        ),
      ],
    );
  }

  void _showExpertDeleteDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) {
        bool isDeleting = false;
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAED),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '전문가 등록을 취소할까요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 20,
                      color: Color(0xFF1F402C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '전문가 연결 목록에서 삭제돼요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 13,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: isDeleting
                              ? null
                              : () async {
                                  setDialogState(() => isDeleting = true);
                                  try {
                                    await _expertService.deleteExpert();
                                    if (!mounted) return;
                                    Navigator.pop(dialogContext);
                                    setState(() {
                                      _isExpert = false;
                                      _expertInfo = null;
                                    });
                                  } catch (e) {
                                    setDialogState(() => isDeleting = false);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e
                                            .toString()
                                            .replaceFirst('Exception: ', '')),
                                      ),
                                    );
                                  }
                                },
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: isDeleting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white))
                                  : const Text(
                                      '등록 취소',
                                      style: TextStyle(
                                          fontFamily: 'RebornFont',
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(dialogContext),
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(18),
                              border:
                                  Border.all(color: const Color(0xFFB7B7B7)),
                            ),
                            child: const Center(
                              child: Text(
                                '취소',
                                style: TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 14,
                                    color: Color(0xFF1F402C)),
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
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String emoji, String label, int count) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            '$count회',
            style: const TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 17,
              color: Color(0xFF1F402C),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 11,
              color: Color(0xFF8A8A8A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0xFFE6E8E9),
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

  Future<void> _logout() async {
    await AuthStorage().clear();
    UserSession.init(0, '');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) => Dialog(
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
                '로그아웃 할까요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: 22,
                  color: Color(0xFF1F402C),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(dialogContext);
                        _logout();
                      },
                      child: Container(
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3E5C45),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            '로그아웃',
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        height: 34,
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
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _showLogoutDialog,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '• 로그아웃',
          style: TextStyle(
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