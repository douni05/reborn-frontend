import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/expert_service.dart';
import 'Expert_connect.dart';

class ExpertRegister3Screen extends StatefulWidget {
  final String shopName;
  final String businessNumber;
  final String ownerName;
  final String phone;
  final String address;
  final String detailAddress;
  final File? imageFile;

  const ExpertRegister3Screen({
    super.key,
    required this.shopName,
    required this.businessNumber,
    required this.ownerName,
    required this.phone,
    required this.address,
    required this.detailAddress,
    this.imageFile,
  });

  @override
  State<ExpertRegister3Screen> createState() => _ExpertRegister3ScreenState();
}

class _ExpertRegister3ScreenState extends State<ExpertRegister3Screen> {
  final _introductionController = TextEditingController();
  final _expertService = ExpertService();

  String _selectedCategory = '의류';
  String? _introductionError;
  bool _isLoading = false;

  final List<String> _categories = [
    '의류',
    '목재/가구',
    '금속',
    '플라스틱',
    '유리',
    '액세서리',
    '전자제품',
    '기타',
  ];

  @override
  void dispose() {
    _introductionController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _introductionError = _introductionController.text.trim().isEmpty
          ? '소개글을 입력해주세요'
          : null;
    });

    if (_introductionError != null) return;

    setState(() => _isLoading = true);

    try {
      // 이미지 있으면 Supabase Storage에 업로드
      String? imageUrl;
      if (widget.imageFile != null) {
        imageUrl = await _expertService.uploadImage(widget.imageFile!);
      }

      await _expertService.register(
        shopName: widget.shopName,
        businessNumber: widget.businessNumber,
        ownerName: widget.ownerName,
        phone: widget.phone,
        address: widget.address,
        detailAddress: widget.detailAddress,
        category: _selectedCategory,
        introduction: _introductionController.text.trim(),
        imageUrl: imageUrl,
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFFF8FAED),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            '등록 완료 🎉',
            style: TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 22,
              color: Color(0xFF1F402C),
            ),
          ),
          content: const Text(
            '전문가로 등록되었어요!\n이제 고객과 연결될 수 있어요.',
            style: TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 15,
              color: Color(0xFF33543C),
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const ExpertConnectScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                '확인',
                style: TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: 16,
                  color: Color(0xFF87A676),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: const TextStyle(fontFamily: 'RebornFont')),
          backgroundColor: const Color(0xFF5C3D2E),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 24),
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
                  Text(
                    '전문가 등록',
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 30,
                      color: Color(0xFF1F402C),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '업사이클링 전문가로 등록하고 고객과 연결되세요!',
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 14,
                      color: Color(0xFF33543C),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF8FAED),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('🎯', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8),
                          Text(
                            '전문 분야',
                            style: TextStyle(
                              fontFamily: 'RebornFont',
                              fontSize: 28,
                              color: Color(0xFF1F402C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        '전문 분야 설정',
                        style: TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 18,
                          color: Color(0xFF1F402C),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 2.55,
                        ),
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isSelected = _selectedCategory == cat;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = cat),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF87A676)
                                    : const Color(0xFFF7F7F7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF8A9485),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                cat,
                                style: TextStyle(
                                  fontFamily: 'RebornFont',
                                  fontSize: 17,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF1F402C),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '소개글',
                        style: TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 18,
                          color: Color(0xFF1F402C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 112,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _introductionError != null
                                ? Colors.red
                                : const Color(0xFF5C775E),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _introductionController,
                          maxLines: null,
                          expands: true,
                          onChanged: (_) =>
                              setState(() => _introductionError = null),
                          style: const TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 15,
                            color: Color(0xFF1F402C),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '공방 소개 및 작업 가능한 내용을 자유롭게 작성해주세요.',
                            hintStyle: TextStyle(
                              fontFamily: 'RebornFont',
                              fontSize: 15,
                              color: Color(0xFF9AA39A),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ),
                      if (_introductionError != null) ...[
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            _introductionError!,
                            style: const TextStyle(
                              fontFamily: 'RebornFont',
                              fontSize: 13,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB0C4A8),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(
                                      color: Color(0xFF8A9E80),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  '이전',
                                  style: TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF87A676),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(
                                      color: Color(0xFF6E8B64),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        '등록하기',
                                        style: TextStyle(
                                          fontFamily: 'RebornFont',
                                          fontSize: 18,
                                          color: Colors.white,
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
            ),
            const BottomNavBar(selectedIndex: 4),
          ],
        ),
      ),
    );
  }
}
