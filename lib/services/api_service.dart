import 'package:dio/dio.dart';

class ApiService {
  // static const String baseUrl = 'http://10.0.2.2:8080';
  static const String baseUrl = 'http://192.168.55.129:8080';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  // ── 회원 ──────────────────────────────────────────
  Future<Map<String, dynamic>> join(String nickname) async {
    final res = await _dio.post('/api/members/join', data: {
      'email': '$nickname@reborn.com', // 소셜 로그인 전 임시
      'nickname': nickname,
      'role': 'USER',
    });
    return res.data;
  }

  Future<Map<String, dynamic>> getProfile(int userId) async {
    final res = await _dio.get('/api/members/$userId');
    return res.data;
  }

  // ── 분석 ───
  // ───────────────────────────────────────
  Future<Map<String, dynamic>> analyze(String label, int userId) async {
    final res = await _dio.post('/api/v1/analysis/$userId',
        data: {'label': label});
    return res.data;
  }

  Future<List<dynamic>> getHistory(int userId) async {
    final res = await _dio.get('/api/v1/analysis/history/$userId');
    return res.data;
  }

  // ── 액션 (XP) ─────────────────────────────────────
  Future<void> completeReform(int userId) async {
    await _dio.post('/api/v1/action/reform/$userId');
  }

  Future<void> completeDisposal(int userId) async {
    await _dio.post('/api/v1/action/disposal/$userId');
  }
}