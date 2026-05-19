import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'Expert_register3.dart';

class ExpertRegister2Screen extends StatefulWidget {
  final String shopName;
  final String businessNumber;
  final String ownerName;
  final String phone;
  final File? imageFile;

  const ExpertRegister2Screen({
    super.key,
    required this.shopName,
    required this.businessNumber,
    required this.ownerName,
    required this.phone,
    this.imageFile,
  });

  @override
  State<ExpertRegister2Screen> createState() => _ExpertRegister2ScreenState();
}

class _ExpertRegister2ScreenState extends State<ExpertRegister2Screen> {
  final _addressController = TextEditingController();
  final _detailAddressController = TextEditingController();

  String? _addressError;
  String? _detailAddressError;
  bool _isGeocoding = false;

  @override
  void dispose() {
    _addressController.dispose();
    _detailAddressController.dispose();
    super.dispose();
  }

  /// Nominatim(OpenStreetMap) 무료 지오코딩 API로 주소 → 위경도 변환
  Future<(double?, double?)> _geocodeAddress(String address) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': address,
          'format': 'json',
          'limit': 1,
          'countrycodes': 'kr',
        },
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

  Future<void> _goNext() async {
    setState(() {
      _addressError =
          _addressController.text.trim().isEmpty ? '주소를 입력해주세요' : null;
      _detailAddressError = _detailAddressController.text.trim().isEmpty
          ? '상세 주소를 입력해주세요'
          : null;
    });

    if (_addressError != null || _detailAddressError != null) return;

    setState(() => _isGeocoding = true);
    final (lat, lon) = await _geocodeAddress(_addressController.text.trim());
    if (!mounted) return;
    setState(() => _isGeocoding = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpertRegister3Screen(
          shopName: widget.shopName,
          businessNumber: widget.businessNumber,
          ownerName: widget.ownerName,
          phone: widget.phone,
          address: _addressController.text.trim(),
          detailAddress: _detailAddressController.text.trim(),
          imageFile: widget.imageFile,
          latitude: lat,
          longitude: lon,
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
                        Text('📍', style: TextStyle(fontSize: 22)),
                        SizedBox(width: 8),
                        Text(
                          '공방위치',
                          style: TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 28,
                            color: Color(0xFF1F402C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _label('주소'),
                    const SizedBox(height: 8),
                    _inputBox(
                      controller: _addressController,
                      hint: '기본 주소',
                      error: _addressError,
                      onChanged: (_) => setState(() => _addressError = null),
                    ),
                    const SizedBox(height: 18),
                    _label('상세 주소'),
                    const SizedBox(height: 8),
                    _inputBox(
                      controller: _detailAddressController,
                      hint: '상세 주소 입력',
                      error: _detailAddressError,
                      onChanged: (_) =>
                          setState(() => _detailAddressError = null),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isGeocoding
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
                                      color: Color(0xFF8A9E80), width: 1),
                                ),
                              ),
                              child: const Text(
                                '이전',
                                style: TextStyle(
                                  fontFamily: 'RebornFont',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isGeocoding ? null : _goNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF87A676),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: const BorderSide(
                                      color: Color(0xFF6E8B64), width: 1),
                                ),
                              ),
                              child: _isGeocoding
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      '다음단계',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 20,
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
