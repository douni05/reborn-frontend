import 'package:flutter/material.dart';
import 'Reform_solution.dart';

class AICameraResultScreen extends StatelessWidget {
  const AICameraResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EACD),

      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReformSolutionScreen(),
            ),
          );
        },

        child: SafeArea(
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
                              'AI 카메라 분석',
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
                                Container(
                                  width: double.infinity,
                                  height: 258,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: const Color(0xFF3E5C45),
                                      width: 1,
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.asset(
                                    'assets/icons/pants.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                SizedBox(
                                  width: 240,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      const Color(0xFF87A676),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      '사진 다시 찍기',
                                      style: TextStyle(
                                        fontFamily: 'RebornFont',
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.fromLTRB(
                                      14, 14, 14, 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F7F7),
                                    borderRadius:
                                    BorderRadius.circular(16),
                                    border: Border.all(
                                      color:
                                      const Color(0xFF3E5C45),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '분석 결과',
                                        style: TextStyle(
                                          fontFamily: 'RebornFont',
                                          fontSize: 22,
                                          color: Color(0xFF1F402C),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '재질 : 데님',
                                        style: TextStyle(
                                          fontFamily: 'RebornFont',
                                          fontSize: 16,
                                          color: Color(0xFF1F402C),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        '상태 분석 결과 : 오염도 심하지 않음',
                                        style: TextStyle(
                                          fontFamily: 'RebornFont',
                                          fontSize: 16,
                                          color: Color(0xFF1F402C),
                                        ),
                                      ),
                                      SizedBox(height: 6),
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
      ),
    );
  }
}