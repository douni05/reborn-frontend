import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/analysis_model.dart';
import '../services/action_service.dart';
import '../widgets/app_shell.dart';
import 'Expert_connect.dart';

class ReformSolutionScreen extends StatefulWidget {
  final AnalysisResult result;
  final bool fromCamera;

  const ReformSolutionScreen({
    super.key,
    required this.result,
    this.fromCamera = false,
  });

  @override
  State<ReformSolutionScreen> createState() => _ReformSolutionScreenState();
}

class _ReformSolutionScreenState extends State<ReformSolutionScreen> {
  final _actionService = ActionService();
  final _picker = ImagePicker();

  bool _isVerifying = false;
  late bool _isVerified;

  @override
  void initState() {
    super.initState();
    _isVerified = widget.result.isReformVerified;
  }

  List<String> _parseSteps(String? plan) {
    if (plan == null || plan.trim().isEmpty) return [];
    return plan
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Future<void> _onReformComplete() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null || !mounted) return;

    setState(() => _isVerifying = true);
    try {
      final result = await _actionService.verifyReform(
        imagePath: picked.path,
        label: widget.result.label,
        analysisId: widget.result.analysisId,
      );
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
        if (result['isVerified'] == true) _isVerified = true;
      });
      _showVerifyResultDialog(
        isVerified: result['isVerified'] == true,
        message: result['message'] ?? '',
        earnedXp: result['earnedXp'] ?? 0,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', ''),
              style: const TextStyle(fontFamily: 'RebornFont')),
          backgroundColor: const Color(0xFF5C3D2E),
        ),
      );
    }
  }

  void _showVerifyResultDialog({
    required bool isVerified,
    required String message,
    required int earnedXp,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAED),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isVerified ? '🎉' : '📸',
                  style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                isVerified ? '리폼 완료 인증 성공!' : '인증 실패',
                style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 22,
                    color: isVerified
                        ? const Color(0xFF1F402C)
                        : const Color(0xFF5C3D2E)),
              ),
              if (isVerified) ...[
                const SizedBox(height: 8),
                Text('+$earnedXp XP 획득',
                    style: const TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 18,
                        color: Color(0xFF5C8A76),
                        fontWeight: FontWeight.bold)),
              ],
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 13,
                      color: Color(0xFF6E8B64),
                      height: 1.5)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // dialog만 닫기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isVerified
                        ? const Color(0xFF5C8A76)
                        : const Color(0xFF87A676),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isVerified ? '확인' : '다시 시도',
                      style: const TextStyle(
                          fontFamily: 'RebornFont', fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = _parseSteps(widget.result.reformPlan);

    return Scaffold(
      backgroundColor: const Color(0xFFD9EACD),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Color(0xFF1F402C), size: 24),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        const Text('리폼 솔루션',
                            style: TextStyle(fontFamily: 'RebornFont',
                                fontSize: 28, color: Color(0xFF1F402C))),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 54, top: 4),
                    child: Text(
                      'AI가 분석한 맞춤 리폼 솔루션이에요!',
                      style: TextStyle(fontFamily: 'RebornFont', fontSize: 14,
                          color: Color(0xFF33543C)),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                        padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
                        child: Column(
                          children: [
                            // 1. 분석 결과 카드
                            _infoCard(
                              title: '분석 결과',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  _row('재질', widget.result.materialType),
                                  if (widget.result.conditionGrade != null) ...[
                                    const SizedBox(height: 8),
                                    _row('상태 등급',
                                        _conditionLabel(widget.result.conditionGrade!)),
                                  ],
                                  const SizedBox(height: 8),
                                  _row('업사이클링 여부', '가능 👍'),
                                  if (widget.result.difficulty != null) ...[
                                    const SizedBox(height: 8),
                                    _row('난이도',
                                        _difficultyLabel(widget.result.difficulty!)),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 2. 리폼 아이디어 카드
                            _infoCard(
                              title: widget.result.reformTitle ?? '리폼 아이디어',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  if (widget.result.materials != null)
                                    _row('필요한 재료', widget.result.materials!),
                                  if (widget.result.estimatedTime != null) ...[
                                    const SizedBox(height: 8),
                                    _row('예상 소요 시간', widget.result.estimatedTime!),
                                  ],
                                  if (widget.result.estimatedCost != null) ...[
                                    const SizedBox(height: 8),
                                    _row('예상 비용', widget.result.estimatedCost!),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 3. 단계별 가이드 카드
                            if (steps.isNotEmpty) _guideCard(steps),
                            const SizedBox(height: 20),

                            // 리폼 완료 인증 버튼
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _isVerified ? null : _onReformComplete,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isVerified
                                      ? const Color(0xFFB0C4B1)
                                      : const Color(0xFF87A676),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: BorderSide(
                                        color: _isVerified
                                            ? const Color(0xFF9BB09C)
                                            : const Color(0xFF5C8A55),
                                        width: 1),
                                  ),
                                ),
                                child: _isVerifying
                                    ? const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20, height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2, color: Colors.white),
                                          ),
                                          SizedBox(width: 10),
                                          Text('Gemini가 검증 중...',
                                              style: TextStyle(
                                                  fontFamily: 'RebornFont',
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                        ],
                                      )
                                    : Text(
                                        _isVerified
                                            ? '🏆 리폼 인증 완료'
                                            : '📸 리폼 완료 인증하기 (+100 XP)',
                                        style: const TextStyle(
                                            fontFamily: 'RebornFont',
                                            fontSize: 16,
                                            color: Colors.white)),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // 전문가에게 도움받기 버튼
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ExpertConnectScreen()),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3E5C45),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(
                                        color: Color(0xFF2C4233), width: 1),
                                  ),
                                ),
                                child: const Text('🤝 전문가에게 도움받기',
                                    style: TextStyle(fontFamily: 'RebornFont',
                                        fontSize: 18, color: Colors.white)),
                              ),
                            ),
                            if (widget.fromCamera) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const AppShell()),
                                      (route) => false,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF6E8B64),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    '다음에 하기',
                                    style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 16,
                                        color: Color(0xFF6E8B64)),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).padding.bottom,
              color: const Color(0xFFF8FAED),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3E5C45), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontFamily: 'RebornFont', fontSize: 20,
                  color: Color(0xFF1F402C))),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _guideCard(List<String> steps) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3E5C45), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('단계별 가이드',
              style: TextStyle(fontFamily: 'RebornFont', fontSize: 20,
                  color: Color(0xFF1F402C))),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((e) {
            final idx = e.key;
            final step = e.value;
            final cleaned = step
                .replaceFirst(
                    RegExp(r'^step\s*\d+\s*:\s*', caseSensitive: false), '')
                .trim();
            return Padding(
              padding: EdgeInsets.only(bottom: idx < steps.length - 1 ? 10 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: Color(0xFF87A676),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('${idx + 1}',
                          style: const TextStyle(color: Colors.white,
                              fontFamily: 'RebornFont', fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(cleaned,
                          style: const TextStyle(fontFamily: 'RebornFont',
                              fontSize: 14, color: Color(0xFF1F402C), height: 1.4)),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontFamily: 'RebornFont', fontSize: 15,
            color: Color(0xFF1F402C)),
        children: [
          TextSpan(text: '$label : ',
              style: const TextStyle(color: Color(0xFF6E8B64))),
          TextSpan(text: value),
        ],
      ),
    );
  }

  String _conditionLabel(String grade) {
    switch (grade.toUpperCase()) {
      case 'A': return 'A등급 (상태 양호)';
      case 'B': return 'B등급 (보통)';
      case 'C': return 'C등급 (상태 불량)';
      default:  return grade;
    }
  }

  String _difficultyLabel(String d) {
    switch (d.toLowerCase()) {
      case 'easy':   return '쉬움 ⭐';
      case 'normal': return '보통 ⭐⭐';
      case 'hard':   return '어려움 ⭐⭐⭐';
      default:       return d;
    }
  }
}
