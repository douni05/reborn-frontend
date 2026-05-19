import 'package:flutter/material.dart';
import '../models/analysis_model.dart';

class SmartDisposalSolutionScreen extends StatelessWidget {
  final AnalysisResult result;

  const SmartDisposalSolutionScreen({super.key, required this.result});

  /// "1. ...\n2. ..." 또는 "step1: ..." 형태의 배출 방법을 줄 단위로 파싱
  List<String> _parseDisposalSteps(String? method) {
    if (method == null || method.trim().isEmpty) return [];
    return method
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final steps = _parseDisposalSteps(result.disposalMethod);
    final icon = result.disposalIcon ?? '🗑️';

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
                            // 1. 분석 결과 카드
                            _sectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(icon,
                                          style: const TextStyle(fontSize: 28)),
                                      const SizedBox(width: 10),
                                      const Text('분석 결과',
                                          style: TextStyle(
                                              fontFamily: 'RebornFont',
                                              fontSize: 22,
                                              color: Color(0xFF1F402C))),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _row('재질', result.materialType),
                                  if (result.conditionGrade != null) ...[
                                    const SizedBox(height: 8),
                                    _row('상태 등급', _conditionLabel(result.conditionGrade!)),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text('업사이클링 여부 : ',
                                          style: TextStyle(
                                              fontFamily: 'RebornFont',
                                              fontSize: 15,
                                              color: Color(0xFF6E8B64))),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFE0E0),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Text('어려워요 😢',
                                            style: TextStyle(
                                                fontFamily: 'RebornFont',
                                                fontSize: 13,
                                                color: Color(0xFFB03030))),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 2. 배출 방법 카드
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
                                          fontSize: 14, color: Color(0xFF1F402C),
                                          height: 1.5),
                                    )
                                  else
                                    ...steps.asMap().entries.map((e) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: e.key < steps.length - 1 ? 10 : 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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

                            // 스마트 배출 확인 버튼
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5C8A76),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(
                                        color: Color(0xFF3E6B58), width: 1),
                                  ),
                                ),
                                child: const Text('✅ 배출 완료',
                                    style: TextStyle(fontFamily: 'RebornFont',
                                        fontSize: 20, color: Colors.white)),
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
