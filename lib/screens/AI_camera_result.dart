import 'package:flutter/material.dart';
import '../services/analysis_service.dart';
import 'Reform_solution.dart';
import 'dart:io';

class AICameraResultScreen extends StatefulWidget {
  final String detectedLabel;
  final double confidence;
  final String imagePath;
  final int userId;

  const AICameraResultScreen({
    super.key,
    required this.detectedLabel,
    required this.confidence,
    required this.imagePath,
    this.userId = 1,
  });

  @override
  State<AICameraResultScreen> createState() => _AICameraResultScreenState();
}

class _AICameraResultScreenState extends State<AICameraResultScreen> {
  final AnalysisService _service = AnalysisService();
  bool _isLoading = true;
  String? _error;
  AnalysisResult? _result;

  @override
  void initState() {
    super.initState();
    _fetchAnalysis();
  }

  Future<void> _fetchAnalysis() async {
    try {
      final result = await _service.analyze(
        label: widget.detectedLabel,
        userId: widget.userId,
      );
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

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
                        const Text('AI 카메라 분석',
                            style: TextStyle(
                                fontFamily: 'RebornFont',
                                fontSize: 28,
                                color: Color(0xFF1F402C))),
                      ],
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
                      child: _buildBody(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF87A676)),
            SizedBox(height: 16),
            Text('AI가 분석 중이에요...',
                style: TextStyle(fontFamily: 'RebornFont', fontSize: 16)),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              const Text('서버에 연결할 수 없어요',
                  style: TextStyle(fontFamily: 'RebornFont', fontSize: 18)),
              const SizedBox(height: 8),

              // 서버 없어도 MLKit 결과는 보여줌
              Text('인식된 물체: ${widget.detectedLabel}',
                  style: const TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 14,
                      color: Color(0xFF87A676))),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _fetchAnalysis();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87A676),
                ),
                child: const Text('다시 시도',
                    style: TextStyle(color: Colors.white,
                        fontFamily: 'RebornFont')),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ReformSolutionScreen())),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 34, 22, 24),
        child: Column(
          children: [
            // 촬영한 사진
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF3E5C45), width: 1),
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // MLKit 인식 결과 태그
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF87A676),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.detectedLabel} · ${(widget.confidence * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'RebornFont',
                        fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 서버 분석 결과
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFF3E5C45), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('분석 결과',
                      style: TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 22,
                          color: Color(0xFF1F402C))),
                  const SizedBox(height: 10),
                  Text('재질 : ${_result!.materialType}',
                      style: const TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 16,
                          color: Color(0xFF1F402C))),
                  const SizedBox(height: 6),
                  Text(
                      '업사이클링 가능 여부 : ${(_result!.isReformable ?? false) ? '좋아요! 👍' : '어려워요 😢'}',
                      style: const TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 16,
                          color: Color(0xFF1F402C))),
                  if (_result!.reformPlan != null) ...[
                    const SizedBox(height: 6),
                    Text('리폼 아이디어 : ${_result!.reformPlan}',
                        style: const TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 16,
                            color: Color(0xFF1F402C))),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text('탭하면 상세 솔루션으로 이동해요 →',
                style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 13,
                    color: Color(0xFF87A676))),
          ],
        ),
      ),
    );
  }
}