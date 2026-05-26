import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';

class ActionService {
  final Dio _dio = ApiClient().dio;

  /// 분리배출 완료 → 50 XP
  Future<Map<String, dynamic>> completeDisposal({int? analysisId}) async {
    try {
      final response = await _dio.post(
        '/api/v1/action/disposal',
        data: analysisId != null ? {'analysisId': analysisId} : {},
      );
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception('배출 완료 처리 실패: ${e.message}');
    }
  }

  /// DIY 리폼 완료 사진 검증 → 통과 시 100 XP
  Future<Map<String, dynamic>> verifyReform({
    required String imagePath,
    String label = '',
    int? analysisId,
  }) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final imageBase64 = base64Encode(bytes);
      final response = await _dio.post(
        '/api/v1/action/reform-verify',
        data: {
          'imageBase64': imageBase64,
          'label': label,
          if (analysisId != null) 'analysisId': analysisId.toString(),
        },
      );
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception('리폼 검증 실패: ${e.message}');
    }
  }
}
