const List<int> levelThresholds = [
  0, 50, 110, 180, 260, 360, 470, 590, 720, 870,
  1000, 1150, 1350, 1500, 1700, 1950, 2150, 2350, 2550, 2750,
  2950, 3150, 3350, 3550, 3750, 3950, 4150, 4350, 4500, 5000,
  5600, 5800, 6000, 6200, 6400, 6600, 6800, 7000, 7200, 7400,
  7600, 7800, 8000, 8200, 8400, 8600, 8800, 9000, 9200, 10000,
];

String getTitleEmoji(String title) {
  switch (title) {
    case '주니어 리포머':   return '♻️';
    case '프로 환경러':     return '🌿';
    case '에코 마스터':     return '🌍';
    case '지구 수호자':     return '🏆';
    case '맥가이버':        return '⚒️';
    case '패션 아이콘':     return '🏆';
    case '공방 단골손님':   return '🤝';
    case '분리배출의 신':   return '📍';
    default:               return '🌱';
  }
}

String getTitleForLevel(int level) {
  if (level >= 50) return '지구 수호자';
  if (level >= 31) return '에코 마스터';
  if (level >= 16) return '프로 환경러';
  if (level >= 6)  return '주니어 리포머';
  return '새싹 지구 지킴이';
}

double calcXpProgress(int totalXp, int currentLevel) {
  final level = currentLevel - 1;
  if (level >= levelThresholds.length - 1) return 1.0;
  final current = levelThresholds[level];
  final next = levelThresholds[level + 1];
  return ((totalXp - current) / (next - current)).clamp(0.0, 1.0);
}

String calcXpLabel(int totalXp, int currentLevel) {
  final level = currentLevel - 1;
  if (level >= levelThresholds.length - 1) return '$totalXp / MAX';
  final current = levelThresholds[level];
  final next = levelThresholds[level + 1];
  return '${totalXp - current} / ${next - current}';
}
