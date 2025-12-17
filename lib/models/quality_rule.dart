class QualityRule {
  final String id;
  final int ruleNumber;
  final String title;
  final String description;
  final List<String> criteria;
  final List<String> appliesTo;
  final bool isActive;
  final bool isCustom;

  QualityRule({
    required this.id,
    required this.ruleNumber,
    required this.title,
    required this.description,
    required this.criteria,
    required this.appliesTo,
    this.isActive = true,
    this.isCustom = false,
  });

  QualityRule copyWith({
    String? id,
    int? ruleNumber,
    String? title,
    String? description,
    List<String>? criteria,
    List<String>? appliesTo,
    bool? isActive,
    bool? isCustom,
  }) {
    return QualityRule(
      id: id ?? this.id,
      ruleNumber: ruleNumber ?? this.ruleNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      criteria: criteria ?? this.criteria,
      appliesTo: appliesTo ?? this.appliesTo,
      isActive: isActive ?? this.isActive,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
