class JoinResponse {
  final String token;
  final int userId;
  final String nickname;
  final int totalXp;
  final int currentLevel;

  JoinResponse({
    required this.token,
    required this.userId,
    required this.nickname,
    required this.totalXp,
    required this.currentLevel,
  });

  factory JoinResponse.fromJson(Map<String, dynamic> json) {
    return JoinResponse(
      token: json['token'] as String,
      userId: json['userId'] as int,
      nickname: json['nickname'] as String,
      totalXp: json['totalXp'] as int? ?? 0,
      currentLevel: json['currentLevel'] as int? ?? 1,
    );
  }
}

class MemberProfile {
  final int userId;
  final String nickname;
  final int totalXp;
  final int currentLevel;
  final int totalReformCount;
  final int totalDisposalCount;
  final int expertConnectionCount;
  final String? titleName;
  final List<String> unlockedTitles;

  MemberProfile({
    required this.userId,
    required this.nickname,
    required this.totalXp,
    required this.currentLevel,
    required this.totalReformCount,
    required this.totalDisposalCount,
    required this.expertConnectionCount,
    this.titleName,
    this.unlockedTitles = const [],
  });

  factory MemberProfile.fromJson(Map<String, dynamic> json) {
    final achievements = (json['achievements'] as List<dynamic>? ?? []);
    final titles = achievements
        .map((a) => a['titleName'] as String? ?? '')
        .where((t) => t.isNotEmpty)
        .toList();

    return MemberProfile(
      userId: json['userId'] as int,
      nickname: json['nickname'] as String,
      totalXp: json['totalXp'] as int? ?? 0,
      currentLevel: json['currentLevel'] as int? ?? 1,
      totalReformCount: json['totalReformCount'] as int? ?? 0,
      totalDisposalCount: json['totalDisposalCount'] as int? ?? 0,
      expertConnectionCount: json['expertConnectionCount'] as int? ?? 0,
      titleName: json['titleName'] as String?,
      unlockedTitles: titles,
    );
  }
}
