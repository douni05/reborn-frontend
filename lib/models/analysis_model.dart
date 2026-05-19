class AnalysisResult {
  final int? analysisId;
  final String materialType;
  final String? conditionGrade;
  final bool? isReformable;

  // 리폼 가능할 때
  final int? planId;
  final String? reformTitle;
  final String? reformPlan;
  final String? difficulty;
  final String? materials;
  final String? estimatedTime;
  final String? estimatedCost;

  // 리폼 불가능할 때
  final String? disposalIcon;
  final String? disposalMethod;

  // 히스토리 표시용
  final String? createdAt;

  AnalysisResult({
    this.analysisId,
    required this.materialType,
    this.conditionGrade,
    this.isReformable,
    this.planId,
    this.reformTitle,
    this.reformPlan,
    this.difficulty,
    this.materials,
    this.estimatedTime,
    this.estimatedCost,
    this.disposalIcon,
    this.disposalMethod,
    this.createdAt,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      analysisId: json['analysisId'] as int?,
      materialType: json['materialType'] as String? ?? '알 수 없음',
      conditionGrade: json['conditionGrade'] as String?,
      isReformable: json['isReformable'] as bool?,
      planId: json['planId'] as int?,
      reformTitle: json['reformTitle'] as String?,
      reformPlan: json['reformPlan'] as String?,
      difficulty: json['difficulty'] as String?,
      materials: json['materials'] as String?,
      estimatedTime: json['estimatedTime'] as String?,
      estimatedCost: json['estimatedCost'] as String?,
      disposalIcon: json['disposalIcon'] as String?,
      disposalMethod: json['disposalMethod'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }
}
