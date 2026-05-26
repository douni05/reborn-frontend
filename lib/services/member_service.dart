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
      await storage.save(); // 기기에 영구 저장

      return result;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '회원가입 중 오류가 발생했습니다');
    }
  }

  Future<void> updateNickname(String nickname) async {
    try {
      await _dio.patch(
        '/api/v1/members/nickname',
        data: {'nickname': nickname},
      );
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '닉네임 변경 중 오류가 발생했습니다');
    }
  }

  Future<void> updateTitle(String titleName) async {
    try {
      await _dio.patch(
        '/api/v1/members/title',
        data: {'titleName': titleName},
      );
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '칭호 변경 중 오류가 발생했습니다');
    }
  }

  Future<void> withdraw() async {
    try {
      await _dio.delete('/api/v1/members/me');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '탈퇴 중 오류가 발생했습니다');
    }
  }

  Future<void> updateFcmToken(String fcmToken) async {
    try {
      await _dio.patch(
        '/api/v1/members/fcm-token',
        data: {'fcmToken': fcmToken},
      );
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? 'FCM 토큰 저장 실패');
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      await _dio.get('/api/v1/members/check-email', queryParameters: {'email': email});
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return false;
      rethrow;
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
