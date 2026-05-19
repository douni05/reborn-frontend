import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/expert_service.dart';
import '../widgets/bottom_nav_bar.dart';

class ExpertEditScreen extends StatefulWidget {
  final Map<String, dynamic> expert;

  const ExpertEditScreen({super.key, required this.expert});

  @override
  State<ExpertEditScreen> createState() => _ExpertEditScreenState();
}

class _ExpertEditScreenState extends State<ExpertEditScreen> {
  late final TextEditingController _shopNameController;
  late final TextEditingController _businessNumberController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _detailAddressController;
  late final TextEditingController _introductionController;

  late String _selectedCategory;
  File? _newImageFile;
  bool _isLoading = false;
  final _expertService = ExpertService();

  final List<String> _categories = [
    '의류', '목재/가구', '금속', '플라스틱', '유리', '액세서리', '전자제품', '기타',
  ];

  @override
  void initState() {
    super.initState();
    _shopNameController = TextEditingController(text: widget.expert['shopName'] ?? '');
    _businessNumberController = TextEditingController(text: widget.expert['businessNumber'] ?? '');
    _ownerNameController = TextEditingController(text: widget.expert['ownerName'] ?? '');
    _phoneController = TextEditingController(text: widget.expert['phone'] ?? '');
    _addressController = TextEditingController(text: widget.expert['address'] ?? '');
    _detailAddressController = TextEditingController(text: widget.expert['detailAddress'] ?? '');
    _introductionController = TextEditingController(text: widget.expert['introduction'] ?? '');
    _selectedCategory = widget.expert['category'] ?? '의류';
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _businessNumberController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _detailAddressController.dispose();
    _introductionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() => _newImageFile = File(picked.path));
    }
  }

  Future<(double?, double?)> _geocodeAddress(String address) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {'q': address, 'format': 'json', 'limit': 1, 'countrycodes': 'kr'},
        options: Options(
          headers: {'User-Agent': 'RebornApp/1.0'},
          receiveTimeout: const Duration(seconds: 8),
        ),
      );
      if (response.data is List && (response.data as List).isNotEmpty) {
        final item = response.data[0] as Map<String, dynamic>;
        final lat = double.tryParse(item['lat']?.toString() ?? '');
        final lon = double.tryParse(item['lon']?.toString() ?? '');
        return (lat, lon);
      }
    } catch (_) {}
    return (null, null);
  }

  Future<void> _save() async {
    if (_shopNameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _introductionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('필수 항목을 모두 입력해주세요',
              style: TextStyle(fontFamily: 'RebornFont')),
          backgroundColor: Color(0xFF5C3D2E),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 새 이미지가 선택됐으면 업로드
      String? imageUrl = widget.expert['imageUrl'] as String?;
      if (_newImageFile != null) {
        imageUrl = await _expertService.uploadImage(_newImageFile!);
      }

      // 주소가 바뀌었으면 위경도 재계산
      final originalAddress = widget.expert['address'] as String? ?? '';
      final newAddress = _addressController.text.trim();
      double? lat = (widget.expert['latitude'] as num?)?.toDouble();
      double? lon = (widget.expert['longitude'] as num?)?.toDouble();
      if (newAddress != originalAddress || lat == null) {
        final (newLat, newLon) = await _geocodeAddress(newAddress);
        lat = newLat;
        lon = newLon;
      }

      await _expertService.updateExpert(
        shopName: _shopNameController.text.trim(),
        businessNumber: _businessNumberController.text.trim(),
        ownerName: _ownerNameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: newAddress,
        detailAddress: _detailAddressController.text.trim(),
        category: _selectedCategory,
        introduction: _introductionController.text.trim(),
        imageUrl: imageUrl,
        latitude: lat,
        longitude: lon,
      );

      if (!mounted) return;
      Navigator.pop(context, true); // true = 수정됨
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
            style: const TextStyle(fontFamily: 'RebornFont'),
          ),
          backgroundColor: const Color(0xFF5C3D2E),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final existingImageUrl = widget.expert['imageUrl'] as String?;

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
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios,
                        size: 22, color: Color(0xFF1F402C)),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '전문가 정보 수정',
                        style: TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 26,
                          color: Color(0xFF1F402C),
                        ),
                      ),
                      Text(
                        '등록 정보를 수정할 수 있어요',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 공방 사진
                    _sectionTitle('📸 공방 사진'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4EC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF3E5C45), width: 1),
                          image: _newImageFile != null
                              ? DecorationImage(
                                  image: FileImage(_newImageFile!),
                                  fit: BoxFit.cover)
                              : (existingImageUrl != null && existingImageUrl.isNotEmpty)
                                  ? DecorationImage(
                                      image: NetworkImage(existingImageUrl),
                                      fit: BoxFit.cover)
                                  : null,
                        ),
                        child: (_newImageFile == null &&
                                (existingImageUrl == null || existingImageUrl.isEmpty))
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_outlined,
                                      size: 36, color: Color(0xFF87A676)),
                                  SizedBox(height: 6),
                                  Text('사진 추가',
                                      style: TextStyle(
                                          fontFamily: 'RebornFont',
                                          fontSize: 13,
                                          color: Color(0xFF6E8B64))),
                                ],
                              )
                            : Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      _newImageFile = null;
                                    }),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(Icons.edit,
                                          size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _sectionTitle('📋 사업자 정보'),
                    const SizedBox(height: 12),
                    _label('공방/작업실 이름'),
                    const SizedBox(height: 6),
                    _inputBox(controller: _shopNameController, hint: '예: 지미의 공방'),
                    const SizedBox(height: 14),
                    _label('사업자등록번호'),
                    const SizedBox(height: 6),
                    _inputBox(
                        controller: _businessNumberController,
                        hint: '000-00-00000',
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 14),
                    _label('대표자명'),
                    const SizedBox(height: 6),
                    _inputBox(controller: _ownerNameController, hint: '홍길동'),
                    const SizedBox(height: 14),
                    _label('연락처'),
                    const SizedBox(height: 6),
                    _inputBox(
                        controller: _phoneController,
                        hint: '010-0000-0000',
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 20),

                    _sectionTitle('📍 공방 위치'),
                    const SizedBox(height: 12),
                    _label('주소'),
                    const SizedBox(height: 6),
                    _inputBox(controller: _addressController, hint: '기본 주소'),
                    const SizedBox(height: 14),
                    _label('상세 주소'),
                    const SizedBox(height: 6),
                    _inputBox(controller: _detailAddressController, hint: '상세 주소 입력'),
                    const SizedBox(height: 20),

                    _sectionTitle('🎯 전문 분야'),
                    const SizedBox(height: 12),
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
                                  color: const Color(0xFF8A9485), width: 1),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontFamily: 'RebornFont',
                                fontSize: 16,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF1F402C),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    _label('소개글'),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      height: 110,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFF5C775E), width: 1),
                      ),
                      child: TextField(
                        controller: _introductionController,
                        maxLines: null,
                        expands: true,
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
                            fontSize: 14,
                            color: Color(0xFF9AA39A),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF87A676),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(
                                color: Color(0xFF6E8B64), width: 1),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text(
                                '저장하기',
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

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'RebornFont',
        fontSize: 20,
        color: Color(0xFF1F402C),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'RebornFont',
        fontSize: 16,
        color: Color(0xFF1F402C),
      ),
    );
  }

  Widget _inputBox({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E5C45), width: 1),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: 'RebornFont',
          fontSize: 15,
          color: Color(0xFF1F402C),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'RebornFont',
            fontSize: 15,
            color: Color(0xFF9AA39A),
          ),
        ),
      ),
    );
  }
}
