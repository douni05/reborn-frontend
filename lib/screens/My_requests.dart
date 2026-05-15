import 'package:flutter/material.dart';
import '../services/reform_request_service.dart';
import '../services/review_service.dart';
import '../widgets/bottom_nav_bar.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  final _service = ReformRequestService();
  List<Map<String, dynamic>> _requests = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _service.getMyRequests();
      setState(() {
        _requests = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING':   return const Color(0xFFF5A623);
      case 'ACCEPTED':  return const Color(0xFF87A676);
      case 'REJECTED':  return const Color(0xFFE57272);
      case 'COMPLETED': return const Color(0xFF5C775E);
      case 'CANCELLED': return const Color(0xFFAAAAAA);
      default:          return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'PENDING':   return '대기 중';
      case 'ACCEPTED':  return '수락됨 ✅';
      case 'REJECTED':  return '거절됨';
      case 'COMPLETED': return '완료 🎉';
      case 'CANCELLED': return '취소됨';
      default:          return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EACD),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 22),
              decoration: const BoxDecoration(
                color: Color(0xFFD1EAC3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios,
                        size: 22, color: Color(0xFF1F402C)),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '나의 요청 현황',
                        style: TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 26,
                          color: Color(0xFF1F402C),
                        ),
                      ),
                      Text(
                        '보낸 리폼 의뢰를 확인하세요',
                        style: TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 13,
                          color: Color(0xFF33543C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFF8FAED),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF87A676)))
                    : _error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('😥',
                                    style: TextStyle(fontSize: 40)),
                                const SizedBox(height: 12),
                                Text(_error!,
                                    style: const TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 14,
                                        color: Color(0xFF6E7B6E))),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLoading = true;
                                      _error = null;
                                    });
                                    _load();
                                  },
                                  child: const Text('다시 시도',
                                      style: TextStyle(
                                          fontFamily: 'RebornFont',
                                          color: Color(0xFF87A676))),
                                ),
                              ],
                            ),
                          )
                        : _requests.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('📭',
                                        style: TextStyle(fontSize: 48)),
                                    SizedBox(height: 14),
                                    Text(
                                      '아직 보낸 요청이 없어요',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 16,
                                        color: Color(0xFF6E7B6E),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                color: const Color(0xFF87A676),
                                onRefresh: _load,
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _requests.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final req = _requests[index];
                                    final status =
                                        req['status'] as String? ?? 'PENDING';
                                    final expertMessage =
                                        req['expertMessage'] as String?;
                                    final shopName =
                                        req['shopName'] ?? '공방';
                                    final designTitle =
                                        req['designTitle'] ?? '';
                                    final requestContent =
                                        req['requestContent'] ?? '';
                                    final createdAt =
                                        req['createdAt'] ?? '';

                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16),
                                        border: Border.all(
                                          color: _statusColor(status)
                                              .withValues(alpha: 0.4),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  shopName,
                                                  style: const TextStyle(
                                                    fontFamily: 'RebornFont',
                                                    fontSize: 18,
                                                    color: Color(0xFF1F402C),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: _statusColor(status)
                                                      .withValues(alpha: 0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12),
                                                ),
                                                child: Text(
                                                  _statusLabel(status),
                                                  style: TextStyle(
                                                    fontFamily: 'RebornFont',
                                                    fontSize: 12,
                                                    color:
                                                        _statusColor(status),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          if (designTitle.isNotEmpty)
                                            Text(
                                              '📌 $designTitle',
                                              style: const TextStyle(
                                                fontFamily: 'RebornFont',
                                                fontSize: 13,
                                                color: Color(0xFF87A676),
                                              ),
                                            ),
                                          const SizedBox(height: 4),
                                          Text(
                                            requestContent,
                                            style: const TextStyle(
                                              fontFamily: 'RebornFont',
                                              fontSize: 13,
                                              color: Color(0xFF6E7B6E),
                                              height: 1.4,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            createdAt,
                                            style: const TextStyle(
                                              fontFamily: 'RebornFont',
                                              fontSize: 11,
                                              color: Color(0xFFAAAAAA),
                                            ),
                                          ),
                                          // PENDING 취소 버튼
                                          if (status == 'PENDING') ...[
                                            const SizedBox(height: 10),
                                            GestureDetector(
                                              onTap: () async {
                                                final confirmed = await showDialog<bool>(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    backgroundColor: const Color(0xFFF8FAED),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                    title: const Text('요청을 취소할까요?', style: TextStyle(fontFamily: 'RebornFont', fontSize: 18, color: Color(0xFF1F402C))),
                                                    actions: [
                                                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('아니요', style: TextStyle(fontFamily: 'RebornFont', color: Color(0xFF6E7B6E)))),
                                                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('취소하기', style: TextStyle(fontFamily: 'RebornFont', color: Colors.red))),
                                                    ],
                                                  ),
                                                );
                                                if (confirmed != true) return;
                                                try {
                                                  final requestId = req['requestId'] as int;
                                                  await ReformRequestService().cancelRequest(requestId);
                                                  _load();
                                                } catch (e) {
                                                  if (!mounted) return;
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''), style: const TextStyle(fontFamily: 'RebornFont')), backgroundColor: const Color(0xFF5C3D2E)),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.symmetric(vertical: 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: Colors.red.shade200),
                                                ),
                                                child: Center(
                                                  child: Text('요청 취소', style: TextStyle(fontFamily: 'RebornFont', fontSize: 13, color: Colors.red.shade400)),
                                                ),
                                              ),
                                            ),
                                          ],
                                          // 완료 시 XP 획득 배너
                                          if (status == 'COMPLETED') ...[
                                            const SizedBox(height: 10),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 10),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF3E5C45),
                                                    Color(0xFF87A676),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Row(
                                                children: [
                                                  Text('⭐',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                  SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'XP +150 획득!',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'RebornFont',
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '전문가 연결 +1 완료',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'RebornFont',
                                                          fontSize: 11,
                                                          color: Color(
                                                              0xFFD9EACD),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            _ReviewButton(
                                              requestId: req['requestId'] as int,
                                              shopId: (req['shopId'] as num).toInt(),
                                            ),
                                          ],
                                          // 수락/거절 시 전달 메시지
                                          if ((status == 'ACCEPTED' ||
                                                  status == 'REJECTED' ||
                                                  status == 'COMPLETED') &&
                                              expertMessage != null &&
                                              expertMessage.isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: status == 'REJECTED'
                                                    ? const Color(0xFFFFF0F0)
                                                    : const Color(0xFFEDF7E8),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    status == 'REJECTED'
                                                        ? '💬 전문가 메시지'
                                                        : '💬 전달 메시지',
                                                    style: TextStyle(
                                                      fontFamily: 'RebornFont',
                                                      fontSize: 12,
                                                      color: _statusColor(
                                                          status),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    expertMessage,
                                                    style: const TextStyle(
                                                      fontFamily: 'RebornFont',
                                                      fontSize: 13,
                                                      color: Color(0xFF1F402C),
                                                      height: 1.4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
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
}

class _ReviewButton extends StatefulWidget {
  final int requestId;
  final int shopId;
  const _ReviewButton({required this.requestId, required this.shopId});
  @override
  State<_ReviewButton> createState() => _ReviewButtonState();
}

class _ReviewButtonState extends State<_ReviewButton> {
  bool? _hasReview;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final has = await ReviewService().hasReview(widget.requestId);
    if (mounted) setState(() => _hasReview = has);
  }

  @override
  Widget build(BuildContext context) {
    if (_hasReview == null) return const SizedBox.shrink();
    if (_hasReview!) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(10)),
        child: const Center(child: Text('리뷰 완료 ✅', style: TextStyle(fontFamily: 'RebornFont', fontSize: 13, color: Color(0xFF888888)))),
      );
    }
    return GestureDetector(
      onTap: () => _showReviewDialog(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF87A676),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(child: Text('리뷰 작성하기 ✏️', style: TextStyle(fontFamily: 'RebornFont', fontSize: 13, color: Colors.white))),
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    int selectedRating = 5;
    final contentController = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
            decoration: BoxDecoration(color: const Color(0xFFF8FAED), borderRadius: BorderRadius.circular(18)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('리뷰 작성', style: TextStyle(fontFamily: 'RebornFont', fontSize: 22, color: Color(0xFF1F402C))),
                const SizedBox(height: 16),
                const Text('별점', style: TextStyle(fontFamily: 'RebornFont', fontSize: 15, color: Color(0xFF1F402C))),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedRating = i + 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          i < selectedRating ? Icons.star : Icons.star_border,
                          size: 36,
                          color: const Color(0xFFF5A623),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 14),
                const Text('후기', style: TextStyle(fontFamily: 'RebornFont', fontSize: 15, color: Color(0xFF1F402C))),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3E5C45)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    controller: contentController,
                    maxLines: 3,
                    style: const TextStyle(fontFamily: 'RebornFont', fontSize: 14, color: Color(0xFF1F402C)),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '전문가와의 작업은 어떠셨나요?',
                      hintStyle: TextStyle(fontFamily: 'RebornFont', fontSize: 13, color: Color(0xFF9AA39A)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(color: const Color(0xFFF1F1F1), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFB7B7B7))),
                          child: const Center(child: Text('취소', style: TextStyle(fontFamily: 'RebornFont', fontSize: 15, color: Color(0xFF1F402C)))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: isSaving ? null : () async {
                          setDialogState(() => isSaving = true);
                          try {
                            await ReviewService().createReview(
                              requestId: widget.requestId,
                              shopId: widget.shopId,
                              rating: selectedRating,
                              content: contentController.text.trim(),
                            );
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            setState(() => _hasReview = true);
                          } catch (e) {
                            setDialogState(() => isSaving = false);
                            if (!ctx.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''), style: const TextStyle(fontFamily: 'RebornFont')), backgroundColor: const Color(0xFF5C3D2E)),
                            );
                          }
                        },
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(color: const Color(0xFF87A676), borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: isSaving
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('등록', style: TextStyle(fontFamily: 'RebornFont', fontSize: 15, color: Colors.white)),
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
      ),
    );
  }
}
