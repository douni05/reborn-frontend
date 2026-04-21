import 'package:flutter/material.dart';

class SmartDisposalSolutionScreen extends StatelessWidget {
  const SmartDisposalSolutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EACD),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFD9EACD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Color(0xFF1F402C),
                              size: 24,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '스마트 배출 솔루션',
                            style: TextStyle(
                              fontFamily: 'RebornFont',
                              fontSize: 24,
                              color: Color(0xFF1F402C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 54, top: 4),
                      child: Text(
                        '물건을 촬영하면 업사이클링 가능 여부를 분석해줘요!',
                        style: TextStyle(
                          fontFamily: 'RebornFont',
                          fontSize: 13,
                          color: Color(0xFF33543C),
                        ),
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
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
                          child: Column(
                            children: [
                              _sectionCard(
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '분석 결과',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 22,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      '재질 : 데님',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 15,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '상태 분석 결과 : 오염도 심함',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 15,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '업사이클링 가능 여부 : 나빠요..',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 15,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              _sectionCard(
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '⚠️ 배출 전 체크리스트:',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 16,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '1. 오염확인 : 페인트, 기름 음식물 등으로 심하게 오염된 의류는 재활용이 불가능합니다.',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 14,
                                        height: 1.45,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '2. 부속품 제거 : 금속단추나 플라스틱 지퍼가 있다면 분리하여 배출하는 것이 좋습니다.',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 14,
                                        height: 1.45,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '3. 배출방법 : 이 옷은 재사용이 어렵기 때문에 종량제 봉투에 담아 배출해주세요.',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 14,
                                        height: 1.45,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              _sectionCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '내 주변 배출 장소',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 22,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    _placeItem(
                                      name: '서울시 재활용 센터',
                                      distance: '0.5KM',
                                    ),
                                    const SizedBox(height: 10),
                                    _placeItem(
                                      name: '헌옷 수거함',
                                      distance: '0.7KM',
                                    ),
                                    const SizedBox(height: 10),
                                    _placeItem(
                                      name: '헌옷 수거함',
                                      distance: '0.7KM',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
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
                                      side: const BorderSide(
                                        color: Color(0xFF6E8B64),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    '스마트 배출 확인',
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
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 34,
              color: const Color(0xFFF8FAED),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3E5C45),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

Widget _sectionCard({required Widget child}) {
  return _SectionCard(child: child);
}

Widget _placeItem({
  required String name,
  required String distance,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      color: const Color(0xFFEFEFDF),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFF6E8B64),
        width: 1,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'RebornFont',
            fontSize: 15,
            color: Color(0xFF1F402C),
          ),
        ),
        Text(
          distance,
          style: const TextStyle(
            fontFamily: 'RebornFont',
            fontSize: 15,
            color: Color(0xFF1F402C),
          ),
        ),
      ],
    ),
  );
}