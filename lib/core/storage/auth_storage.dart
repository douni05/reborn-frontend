class AuthStorage {
  static final AuthStorage _instance = AuthStorage._internal();
  factory AuthStorage() => _instance;
  AuthStorage._internal();

  String? token;
  int? userId;
  String? nickname;
  int totalXp = 0;
  int currentLevel = 1;
}
