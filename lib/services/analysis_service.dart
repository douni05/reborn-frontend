import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/analysis_model.dart';

class AnalysisService {
  final Dio _dio = ApiClient().dio;

  Future<AnalysisResult> analyze({
    required String label,
    String? imagePath,
  }) async {
    try {
      String? imageBase64;
      if (imagePath != null && imagePath.isNotEmpty) {
        final bytes = await File(imagePath).readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      final response = await _dio.post(
        '/api/v1/analysis',
        data: {
          'label': label,
          if (imageBase64 != null) 'imageBase64': imageBase64,
        },
      );
      return AnalysisResult.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('분석 실패: ${e.message}');
    }
  }

  Future<List<AnalysisResult>> getHistory() async {
    try {
      final response = await _dio.get('/api/v1/analysis/history');
      return (response.data as List)
          .map((e) => AnalysisResult.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception('분석 내역 조회 실패: ${e.message}');
    }
  }

  Future<AnalysisResult> getDetail(int analysisId) async {
    try {
      final response = await _dio.get('/api/v1/analysis/$analysisId');
      return AnalysisResult.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('분석 상세 조회 실패: ${e.message}');
    }
  }
}
