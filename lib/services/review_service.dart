import 'package:dio/dio.dart';
import '../core/network/api_client.dart';

class ReviewService {
  final Dio _dio = ApiClient().dio;

  Future<void> createReview({
    required int requestId,
    required int shopId,
    required int rating,
    required String content,
  }) async {
    try {
      await _dio.post('/api/v1/reviews', data: {
        'requestId': requestId,
        'shopId': shopId,
        'rating': rating,
        'content': content,
      });
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '리뷰 작성 중 오류가 발생했습니다');
    }
  }

  Future<Map<String, dynamic>> getShopReviews(int shopId) async {
    try {
      final response = await _dio.get('/api/v1/reviews/shop/$shopId');
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '리뷰를 불러올 수 없습니다');
    }
  }

  Future<bool> hasReview(int requestId) async {
    try {
      final response = await _dio.get('/api/v1/reviews/check/$requestId');
      return response.data['hasReview'] as bool? ?? false;
    } catch (_) {
      return false;
    }
  }
}
