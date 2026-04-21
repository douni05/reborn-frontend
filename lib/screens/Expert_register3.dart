import 'package:flutter/material.dart';
import 'Expert_register2.dart';

class ExpertRegister3Screen extends StatefulWidget {
  const ExpertRegister3Screen({super.key});

  @override
  State<ExpertRegister3Screen> createState() => _ExpertRegister3ScreenState();
}

class _ExpertRegister3ScreenState extends State<ExpertRegister3Screen> {
  String selectedField = '의류';

  final List<String> fields = [
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
                          Text(
                            '🎯',
                            style: TextStyle(fontSize: 20),
                          ),
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
                        itemCount: fields.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 2.55,
                        ),
                        itemBuilder: (context, index) {
                          final field = fields[index];
                          final isSelected = selectedField == field;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedField = field;
                              });
                            },
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
                                field,
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
                            color: const Color(0xFF5C775E),
                            width: 1,
                          ),
                        ),
                        child: const TextField(
                          maxLines: null,
                          expands: true,
                          style: TextStyle(
                            fontFamily: 'RebornFont',
                            fontSize: 15,
                            color: Color(0xFF1F402C),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                            '공방 소개 및 작업 가능한 내용을 자유롭게 작성해주세요.',
                            hintStyle: TextStyle(
                              fontFamily: 'RebornFont',
                              fontSize: 15,
                              color: Color(0xFF9AA39A),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const ExpertRegister2Screen(),
                                    ),
                                  );
                                },
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
            const _BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      width: double.infinity,
      color: const Color(0xFFD9EACD),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _BottomNavItem(icon: Icons.home_outlined, label: '홈'),
              _BottomNavItem(icon: Icons.build_outlined, label: '리폼하기'),
              SizedBox(width: 60),
              _BottomNavItem(icon: Icons.article_outlined, label: '전문가연결'),
              _BottomNavItem(icon: Icons.person_outline, label: '마이페이지'),
            ],
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
          Icon(icon, size: 24, color: const Color(0xFF1F402C)),
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