import 'dart:ffi';

import 'package:dio/dio.dart';

class AnalysisService {
  // 에뮬레이터 → 로컬 Spring Boot 접근 주소
  static const String _baseUrl = 'http://10.0.2.2:8080';

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<AnalysisResult> analyze({
    required String label,
    required int userId,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/v1/analysis/$userId',
        data: {'label': label},
      );
      return AnalysisResult.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('서버 연결 실패: ${e.message}');
    }
  }
}

// 서버 응답 모델 (AnalysisResponseDto 구조 그대로)
class AnalysisResult {
  final Long? analysisId;
  final String materialType;
  final String? reformPlan;
  final bool? isReformable;

  AnalysisResult({
    this.analysisId,
    required this.materialType,
    this.reformPlan,
    this.isReformable,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      analysisId: json['analysisId'],
      materialType: json['materialType'] ?? '알 수 없음',
      reformPlan: json['reformPlan'],
      isReformable: json['isReformable'],
    );
  }
}