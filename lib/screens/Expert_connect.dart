import 'package:flutter/material.dart';

class ExpertConnectScreen extends StatelessWidget {
  const ExpertConnectScreen({super.key});

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
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Color(0xFF8BA58A),
                                    size: 24,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Search',
                                    style: TextStyle(
                                      fontFamily: 'RebornFont',
                                      fontSize: 16,
                                      color: Color(0xFF9CA39C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _WorkshopCard(
                                      imagePath: 'assets/icons/exg_workshop.png',
                                      title: '공방이름',
                                      distance: '1km',
                                      category: '의류',
                                      place: '액세서리',
                                      onInquiryTap: () {
                                        _showInquiryBottomSheet(context);
                                      },
                                    ),
                                    const SizedBox(height: 14),
                                    _WorkshopCard(
                                      imagePath: 'assets/icons/exg_workshop.png',
                                      title: '공방이름',
                                      distance: '1km',
                                      category: '가구',
                                      place: '',
                                      onInquiryTap: () {
                                        _showInquiryBottomSheet(context);
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                  ],
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
            SizedBox(
              height: 78,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 78,
                    color: const Color(0xFFD9EACD),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _BottomNavItem(
                          icon: Icons.home_outlined,
                          label: '홈',
                        ),
                        _BottomNavItem(
                          icon: Icons.build_outlined,
                          label: '리폼하기',
                        ),
                        SizedBox(width: 60),
                        _BottomNavItem(
                          icon: Icons.article_outlined,
                          label: '전문가연결',
                        ),
                        _BottomNavItem(
                          icon: Icons.person_outline,
                          label: '마이페이지',
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -8,
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA8C88E),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD9EACD),
                          width: 6,
                        ),
                      ),
                      child: const Icon(
                        Icons.recycling,
                        color: Colors.white,
                        size: 32,
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

  static void _showInquiryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _InquiryBottomSheet();
      },
    );
  }
}

class _WorkshopCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String distance;
  final String category;
  final String place;
  final VoidCallback onInquiryTap;

  const _WorkshopCard({
    required this.imagePath,
    required this.title,
    required this.distance,
    required this.category,
    required this.place,
    required this.onInquiryTap,
  });

  @override
  Widget build(BuildContext context) {
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 190,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 21,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      distance,
                      style: const TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 12,
                        color: Color(0xFF6E7B6E),
                      ),
                    ),
                    const Spacer(),
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/bag.png',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category,
                      style: const TextStyle(
                        fontFamily: 'RebornFont',
                        fontSize: 14,
                        color: Color(0xFF1F402C),
                      ),
                    ),
                    if (place.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        place,
                        style: const TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 14,
                          color: Color(0xFF1F402C),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '공방설명공방설명공방설명공방설명공방설명공방설명공방설명공방설명공방설명공방설명',
                  style: TextStyle(
                    fontFamily: 'RebornFont',
                    fontSize: 12,
                    color: Color(0xFF6E7B6E),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InquiryBottomSheet extends StatefulWidget {
  const _InquiryBottomSheet();

  @override
  State<_InquiryBottomSheet> createState() => _InquiryBottomSheetState();
}

class _InquiryBottomSheetState extends State<_InquiryBottomSheet> {
  String selectedDesign = '솔루션 받은 리폼 디자인을 선택하세요.';
  final TextEditingController requestController = TextEditingController();

  @override
  void dispose() {
    requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.65,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAED),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
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
                              const Expanded(
                                child: Text(
                                  '공방이름',
                                  style: TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 28,
                                    color: Color(0xFF1F402C),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 24,
                                  color: Color(0xFF1F402C),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(
                                Icons.checkroom_outlined,
                                size: 18,
                                color: Color(0xFF1F402C),
                              ),
                              SizedBox(width: 6),
                              Text(
                                '의류 | 액세서리',
                                style: TextStyle(
                                  fontFamily: 'RebornFont',
                                  fontSize: 16,
                                  color: Color(0xFF1F402C),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: Color(0xFF1F402C),
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'OO시 OO구 OO동 123-12',
                                  style: TextStyle(
                                    fontFamily: 'RebornFont',
                                    fontSize: 15,
                                    color: Color(0xFF1F402C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 24, top: 2),
                            child: Text(
                              'Google Maps에서 열기 >',
                              style: TextStyle(
                                fontFamily: 'RebornFont',
                                fontSize: 13,
                                color: Color(0xFF6E7B6E),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 18,
                                color: Color(0xFF1F402C),
                              ),
                              SizedBox(width: 6),
                              Text(
                                '010-0000-0000',
                                style: TextStyle(
                                  fontFamily: 'RebornFont',
                                  fontSize: 16,
                                  color: Color(0xFF1F402C),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/icons/exg_workshop.png',
                              width: double.infinity,
                              height: 136,
                              fit: BoxFit.cover,
                            ),
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
                              final result = await showModalBottomSheet<String>(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return _DesignSelectSheet(
                                    selectedValue: selectedDesign,
                                  );
                                },
                              );

                              if (result != null) {
                                setState(() {
                                  selectedDesign = result;
                                });
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCFE4C6),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFF6E8B64),
                                  width: 1,
                                ),
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
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF1F402C),
                                    size: 24,
                                  ),
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
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFF3E5C45),
                                width: 1,
                              ),
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
                        onPressed: () {},
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
}

class _DesignSelectSheet extends StatelessWidget {
  final String selectedValue;

  const _DesignSelectSheet({
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      '솔루션 받은 리폼 디자인을 선택하세요.',
      '청바지로 나만의 개성있는 가방 만들기',
      '병뚜껑으로 나만의 귀여운 키링 만들기',
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAED),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option == selectedValue;
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, option);
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFCFE4C6)
                    : const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF6E8B64),
                  width: 1,
                ),
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

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BottomNavItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: const Color(0xFF1F402C),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 11,
              color: Color(0xFF1F402C),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}