import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/bottom_nav_bar.dart';
import 'Expert_register2.dart';

class ExpertRegister1Screen extends StatefulWidget {
  const ExpertRegister1Screen({super.key});

  @override
  State<ExpertRegister1Screen> createState() => _ExpertRegister1ScreenState();
}

class _ExpertRegister1ScreenState extends State<ExpertRegister1Screen> {
  final _shopNameController = TextEditingController();
  final _businessNumberController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _imageFile;
  String? _shopNameError;
  String? _businessNumberError;
  String? _ownerNameError;
  String? _phoneError;

  @override
  void dispose() {
    _shopNameController.dispose();
    _businessNumberController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _goNext() {
    setState(() {
      _shopNameError = _shopNameController.text.trim().isEmpty ? '공방/작업실 이름을 입력해주세요' : null;
      _businessNumberError = _businessNumberController.text.trim().isEmpty ? '사업자등록번호를 입력해주세요' : null;
      _ownerNameError = _ownerNameController.text.trim().isEmpty ? '대표자명을 입력해주세요' : null;
      _phoneError = _phoneController.text.trim().isEmpty ? '연락처를 입력해주세요' : null;
    });

    if (_shopNameError != null || _businessNumberError != null ||
        _ownerNameError != null || _phoneError != null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpertRegister2Screen(
          shopName: _shopNameController.text.trim(),
          businessNumber: _businessNumberController.text.trim(),
          ownerName: _ownerNameController.text.trim(),
          phone: _phoneController.text.trim(),
          imageFile: _imageFile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAED),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 22),
              decoration: const BoxDecoration(
                color: Color(0xFFD9EACD),
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
                  SizedBox(height: 6),
                  Text(
                    '업사이클링 전문가로 등록하고 고객과 연결되세요!',
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 13,
                      color: Color(0xFF33543C),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('📋', style: TextStyle(fontSize: 22)),
                        SizedBox(width: 8),
                        Text(
                          '사업자 정보',
                          style: TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 28,
                            color: Color(0xFF1F402C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 공방 사진
                    const Text(
                      '공방 사진',
                      style: TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 18,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4EC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF3E5C45),
                            width: 1,
                          ),
                          image: _imageFile != null
                              ? DecorationImage(
                                  image: FileImage(_imageFile!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _imageFile == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 40,
                                    color: Color(0xFF87A676),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '사진 추가 (선택)',
                                    style: TextStyle(
                                      fontFamily: 'RebornFont',
                                      fontSize: 14,
                                      color: Color(0xFF6E8B64),
                                    ),
                                  ),
                                ],
                              )
                            : Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: GestureDetector(
                                    onTap: () => setState(() => _imageFile = null),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    _label('공방/작업실 이름'),
                    const SizedBox(height: 8),
                    _inputBox(
                      controller: _shopNameController,
                      hint: '예: 지미의 공방',
                      error: _shopNameError,
                      onChanged: (_) => setState(() => _shopNameError = null),
                    ),
                    const SizedBox(height: 18),
                    _label('사업자등록번호'),
                    const SizedBox(height: 8),
                    _inputBox(
                      controller: _businessNumberController,
                      hint: '000-00-00000',
                      error: _businessNumberError,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() => _businessNumberError = null),
                    ),
                    const SizedBox(height: 18),
                    _label('대표자명'),
                    const SizedBox(height: 8),
                    _inputBox(
                      controller: _ownerNameController,
                      hint: '홍길동',
                      error: _ownerNameError,
                      onChanged: (_) => setState(() => _ownerNameError = null),
                    ),
                    const SizedBox(height: 18),
                    _label('연락처'),
                    const SizedBox(height: 8),
                    _inputBox(
                      controller: _phoneController,
                      hint: '010-0000-0000',
                      error: _phoneError,
                      keyboardType: TextInputType.phone,
                      onChanged: (_) => setState(() => _phoneError = null),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _goNext,
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
                        child: const Text(
                          '다음단계',
                          style: TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const BottomNavBar(selectedIndex: 4),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'RebornFont',
        fontSize: 18,
        color: Color(0xFF1F402C),
      ),
    );
  }

  Widget _inputBox({
    required TextEditingController controller,
    required String hint,
    String? error,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: error != null ? Colors.red : const Color(0xFF3E5C45),
              width: 1,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: const TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 16,
              color: Color(0xFF1F402C),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'RebornFont',
                fontSize: 16,
                color: Color(0xFF9AA39A),
              ),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              error,
              style: const TextStyle(
                fontFamily: 'RebornFont',
                fontSize: 13,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
