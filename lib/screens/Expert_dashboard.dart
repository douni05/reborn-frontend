import 'package:flutter/material.dart';
import '../services/reform_request_service.dart';
import '../widgets/bottom_nav_bar.dart';

class ExpertDashboardScreen extends StatefulWidget {
  const ExpertDashboardScreen({super.key});

  @override
  State<ExpertDashboardScreen> createState() => _ExpertDashboardScreenState();
}

class _ExpertDashboardScreenState extends State<ExpertDashboardScreen> {
  final _service = ReformRequestService();
  String _selectedTab = '신규요청';
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
      final data = await _service.getExpertRequests();
      setState(() {
        _requests = data;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _pending =>
      _requests.where((r) => r['status'] == 'PENDING').toList();
  List<Map<String, dynamic>> get _accepted =>
      _requests.where((r) => r['status'] == 'ACCEPTED').toList();
  List<Map<String, dynamic>> get _completed =>
      _requests.where((r) => r['status'] == 'COMPLETED').toList();
  List<Map<String, dynamic>> get _rejected =>
      _requests.where((r) => r['status'] == 'REJECTED').toList();

  List<Map<String, dynamic>> get _currentList {
    if (_selectedTab == '신규요청') return _pending;
    if (_selectedTab == '진행 중') return _accepted;
    if (_selectedTab == '거절') return _rejected;
    return _completed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EACD),
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 22),
              decoration: const BoxDecoration(
                color: Color(0xFFD1EAC3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('전문가 대시보드',
                      style: TextStyle(fontFamily: 'RebornFont', fontSize: 30, color: Color(0xFF1F402C))),
                  SizedBox(height: 4),
                  Text('답변을 기다리는 의뢰와 진행 중인 작업을 확인하세요.',
                      style: TextStyle(fontFamily: 'RebornFont', fontSize: 14, color: Color(0xFF33543C))),
                ],
              ),
            ),
            // 탭
            Container(
              color: const Color(0xFFF8FAED),
              child: Row(
                children: ['신규요청', '진행 중', '완료', '거절'].map((tab) {
                  final isSelected = _selectedTab == tab;
                  // 탭별 배지 카운트
                  int count = 0;
                  if (tab == '신규요청') count = _pending.length;
                  else if (tab == '진행 중') count = _accepted.length;
                  else if (tab == '완료') count = _completed.length;
                  else count = _rejected.length;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = tab),
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(tab,
                                    style: const TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 17,
                                        color: Color(0xFF1F402C))),
                                if (count > 0) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF87A676),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('$count',
                                        style: const TextStyle(fontSize: 11, color: Colors.white)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 3,
                              color: isSelected ? const Color(0xFF1F402C) : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // 본문
            Expanded(
              child: Container(
                color: const Color(0xFFF8FAED),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF87A676)))
                    : _error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('😥', style: TextStyle(fontSize: 40)),
                                const SizedBox(height: 12),
                                Text(_error!,
                                    style: const TextStyle(
                                        fontFamily: 'RebornFont', fontSize: 14, color: Color(0xFF6E7B6E))),
                                TextButton(
                                  onPressed: () { setState(() { _isLoading = true; _error = null; }); _load(); },
                                  child: const Text('다시 시도',
                                      style: TextStyle(fontFamily: 'RebornFont', color: Color(0xFF87A676))),
                                ),
                              ],
                            ),
                          )
                        : _currentList.isEmpty
                            ? Center(
                                child: Text(
                                  _selectedTab == '신규요청'
                                      ? '새로운 요청이 없어요 📭'
                                      : _selectedTab == '진행 중'
                                          ? '진행 중인 작업이 없어요'
                                          : _selectedTab == '거절'
                                              ? '거절한 요청이 없어요'
                                              : '완료된 작업이 없어요',
                                  style: const TextStyle(
                                      fontFamily: 'RebornFont', fontSize: 15, color: Color(0xFF6E7B6E)),
                                ),
                              )
                            : RefreshIndicator(
                                color: const Color(0xFF87A676),
                                onRefresh: _load,
                                child: ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 20),
                                  itemCount: _currentList.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final req = _currentList[index];
                                    return _buildRequestCard(req);
                                  },
                                ),
                              ),
              ),
            ),
            const BottomNavBar(selectedIndex: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> req) {
    final status = req['status'] as String? ?? 'PENDING';
    final requestId = req['requestId'] as int;
    final nickname = req['requesterNickname'] ?? '사용자';
    final designTitle = req['designTitle'] ?? '';
    final requestContent = req['requestContent'] ?? '';
    final createdAt = req['createdAt'] ?? '';

    return GestureDetector(
      onTap: () => _showRequestDetail(req),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF5C775E), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(nickname,
                    style: const TextStyle(
                        fontFamily: 'RebornFont', fontSize: 20, color: Color(0xFF1F402C))),
                const SizedBox(width: 10),
                Text(createdAt,
                    style: const TextStyle(
                        fontFamily: 'RebornFont', fontSize: 12, color: Color(0xFF8A8A8A))),
              ],
            ),
            const SizedBox(height: 6),
            if (designTitle.isNotEmpty)
              Text('📌 $designTitle',
                  style: const TextStyle(
                      fontFamily: 'RebornFont', fontSize: 13, color: Color(0xFF87A676))),
            const SizedBox(height: 4),
            Text(requestContent,
                style: const TextStyle(
                    fontFamily: 'RebornFont', fontSize: 12, color: Color(0xFF8A8A8A), height: 1.35),
                maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status == 'PENDING') ...[
                  _actionBtn(
                    label: '요청 거절',
                    filled: false,
                    onTap: () => _showActionDialog(
                      requestId: requestId,
                      isAccept: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _actionBtn(
                    label: '요청 수락',
                    filled: true,
                    onTap: () => _showActionDialog(
                      requestId: requestId,
                      isAccept: true,
                    ),
                  ),
                ] else if (status == 'ACCEPTED') ...[
                  _actionBtn(
                    label: '작업 완료',
                    filled: true,
                    onTap: () => _showCompleteDialog(requestId),
                  ),
                ] else if (status == 'REJECTED') ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE57272).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('거절됨',
                        style: TextStyle(
                            fontFamily: 'RebornFont', fontSize: 13, color: Color(0xFFE57272))),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C775E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('완료됨',
                        style: TextStyle(
                            fontFamily: 'RebornFont', fontSize: 13, color: Color(0xFF5C775E))),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn({required String label, required bool filled, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF87A676) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: filled ? const Color(0xFF87A676) : const Color(0xFF5C775E),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
                fontFamily: 'RebornFont',
                fontSize: 13,
                color: filled ? Colors.white : const Color(0xFF1F402C))),
      ),
    );
  }

  void _showRequestDetail(Map<String, dynamic> req) {
    final status = req['status'] as String? ?? 'PENDING';
    final requestId = req['requestId'] as int;
    final nickname = req['requesterNickname'] ?? '사용자';
    final designTitle = req['designTitle'] ?? '';
    final requestContent = req['requestContent'] ?? '';

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAED),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('$nickname 님의 요청',
                        style: const TextStyle(
                            fontFamily: 'RebornFont', fontSize: 22, color: Color(0xFF1F402C))),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close, size: 24, color: Color(0xFF1F402C)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (designTitle.isNotEmpty) ...[
                const Text('선택한 디자인',
                    style: TextStyle(fontFamily: 'RebornFont', fontSize: 16, color: Color(0xFF1F402C))),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCFE4C6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(designTitle,
                      style: const TextStyle(fontFamily: 'RebornFont', fontSize: 14, color: Color(0xFF1F402C))),
                ),
                const SizedBox(height: 12),
              ],
              const Text('요청 내용',
                  style: TextStyle(fontFamily: 'RebornFont', fontSize: 16, color: Color(0xFF1F402C))),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF5C775E), width: 1),
                ),
                child: Text(requestContent,
                    style: const TextStyle(
                        fontFamily: 'RebornFont', fontSize: 14, color: Color(0xFF8A8A8A), height: 1.4)),
              ),
              const SizedBox(height: 16),
              if (status == 'PENDING')
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showActionDialog(requestId: requestId, isAccept: false);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF5C775E)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('거절',
                            style: TextStyle(fontFamily: 'RebornFont', color: Color(0xFF1F402C))),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showActionDialog(requestId: requestId, isAccept: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF87A676),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('수락',
                            style: TextStyle(fontFamily: 'RebornFont', color: Colors.white)),
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

  void _showActionDialog({required int requestId, required bool isAccept}) {
    final msgController = TextEditingController();
    bool isProcessing = false;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAED),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAccept ? '요청 수락' : '요청 거절',
                  style: const TextStyle(
                      fontFamily: 'RebornFont', fontSize: 22, color: Color(0xFF1F402C)),
                ),
                const SizedBox(height: 6),
                Text(
                  isAccept
                      ? '고객에게 전달할 메시지를 입력하세요\n(연락처, 방문 안내 등)'
                      : '거절 사유나 메시지를 입력하세요 (선택)',
                  style: const TextStyle(
                      fontFamily: 'RebornFont', fontSize: 13, color: Color(0xFF6E7B6E), height: 1.4),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3E5C45), width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    controller: msgController,
                    maxLines: 4,
                    style: const TextStyle(
                        fontFamily: 'RebornFont', fontSize: 14, color: Color(0xFF1F402C)),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: isAccept
                          ? '예: 안녕하세요! 요청 수락했습니다. 010-0000-0000으로 연락 주세요 :)'
                          : '예: 현재 작업이 많아 수락이 어렵습니다.',
                      hintStyle: const TextStyle(
                          fontFamily: 'RebornFont', fontSize: 13, color: Color(0xFF9AA39A)),
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
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFB7B7B7)),
                          ),
                          child: const Center(
                            child: Text('취소',
                                style: TextStyle(
                                    fontFamily: 'RebornFont', fontSize: 16, color: Color(0xFF1F402C))),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: isProcessing
                            ? null
                            : () async {
                                setDialogState(() => isProcessing = true);
                                try {
                                  if (isAccept) {
                                    await _service.acceptRequest(requestId, msgController.text.trim());
                                  } else {
                                    await _service.rejectRequest(requestId, msgController.text.trim());
                                  }
                                  if (!mounted) return;
                                  Navigator.pop(ctx);
                                  _load();
                                } catch (e) {
                                  setDialogState(() => isProcessing = false);
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(e.toString().replaceFirst('Exception: ', ''),
                                            style: const TextStyle(fontFamily: 'RebornFont')),
                                        backgroundColor: const Color(0xFF5C3D2E)),
                                  );
                                }
                              },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: isAccept ? const Color(0xFF87A676) : Colors.red.shade400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: isProcessing
                                ? const SizedBox(
                                    width: 20, height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : Text(isAccept ? '수락하기' : '거절하기',
                                    style: const TextStyle(
                                        fontFamily: 'RebornFont', fontSize: 16, color: Colors.white)),
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

  void _showCompleteDialog(int requestId) {
    bool isProcessing = false;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAED),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('작업 완료 확인',
                    style: TextStyle(fontFamily: 'RebornFont', fontSize: 22, color: Color(0xFF1F402C))),
                const SizedBox(height: 10),
                const Text('이 요청을 완료 처리할까요?\n완료된 작업은 \'완료\' 탭에서 확인할 수 있어요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'RebornFont', fontSize: 14, color: Color(0xFF6E7B6E), height: 1.4)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFB7B7B7)),
                          ),
                          child: const Center(
                            child: Text('취소',
                                style: TextStyle(fontFamily: 'RebornFont', fontSize: 16, color: Color(0xFF1F402C))),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: isProcessing
                            ? null
                            : () async {
                                setDialogState(() => isProcessing = true);
                                try {
                                  await _service.completeRequest(requestId);
                                  if (!mounted) return;
                                  Navigator.pop(ctx);
                                  _load();
                                } catch (e) {
                                  setDialogState(() => isProcessing = false);
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString().replaceFirst('Exception: ', '')),
                                        backgroundColor: const Color(0xFF5C3D2E)),
                                  );
                                }
                              },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5C775E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: isProcessing
                                ? const SizedBox(width: 20, height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('완료 처리',
                                    style: TextStyle(fontFamily: 'RebornFont', fontSize: 16, color: Colors.white)),
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
