import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../core/storage/auth_storage.dart';
import '../models/member_model.dart';

class MemberService {
  final Dio _dio = ApiClient().dio;

  Future<JoinResponse> join({
    required String email,
    required String nickname,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/members/join',
        data: {'email': email, 'nickname': nickname, 'role': role},
      );
      final result = JoinResponse.fromJson(response.data);

      final storage = AuthStorage();
      storage.token = result.token;
      storage.userId = result.userId;
      storage.nickname = result.nickname;
      storage.totalXp = result.totalXp;
      storage.currentLevel = result.currentLevel;

      return result;
    } on DioException catch (e) {
      throw Exception('회원가입 실패: ${e.message}');
    }
  }

  Future<MemberProfile> getMyProfile() async {
    try {
      final response = await _dio.get('/api/v1/members/me');
      return MemberProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('프로필 조회 실패: ${e.message}');
    }
  }
}
