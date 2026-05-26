import 'package:flutter/material.dart';
import '../models/analysis_model.dart';
import '../services/analysis_service.dart';
import 'camera_screen.dart';
import 'Reform_solution.dart';
import 'smart_disposal_solution.dart';

class ReformHistoryScreen extends StatefulWidget {
  const ReformHistoryScreen({super.key});

  @override
  State<ReformHistoryScreen> createState() => ReformHistoryScreenState();
}

class ReformHistoryScreenState extends State<ReformHistoryScreen> {
  final AnalysisService _service = AnalysisService();
  List<AnalysisResult> _history = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void reload() => _loadHistory();

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _service.getHistory();
      setState(() {
        _history = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
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
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '리폼하기',
                          style: TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 30,
                            color: Color(0xFF1F402C),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CameraScreen()),
                            );
                            _loadHistory(); // 카메라에서 돌아오면 히스토리 갱신
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF87A676),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '+ 새로만들기',
                              style: TextStyle(
                                fontFamily: 'RebornFont',
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      '나의 리폼 히스토리를 확인하세요!',
                      style: TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 14,
                        color: Color(0xFF33543C),
                      ),
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
                      child: _buildContent(),
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

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF87A676)),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😥',
                style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(_error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 14,
                    color: Color(0xFF6E7B6E))),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _loadHistory,
              child: const Text('다시 시도',
                  style: TextStyle(
                      fontFamily: 'RebornFont', color: Color(0xFF87A676))),
            ),
          ],
        ),
      );
    }

    if (_history.isEmpty) {
      return const Center(
        child: Text(
          '아직 분석 내역이 없어요!\n새로만들기를 눌러 시작해보세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'RebornFont',
            fontSize: 15,
            color: Color(0xFF6E7B6E),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF87A676),
      onRefresh: _loadHistory,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 20),
        itemCount: _history.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _history[index];
          return _ReformHistoryItem(
            result: item,
            onTap: () async {
              if (item.isReformable == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ReformSolutionScreen(result: item)),
                );
              } else {
                // 배출 아이템은 disposalMethod가 history에 없으므로 detail 조회
                AnalysisResult detail = item;
                if (item.analysisId != null) {
                  try {
                    detail = await _service.getDetail(item.analysisId!);
                  } catch (_) {}
                }
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SmartDisposalSolutionScreen(result: detail)),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class _ReformHistoryItem extends StatelessWidget {
  final AnalysisResult result;
  final VoidCallback onTap;

  const _ReformHistoryItem({required this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isReform = result.isReformable == true;
    final title = result.reformTitle?.isNotEmpty == true
        ? result.reformTitle!
        : result.materialType;
    final date = result.createdAt ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3E5C45), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isReform
                    ? const Color(0xFFDFF0D8)
                    : const Color(0xFFFFE8CC),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  isReform ? '♻️' : '🗑️',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 16,
                      color: Color(0xFF1F402C),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (date.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 12,
                        color: Color(0xFF6E7B6E),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isReform
                    ? const Color(0xFFD9EACD)
                    : const Color(0xFFFFE0CC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isReform ? '리폼' : '배출',
                style: TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: 12,
                  color: isReform
                      ? const Color(0xFF1F402C)
                      : const Color(0xFF8D4E00),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
