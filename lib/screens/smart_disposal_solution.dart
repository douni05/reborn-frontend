import 'package:flutter/material.dart';
import '../models/analysis_model.dart';
import '../services/action_service.dart';
import '../widgets/app_shell.dart';

class SmartDisposalSolutionScreen extends StatefulWidget {
  final AnalysisResult result;
  final bool fromCamera;

  const SmartDisposalSolutionScreen({
    super.key,
    required this.result,
    this.fromCamera = false,
  });

  @override
  State<SmartDisposalSolutionScreen> createState() => _SmartDisposalSolutionScreenState();
}

class _SmartDisposalSolutionScreenState extends State<SmartDisposalSolutionScreen> {
  final _actionService = ActionService();
  bool _isCompleting = false;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.result.isDisposalCompleted;
  }

  List<String> _parseDisposalSteps(String? method) {
    if (method == null || method.trim().isEmpty) return [];
    return method
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Future<void> _onDisposalComplete() async {
    if (_isCompleting || _isCompleted) return;
    setState(() => _isCompleting = true);
    try {
      final result = await _actionService.completeDisposal(
        analysisId: widget.result.analysisId,
      );
      final earned = result['earnedXp'] ?? 50;
      if (!mounted) return;
      setState(() {
        _isCompleted = true;
        _isCompleting = false;
      });
      _showXpDialog(earned);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCompleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', ''),
              style: const TextStyle(fontFamily: 'RebornFont')),
          backgroundColor: const Color(0xFF5C3D2E),
        ),
      );
    }
  }

  void _showXpDialog(int earned) {
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
              const Text('✅', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              const Text('배출 완료!',
                  style: TextStyle(fontFamily: 'RebornFont', fontSize: 22,
                      color: Color(0xFF1F402C))),
              const SizedBox(height: 8),
              Text('+$earned XP 획득',
                  style: const TextStyle(fontFamily: 'RebornFont', fontSize: 18,
                      color: Color(0xFF5C8A76), fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('환경을 위한 올바른 실천이에요!',
                  style: TextStyle(fontFamily: 'RebornFont', fontSize: 13,
                      color: Color(0xFF6E8B64))),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // dialog만 닫기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6E8B64),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('확인',
                      style: TextStyle(fontFamily: 'RebornFont', fontSize: 16)),
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
    final steps = _parseDisposalSteps(widget.result.disposalMethod);
    final icon = widget.result.disposalIcon ?? '🗑️';

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
                        const Text('스마트 배출 솔루션',
                            style: TextStyle(fontFamily: 'RebornFont',
                                fontSize: 24, color: Color(0xFF1F402C))),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 54, top: 4),
                    child: Text(
                      'AI가 분석한 올바른 배출 방법이에요!',
                      style: TextStyle(fontFamily: 'RebornFont', fontSize: 13,
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
                        padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
                        child: Column(
                          children: [
                            _sectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(icon, style: const TextStyle(fontSize: 28)),
                                      const SizedBox(width: 10),
                                      const Text('분석 결과',
                                          style: TextStyle(fontFamily: 'RebornFont',
                                              fontSize: 22, color: Color(0xFF1F402C))),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _row('재질', widget.result.materialType),
                                  if (widget.result.conditionGrade != null) ...[
                                    const SizedBox(height: 8),
                                    _row('상태 등급', _conditionLabel(widget.result.conditionGrade!)),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text('업사이클링 여부 : ',
                                          style: TextStyle(fontFamily: 'RebornFont',
                                              fontSize: 15, color: Color(0xFF6E8B64))),
                                      Builder(builder: (context) {
                                        final reformable = widget.result.isReformable == true;
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: reformable
                                                ? const Color(0xFFDFF0D8)
                                                : const Color(0xFFFFE0E0),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            reformable ? '가능 👍' : '어려워요 😢',
                                            style: TextStyle(
                                                fontFamily: 'RebornFont',
                                                fontSize: 13,
                                                color: reformable
                                                    ? const Color(0xFF3E5C45)
                                                    : const Color(0xFFB03030)),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            _sectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('⚠️ 올바른 배출 방법',
                                      style: TextStyle(fontFamily: 'RebornFont',
                                          fontSize: 18, color: Color(0xFF1F402C))),
                                  const SizedBox(height: 12),
                                  if (steps.isEmpty)
                                    const Text(
                                      '해당 재질의 분리배출 방법을 확인 후 배출해주세요.',
                                      style: TextStyle(fontFamily: 'RebornFont',
                                          fontSize: 14, color: Color(0xFF1F402C), height: 1.5),
                                    )
                                  else
                                    ...steps.asMap().entries.map((e) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: e.key < steps.length - 1 ? 10 : 0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF5C8A76),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text('${e.key + 1}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'RebornFont',
                                                        fontSize: 12)),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 3),
                                                child: Text(e.value,
                                                    style: const TextStyle(
                                                        fontFamily: 'RebornFont',
                                                        fontSize: 14,
                                                        color: Color(0xFF1F402C),
                                                        height: 1.45)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _isCompleted ? null : _onDisposalComplete,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isCompleted
                                      ? const Color(0xFFB0C4B1)
                                      : const Color(0xFF87A676),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: BorderSide(
                                        color: _isCompleted
                                            ? const Color(0xFF9BB09C)
                                            : const Color(0xFF5C8A55),
                                        width: 1),
                                  ),
                                ),
                                child: _isCompleting
                                    ? const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20, height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2, color: Colors.white),
                                          ),
                                          SizedBox(width: 10),
                                          Text('처리 중...',
                                              style: TextStyle(
                                                  fontFamily: 'RebornFont',
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                        ],
                                      )
                                    : Text(
                                        _isCompleted ? '✅ 배출 완료됨' : '🗑️ 배출 완료 확인 (+50 XP)',
                                        style: TextStyle(
                                            fontFamily: 'RebornFont',
                                            fontSize: 16,
                                            color: _isCompleted
                                                ? const Color(0xFF1F402C)
                                                : Colors.white)),
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

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3E5C45), width: 1),
      ),
      child: child,
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
}
