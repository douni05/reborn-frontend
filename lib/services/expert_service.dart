import 'dart:io';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';

const _supabaseUrl = 'https://hxtdbbwfknqncekqdggq.supabase.co';
const _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh4dGRiYndma25xbmNla3FkZ2dxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ5MjMyMDEsImV4cCI6MjA5MDQ5OTIwMX0.LriIuxbH3KReHVhoLheIS_b5Gxlhp-bt742DR0Qmj3g';

class ExpertService {
  final Dio _dio = ApiClient().dio;
  final Dio _storageDio = Dio(BaseOptions(
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  /// 이미지를 Supabase Storage에 업로드하고 public URL 반환
  Future<String> uploadImage(File imageFile) async {
    final filename = 'shop_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final bytes = await imageFile.readAsBytes();

    await _storageDio.post(
      '$_supabaseUrl/storage/v1/object/expert-images/$filename',
      data: bytes,
      options: Options(
        contentType: 'image/jpeg',
        headers: {
          'Authorization': 'Bearer $_supabaseAnonKey',
          'x-upsert': 'true',
        },
      ),
    );

    return '$_supabaseUrl/storage/v1/object/public/expert-images/$filename';
  }

  Future<void> register({
    required String shopName,
    required String businessNumber,
    required String ownerName,
    required String phone,
    required String address,
    required String detailAddress,
    required String category,
    required String introduction,
    String? imageUrl,
    double? latitude,
    double? longitude,
  }) async {
    try {
      await _dio.post('/api/v1/experts/register', data: {
        'shopName': shopName,
        'businessNumber': businessNumber,
        'ownerName': ownerName,
        'phone': phone,
        'address': address,
        'detailAddress': detailAddress,
        'category': category,
        'introduction': introduction,
        'imageUrl': imageUrl,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      });
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '전문가 등록 중 오류가 발생했습니다');
    }
  }

  Future<bool> isExpert() async {
    try {
      final response = await _dio.get('/api/v1/experts/me');
      return response.data['isExpert'] as bool? ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getExperts() async {
    try {
      final response = await _dio.get('/api/v1/experts');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '전문가 목록을 불러올 수 없습니다');
    }
  }

  Future<Map<String, dynamic>> getMyExpert() async {
    try {
      final response = await _dio.get('/api/v1/experts/my-info');
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '전문가 정보를 불러올 수 없습니다');
    }
  }

  Future<void> updateExpert({
    required String shopName,
    required String businessNumber,
    required String ownerName,
    required String phone,
    required String address,
    required String detailAddress,
    required String category,
    required String introduction,
    String? imageUrl,
    double? latitude,
    double? longitude,
  }) async {
    try {
      await _dio.put('/api/v1/experts/my-info', data: {
        'shopName': shopName,
        'businessNumber': businessNumber,
        'ownerName': ownerName,
        'phone': phone,
        'address': address,
        'detailAddress': detailAddress,
        'category': category,
        'introduction': introduction,
        'imageUrl': imageUrl,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      });
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '전문가 정보 수정 중 오류가 발생했습니다');
    }
  }

  Future<void> deleteExpert() async {
    try {
      await _dio.delete('/api/v1/experts/my-info');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String?;
      throw Exception(msg ?? '전문가 등록 취소 중 오류가 발생했습니다');
    }
  }
}
