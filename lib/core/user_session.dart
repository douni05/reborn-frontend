// 소셜 로그인 구현 전 임시로 userId를 앱 메모리에 저장
class UserSession {
  static int userId = 1;
  static String nickname = '';

  static void init(int id, String name) {
    userId = id;
    nickname = name;
  }
}