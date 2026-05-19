import 'package:flutter/material.dart';
import '../models/analysis_model.dart';
import 'Expert_connect.dart';

class ReformSolutionScreen extends StatelessWidget {
  final AnalysisResult result;

  const ReformSolutionScreen({super.key, required this.result});

  /// "step1: ...\nstep2: ..." 형태의 문자열을 단계별 리스트로 파싱
  List<String> _parseSteps(String? plan) {
    if (plan == null || plan.trim().isEmpty) return [];
    return plan
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final steps = _parseSteps(result.reformPlan);

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
                                  _row('재질', result.materialType),
                                  if (result.conditionGrade != null) ...[
                                    const SizedBox(height: 8),
                                    _row('상태 등급', _conditionLabel(result.conditionGrade!)),
                                  ],
                                  const SizedBox(height: 8),
                                  _row('업사이클링 여부', '가능 👍'),
                                  if (result.difficulty != null) ...[
                                    const SizedBox(height: 8),
                                    _row('난이도', _difficultyLabel(result.difficulty!)),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 2. 리폼 아이디어 카드
                            _infoCard(
                              title: result.reformTitle ?? '리폼 아이디어',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  if (result.materials != null)
                                    _row('필요한 재료', result.materials!),
                                  if (result.estimatedTime != null) ...[
                                    const SizedBox(height: 8),
                                    _row('예상 소요 시간', result.estimatedTime!),
                                  ],
                                  if (result.estimatedCost != null) ...[
                                    const SizedBox(height: 8),
                                    _row('예상 비용', result.estimatedCost!),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 3. 단계별 가이드 카드
                            if (steps.isNotEmpty)
                              _guideCard(steps),
                            const SizedBox(height: 20),

                            // 전문가에게 도움받기
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
            // "step1:" 같은 접두어 제거
            final cleaned = step
                .replaceFirst(RegExp(r'^step\s*\d+\s*:\s*', caseSensitive: false), '')
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
                              fontSize: 14, color: Color(0xFF1F402C),
                              height: 1.4)),
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
