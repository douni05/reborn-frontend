import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/expert_service.dart';
import '../services/reform_request_service.dart';
import '../services/analysis_service.dart';
import '../models/analysis_model.dart';

class ExpertConnectScreen extends StatefulWidget {
  const ExpertConnectScreen({super.key});

  @override
  State<ExpertConnectScreen> createState() => _ExpertConnectScreenState();
}

class _ExpertConnectScreenState extends State<ExpertConnectScreen> {
  final _expertService = ExpertService();
  final _searchController = TextEditingController();

  List<Map<String, dynamic>> _experts = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = '전체';
  bool _isMapView = false;

  final List<String> _categories = ['전체', '의류', '목재/가구', '금속', '플라스틱', '유리', '액세서리', '전자제품', '기타'];

  @override
  void initState() {
    super.initState();
    _loadExperts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadExperts() async {
    try {
      final data = await _expertService.getExperts();
      setState(() {
        _experts = data;
        _filtered = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _onSearch(String query) {
    _applyFilter();
  }

  void _applyFilter() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      _filtered = _experts.where((e) {
        final name = (e['shopName'] ?? '').toString().toLowerCase();
        final cat = (e['category'] ?? '').toString().toLowerCase();
        final addr = (e['address'] ?? '').toString().toLowerCase();
        final matchSearch = q.isEmpty || name.contains(q) || cat.contains(q) || addr.contains(q);
        final matchCat = _selectedCategory == '전체' || cat == _selectedCategory.toLowerCase();
        return matchSearch && matchCat;
      }).toList();
    });
  }

  Future<void> _onInquiryTap(Map<String, dynamic> expert) async {
    final shopId = expert['shopId'] as int;
    final hasActive = await ReformRequestService().hasActiveRequest(shopId);
    if (!mounted) return;
    if (hasActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이미 요청 중인 전문가예요 📬', style: TextStyle(fontFamily: 'RebornFont')),
          backgroundColor: Color(0xFF5C775E),
        ),
      );
      return;
    }
    _showInquiryBottomSheet(context, expert);
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      '전문가 연결',
                      style: TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 30,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      '내 주변의 리폼 전문가를 찾아보세요!',
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
                        child: Column(
                          children: [
                            // 검색창
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Color(0xFF8BA58A),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: _onSearch,
                                      style: const TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 16,
                                        color: Color(0xFF1F402C),
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '공방명, 카테고리, 지역 검색',
                                        hintStyle: TextStyle(
                                          fontFamily: 'RebornFont',
                                          fontSize: 16,
                                          color: Color(0xFF9CA39C),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // 카테고리 필터 칩
                            SizedBox(
                              height: 36,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                itemCount: _categories.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final cat = _categories[index];
                                  final isSelected = _selectedCategory == cat;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() => _selectedCategory = cat);
                                      _applyFilter();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFF87A676) : Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFF87A676) : const Color(0xFFB0C4A8),
                                        ),
                                      ),
                                      child: Text(
                                        cat,
                                        style: TextStyle(
                                          fontFamily: 'RebornFont',
                                          fontSize: 13,
                                          color: isSelected ? Colors.white : const Color(0xFF1F402C),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            // 목록 / 지도 토글
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _isMapView = false),
                                    child: Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: !_isMapView
                                            ? const Color(0xFF87A676)
                                            : Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        border: Border.all(color: const Color(0xFF87A676)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '목록',
                                          style: TextStyle(
                                            fontFamily: 'RebornFont',
                                            fontSize: 14,
                                            color: !_isMapView
                                                ? Colors.white
                                                : const Color(0xFF87A676),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _isMapView = true),
                                    child: Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: _isMapView
                                            ? const Color(0xFF87A676)
                                            : Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        border: Border.all(color: const Color(0xFF87A676)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '지도',
                                          style: TextStyle(
                                            fontFamily: 'RebornFont',
                                            fontSize: 14,
                                            color: _isMapView
                                                ? Colors.white
                                                : const Color(0xFF87A676),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF87A676),
                                      ),
                                    )
                                  : _error != null
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text('😥',
                                                  style: TextStyle(fontSize: 40)),
                                              const SizedBox(height: 12),
                                              Text(
                                                _error!,
                                                style: const TextStyle(
                                                  fontFamily: 'RebornFont',
                                                  fontSize: 15,
                                                  color: Color(0xFF6E7B6E),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 16),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isLoading = true;
                                                    _error = null;
                                                  });
                                                  _loadExperts();
                                                },
                                                child: const Text(
                                                  '다시 시도',
                                                  style: TextStyle(
                                                    fontFamily: 'RebornFont',
                                                    color: Color(0xFF87A676),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : _isMapView
                                          ? _buildMapView()
                                          : _filtered.isEmpty
                                              ? const Center(
                                                  child: Text(
                                                    '등록된 전문가가 없어요',
                                                    style: TextStyle(
                                                      fontFamily: 'RebornFont',
                                                      fontSize: 15,
                                                      color: Color(0xFF6E7B6E),
                                                    ),
                                                  ),
                                                )
                                              : RefreshIndicator(
                                                  color: const Color(0xFF87A676),
                                                  onRefresh: _loadExperts,
                                                  child: ListView.separated(
                                                    itemCount: _filtered.length,
                                                    separatorBuilder: (_, __) =>
                                                        const SizedBox(height: 14),
                                                    padding: const EdgeInsets.only(bottom: 20),
                                                    itemBuilder: (context, index) {
                                                      final expert = _filtered[index];
                                                      return _WorkshopCard(
                                                        expert: expert,
                                                        onInquiryTap: () => _onInquiryTap(expert),
                                                      );
                                                    },
                                                  ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    final mapExperts = _filtered
        .where((e) => e['latitude'] != null && e['longitude'] != null)
        .toList();

    // 지도 표시 가능한 전문가가 없으면 안내 문구
    if (mapExperts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🗺️', style: TextStyle(fontSize: 40)),
            SizedBox(height: 12),
            Text(
              '지도에 표시할 전문가가 없어요\n전문가가 위치를 등록하면 표시됩니다',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'RebornFont',
                fontSize: 14,
                color: Color(0xFF6E7B6E),
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    // 첫 번째 전문가 위치를 중심으로 설정
    final firstLat = (mapExperts.first['latitude'] as num).toDouble();
    final firstLon = (mapExperts.first['longitude'] as num).toDouble();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(firstLat, firstLon),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.jimmy.reborn.reborn_fe',
          ),
          MarkerLayer(
            markers: mapExperts.map((expert) {
              final lat = (expert['latitude'] as num).toDouble();
              final lon = (expert['longitude'] as num).toDouble();
              return Marker(
                point: LatLng(lat, lon),
                width: 44,
                height: 44,
                child: GestureDetector(
                  onTap: () => _showInquiryBottomSheet(context, expert),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3E5C45),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          expert['shopName'] ?? '',
                          style: const TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 9,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF87A676),
                        size: 28,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showInquiryBottomSheet(
      BuildContext context, Map<String, dynamic> expert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _InquiryBottomSheet(expert: expert),
    );
  }
}

class _WorkshopCard extends StatelessWidget {
  final Map<String, dynamic> expert;
  final VoidCallback onInquiryTap;

  const _WorkshopCard({
    required this.expert,
    required this.onInquiryTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = expert['imageUrl'] as String?;
    final shopName = expert['shopName'] ?? '공방';
    final category = expert['category'] ?? '';
    final address = expert['address'] ?? '';
    final introduction = expert['introduction'] ?? '';
    final avgRating = (expert['averageRating'] as num?)?.toDouble() ?? 0.0;
    final reviewCount = (expert['reviewCount'] as num?)?.toInt() ?? 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF3E5C45),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 영역
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 190,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder(),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return _imagePlaceholder();
                    },
                  )
                : _imagePlaceholder(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        shopName,
                        style: const TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 21,
                          color: Color(0xFF1F402C),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onInquiryTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF87A676),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '문의하기',
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
                if (avgRating > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Color(0xFFF5A623)),
                      const SizedBox(width: 3),
                      Text(
                        '${avgRating.toStringAsFixed(1)} ($reviewCount개)',
                        style: const TextStyle(fontFamily: 'RebornFont', fontSize: 12, color: Color(0xFF6E7B6E)),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.checkroom_outlined,
                        size: 16, color: Color(0xFF1F402C)),
                    const SizedBox(width: 6),
                    Text(
                      category,
                      style: const TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 14,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                    if (address.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: Color(0xFF6E7B6E)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 13,
                            color: Color(0xFF6E7B6E),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                if (introduction.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    introduction,
                    style: const TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 12,
                      color: Color(0xFF6E7B6E),
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 190,
      color: const Color(0xFFD9EACD),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.storefront_outlined, size: 48, color: Color(0xFF87A676)),
          SizedBox(height: 8),
          Text(
            '공방 사진 없음',
            style: TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 13,
              color: Color(0xFF6E8B64),
            ),
          ),
        ],
      ),
    );
  }
}

class _InquiryBottomSheet extends StatefulWidget {
  final Map<String, dynamic> expert;

  const _InquiryBottomSheet({required this.expert});

  @override
  State<_InquiryBottomSheet> createState() => _InquiryBottomSheetState();
}

class _InquiryBottomSheetState extends State<_InquiryBottomSheet> {
  String selectedDesign = '솔루션 받은 리폼 디자인을 선택하세요.';
  final TextEditingController requestController = TextEditingController();
  bool _isSending = false;
  List<String> _designOptions = ['솔루션 받은 리폼 디자인을 선택하세요.'];
  Map<String, AnalysisResult> _resultMap = {};
  AnalysisResult? _selectedResult;

  @override
  void initState() {
    super.initState();
    _loadDesignOptions();
  }

  Future<void> _loadDesignOptions() async {
    try {
      final history = await AnalysisService().getHistory();
      final map = <String, AnalysisResult>{};
      final titles = <String>[];
      for (final r in history) {
        if (r.isReformable == true && r.reformTitle != null && r.reformTitle!.isNotEmpty) {
          if (!map.containsKey(r.reformTitle)) {
            map[r.reformTitle!] = r;
            titles.add(r.reformTitle!);
          }
        }
      }
      if (mounted && titles.isNotEmpty) {
        setState(() {
          _resultMap = map;
          _designOptions = ['솔루션 받은 리폼 디자인을 선택하세요.', ...titles];
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final shopName = widget.expert['shopName'] ?? '공방';
    final category = widget.expert['category'] ?? '';
    final address = widget.expert['address'] ?? '';
    final detailAddress = widget.expert['detailAddress'] ?? '';
    final phone = widget.expert['phone'] ?? '';
    final imageUrl = widget.expert['imageUrl'] as String?;

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.65,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAED),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  shopName,
                                  style: const TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 28,
                                    color: Color(0xFF1F402C),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(Icons.close,
                                    size: 24, color: Color(0xFF1F402C)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (category.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.checkroom_outlined,
                                    size: 18, color: Color(0xFF1F402C)),
                                const SizedBox(width: 6),
                                Text(
                                  category,
                                  style: const TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 16,
                                    color: Color(0xFF1F402C),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 8),
                          if (address.isNotEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 18, color: Color(0xFF1F402C)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    detailAddress.isNotEmpty
                                        ? '$address $detailAddress'
                                        : address,
                                    style: const TextStyle(
                                      fontFamily: 'RebornFont',
                                      fontSize: 15,
                                      color: Color(0xFF1F402C),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (phone.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.phone_outlined,
                                    size: 18, color: Color(0xFF1F402C)),
                                const SizedBox(width: 6),
                                Text(
                                  phone,
                                  style: const TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 16,
                                    color: Color(0xFF1F402C),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    height: 136,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _sheetPlaceholder(),
                                  )
                                : _sheetPlaceholder(),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '디자인 시안 공유하기',
                            style: TextStyle(
                              fontFamily: 'RebornFont',
                              fontSize: 18,
                              color: Color(0xFF1F402C),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              final result =
                                  await showModalBottomSheet<String>(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => _DesignSelectSheet(
                                  selectedValue: selectedDesign,
                                  options: _designOptions,
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  selectedDesign = result;
                                  _selectedResult = _resultMap[result];
                                });
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCFE4C6),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: const Color(0xFF6E8B64), width: 1),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedDesign,
                                      style: const TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 15,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down,
                                      color: Color(0xFF1F402C), size: 24),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            '요청 내용',
                            style: TextStyle(
                              fontFamily: 'RebornFont',
                              fontSize: 18,
                              color: Color(0xFF1F402C),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 106,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: const Color(0xFF3E5C45), width: 1),
                            ),
                            child: TextField(
                              controller: requestController,
                              maxLines: null,
                              expands: true,
                              style: const TextStyle(
                                fontFamily: 'RebornFont',
                                fontSize: 15,
                                color: Color(0xFF1F402C),
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '제작하고 싶은 내용을 자세히 작성해주세요.',
                                hintStyle: TextStyle(
                                  fontFamily: 'RebornFont',
                                  fontSize: 14,
                                  color: Color(0xFF9AA39A),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                    color: const Color(0xFFF8FAED),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isSending ? null : () async {
                          if (requestController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('요청 내용을 입력해주세요', style: TextStyle(fontFamily: 'RebornFont'))),
                            );
                            return;
                          }
                          setState(() => _isSending = true);
                          try {
                            final shopId = widget.expert['shopId'] as int;
                            await ReformRequestService().createRequest(
                              shopId: shopId,
                              designTitle: selectedDesign == '솔루션 받은 리폼 디자인을 선택하세요.' ? '직접 요청' : selectedDesign,
                              requestContent: requestController.text.trim(),
                              planId: _selectedResult?.planId,
                              reformPlan: _selectedResult?.reformPlan,
                              difficulty: _selectedResult?.difficulty,
                              materials: _selectedResult?.materials,
                              estimatedTime: _selectedResult?.estimatedTime,
                              estimatedCost: _selectedResult?.estimatedCost,
                            );
                            if (!mounted) return;
                            Navigator.pop(context); // bottom sheet 닫기
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: const Color(0xFFF8FAED),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Text('요청 완료 ✅', style: TextStyle(fontFamily: 'RebornFont', fontSize: 20, color: Color(0xFF1F402C))),
                                content: const Text('전문가에게 요청이 전달됐어요!\n마이페이지 → 나의 요청 현황에서 확인할 수 있어요.', style: TextStyle(fontFamily: 'RebornFont', fontSize: 14, color: Color(0xFF33543C), height: 1.5)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('확인', style: TextStyle(fontFamily: 'RebornFont', color: Color(0xFF87A676))),
                                  ),
                                ],
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            setState(() => _isSending = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''), style: const TextStyle(fontFamily: 'RebornFont')), backgroundColor: const Color(0xFF5C3D2E)),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF87A676),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          '리폼 요청 보내기',
                          style: TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sheetPlaceholder() {
    return Container(
      width: double.infinity,
      height: 136,
      color: const Color(0xFFD9EACD),
      child: const Icon(Icons.storefront_outlined,
          size: 40, color: Color(0xFF87A676)),
    );
  }
}

class _DesignSelectSheet extends StatelessWidget {
  final String selectedValue;
  final List<String> options;
  const _DesignSelectSheet({required this.selectedValue, required this.options});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAED),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option == selectedValue;
          return GestureDetector(
            onTap: () => Navigator.pop(context, option),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFCFE4C6)
                    : const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFF6E8B64), width: 1),
              ),
              child: Text(
                option,
                style: const TextStyle(
                  fontFamily: 'RebornFont',
                  fontSize: 15,
                  color: Color(0xFF1F402C),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
