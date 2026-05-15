import 'package:dio/dio.dart';
import '../core/network/api_client.dart';

class ReformRequestService {
  final Dio _dio = ApiClient().dio;

  Future<void> createRequest({
    required int shopId,
    required String designTitle,
    required String requestContent,
  }) async {
    try {
      await _dio.post('/api/v1/reform-requests', data: {
        'shopId': shopId,
        'designTitle': designTitle,
        'requestContent': requestContent,
      });
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '요청 전송 중 오류가 발생했습니다');
    }
  }

  Future<List<Map<String, dynamic>>> getMyRequests() async {
    try {
      final response = await _dio.get('/api/v1/reform-requests/my');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '요청 목록을 불러올 수 없습니다');
    }
  }

  Future<List<Map<String, dynamic>>> getExpertRequests() async {
    try {
      final response = await _dio.get('/api/v1/reform-requests/expert');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '요청 목록을 불러올 수 없습니다');
    }
  }

  Future<void> acceptRequest(int requestId, String message) async {
    try {
      await _dio.put('/api/v1/reform-requests/$requestId/accept',
          data: {'message': message});
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '수락 처리 중 오류가 발생했습니다');
    }
  }

  Future<void> rejectRequest(int requestId, String message) async {
    try {
      await _dio.put('/api/v1/reform-requests/$requestId/reject',
          data: {'message': message});
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '거절 처리 중 오류가 발생했습니다');
    }
  }

  Future<void> completeRequest(int requestId) async {
    try {
      await _dio.put('/api/v1/reform-requests/$requestId/complete');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '완료 처리 중 오류가 발생했습니다');
    }
  }

  Future<bool> hasActiveRequest(int shopId) async {
    try {
      final response = await _dio.get('/api/v1/reform-requests/active', queryParameters: {'shopId': shopId});
      return response.data['hasActive'] as bool? ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> cancelRequest(int requestId) async {
    try {
      await _dio.put('/api/v1/reform-requests/$requestId/cancel');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '취소 처리 중 오류가 발생했습니다');
    }
  }
}
