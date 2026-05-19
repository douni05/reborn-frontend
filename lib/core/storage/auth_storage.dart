import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static final AuthStorage _instance = AuthStorage._internal();
  factory AuthStorage() => _instance;
  AuthStorage._internal();

  String? token;
  int? userId;
  String? nickname;
  int totalXp = 0;
  int currentLevel = 1;

  static const _keyToken = 'auth_token';
  static const _keyUserId = 'auth_user_id';
  static const _keyNickname = 'auth_nickname';
  static const _keyTotalXp = 'auth_total_xp';
  static const _keyCurrentLevel = 'auth_current_level';

  /// 로그인 후 호출: 모든 정보를 기기에 저장
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) await prefs.setString(_keyToken, token!);
    if (userId != null) await prefs.setInt(_keyUserId, userId!);
    if (nickname != null) await prefs.setString(_keyNickname, nickname!);
    await prefs.setInt(_keyTotalXp, totalXp);
    await prefs.setInt(_keyCurrentLevel, currentLevel);
  }

  /// 앱 시작 시 호출: 저장된 로그인 정보 복원
  Future<bool> load() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_keyToken);
    userId = prefs.getInt(_keyUserId);
    nickname = prefs.getString(_keyNickname);
    totalXp = prefs.getInt(_keyTotalXp) ?? 0;
    currentLevel = prefs.getInt(_keyCurrentLevel) ?? 1;
    return token != null;
  }

  /// 로그아웃/탈퇴 시 호출: 저장된 정보 전부 삭제
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyNickname);
    await prefs.remove(_keyTotalXp);
    await prefs.remove(_keyCurrentLevel);
    token = null;
    userId = null;
    nickname = null;
    totalXp = 0;
    currentLevel = 1;
  }
}
