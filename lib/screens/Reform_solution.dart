import 'package:flutter/material.dart';

class ReformSolutionScreen extends StatelessWidget {
  const ReformSolutionScreen({super.key});

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
                            '리폼 솔루션',
                            style: TextStyle(
                              fontFamily: 'RebornFont',
                              fontSize: 28,
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
                          fontSize: 14,
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
                          padding: const EdgeInsets.fromLTRB(22, 34, 22, 24),
                          child: Column(
                            children: [
                              _infoCard(
                                title: '분석 결과',
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4),
                                    Text(
                                      '재질 : 데님',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 16,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '상태 분석 결과 : 오염도 심하지 않음',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 16,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '업사이클링 가능 여부 : 좋아요!',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 16,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              _infoCard(
                                title: '청바지로 토트백 만들기',
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4),
                                    Text(
                                      '필요한 재료 : 헌청바지, 바늘과 실, 가위, 지퍼',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 16,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '작업 예상 시간 : 약 1시간 소요',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 16,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '예상 비용 : 없음',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 16,
                                        color: Color(0xFF1F402C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              _guideCard(),
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
                                    '전문가에게 도움받기',
                                    style: TextStyle(
                                      fontFamily: 'RebornFont',
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
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
                                    '리폼 완료 확인',
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

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3E5C45),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'RebornFont',
              fontSize: 24,
              color: Color(0xFF1F402C),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

Widget _infoCard({
  required String title,
  required Widget child,
}) {
  return _InfoCard(title: title, child: child);
}

Widget _guideCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
    decoration: BoxDecoration(
      color: const Color(0xFFF7F7F7),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFF3E5C45),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '단계별 가이드',
          style: TextStyle(
            fontFamily: 'RebornFont',
            fontSize: 24,
            color: Color(0xFF1F402C),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'step 1 청바지 다리 부분 자르기',
          style: TextStyle(
            fontFamily: 'RebornFont',
            fontSize: 16,
            color: Color(0xFF1F402C),
          ),
        ),
        const SizedBox(height: 150),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8FAED),
                    foregroundColor: const Color(0xFF1F402C),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(
                        color: Color(0xFF5C775E),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    '이전',
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 20,
                      color: Color(0xFF1F402C),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC8E0BC),
                    foregroundColor: const Color(0xFF1F402C),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(
                        color: Color(0xFF5C775E),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(
                      fontFamily: 'RebornFont',
                      fontSize: 20,
                      color: Color(0xFF1F402C),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}