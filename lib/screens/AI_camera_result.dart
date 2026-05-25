import 'package:flutter/material.dart';
import '../services/analysis_service.dart';
import '../models/analysis_model.dart';
import 'Reform_solution.dart';
import 'smart_disposal_solution.dart';
import 'dart:io';

class AICameraResultScreen extends StatefulWidget {
  final String detectedLabel;
  final double confidence;
  final String imagePath;

  const AICameraResultScreen({
    super.key,
    required this.detectedLabel,
    required this.confidence,
    required this.imagePath,
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
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await _service.analyze(
        label: widget.detectedLabel,
        imagePath: widget.imagePath.isNotEmpty ? widget.imagePath : null,
      );
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _goToSolution() {
    final result = _result!;
    if (result.isReformable == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReformSolutionScreen(result: result),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SmartDisposalSolutionScreen(result: result),
        ),
      );
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
                style: TextStyle(fontFamily: 'RebornFont', fontSize: 16,
                    color: Color(0xFF1F402C))),
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
                  style: TextStyle(fontFamily: 'RebornFont', fontSize: 18,
                      color: Color(0xFF1F402C))),
              const SizedBox(height: 8),
              Text('인식된 물체: ${widget.detectedLabel}',
                  style: const TextStyle(fontFamily: 'RebornFont', fontSize: 14,
                      color: Color(0xFF87A676))),
              const SizedBox(height: 4),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'RebornFont', fontSize: 12,
                      color: Color(0xFF888888))),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchAnalysis,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF87A676)),
                child: const Text('다시 시도',
                    style: TextStyle(color: Colors.white,
                        fontFamily: 'RebornFont')),
              ),
            ],
          ),
        ),
      );
    }

    final result = _result!;
    final isReformable = result.isReformable == true;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 34, 22, 24),
      child: Column(
        children: [
          // 촬영한 사진
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF3E5C45), width: 1),
                color: const Color(0xFFDFF0D8),
                image: widget.imagePath.isNotEmpty
                    ? DecorationImage(
                        image: FileImage(File(widget.imagePath)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: widget.imagePath.isEmpty
                  ? const Center(
                      child: Icon(Icons.recycling,
                          size: 64, color: Color(0xFF87A676)))
                  : null,
            ),
          ),
          const SizedBox(height: 16),

          // MLKit 인식 태그
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF87A676),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.detectedLabel} · ${(widget.confidence * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'RebornFont', fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 분석 결과 카드
          Container(
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
                const Text('분석 결과',
                    style: TextStyle(fontFamily: 'RebornFont', fontSize: 20,
                        color: Color(0xFF1F402C))),
                const SizedBox(height: 10),
                _resultRow('재질', result.materialType),
                const SizedBox(height: 6),
                if (result.conditionGrade != null) ...[
                  _resultRow('상태 등급', _conditionLabel(result.conditionGrade!)),
                  const SizedBox(height: 6),
                ],
                Row(
                  children: [
                    const Text('업사이클링 여부 : ',
                        style: TextStyle(fontFamily: 'RebornFont', fontSize: 15,
                            color: Color(0xFF1F402C))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: isReformable
                            ? const Color(0xFFDFF0D8)
                            : const Color(0xFFFFE0E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isReformable ? '가능 👍' : '어려워요 😢',
                        style: TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 14,
                          color: isReformable
                              ? const Color(0xFF3E5C45)
                              : const Color(0xFFB03030),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 솔루션 버튼
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _goToSolution,
              style: ElevatedButton.styleFrom(
                backgroundColor: isReformable
                    ? const Color(0xFF87A676)
                    : const Color(0xFF5C8A76),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: isReformable
                        ? const Color(0xFF6E8B64)
                        : const Color(0xFF3E6B58),
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                isReformable ? '♻️ 리폼 솔루션 보기' : '🗑️ 배출 가이드 보기',
                style: const TextStyle(
                    fontFamily: 'RebornFont', fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Text(
      '$label : $value',
      style: const TextStyle(
          fontFamily: 'RebornFont', fontSize: 15, color: Color(0xFF1F402C)),
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
