/// Model representing AI-powered meal plan analysis results
class AIAnalysisResult {
  /// Whether the meal plan aligns with the client's medical history
  final AlignmentCheck medicalHistoryAlignment;
  
  /// Contradictions found between the meal plan and health log
  final ContradictionCheck healthLogContradictions;
  
  /// High-level concerns or recommendations (2-3 items)
  final List<Recommendation> recommendations;
  
  /// Overall assessment summary
  final String summary;

  AIAnalysisResult({
    required this.medicalHistoryAlignment,
    required this.healthLogContradictions,
    required this.recommendations,
    required this.summary,
  });
}

/// Represents the alignment check with medical history
class AlignmentCheck {
  /// Whether the plan aligns well
  final bool isAligned;
  
  /// Explanation of the alignment or misalignment
  final String explanation;
  
  /// Specific areas that align well
  final List<String> strengths;
  
  /// Specific areas that need attention
  final List<String> concerns;

  AlignmentCheck({
    required this.isAligned,
    required this.explanation,
    required this.strengths,
    required this.concerns,
  });
}

/// Represents contradictions between the meal plan and health log
class ContradictionCheck {
  /// Whether contradictions were found
  final bool hasContradictions;
  
  /// Explanation of contradictions
  final String explanation;
  
  /// List of specific contradictions found
  final List<String> contradictions;
  
  /// Suggestions to resolve contradictions
  final List<String> suggestions;

  ContradictionCheck({
    required this.hasContradictions,
    required this.explanation,
    required this.contradictions,
    required this.suggestions,
  });
}

/// Represents a high-level recommendation
class Recommendation {
  /// Priority level (high, medium, low)
  final RecommendationPriority priority;
  
  /// Title of the recommendation
  final String title;
  
  /// Detailed description
  final String description;
  
  /// Actionable steps
  final List<String> actionableSteps;

  Recommendation({
    required this.priority,
    required this.title,
    required this.description,
    required this.actionableSteps,
  });
}

/// Priority levels for recommendations
enum RecommendationPriority {
  high,
  medium,
  low,
}

/// Extension to provide display properties for priority
extension RecommendationPriorityExtension on RecommendationPriority {
  String get displayName {
    switch (this) {
      case RecommendationPriority.high:
        return 'High Priority';
      case RecommendationPriority.medium:
        return 'Medium Priority';
      case RecommendationPriority.low:
        return 'Low Priority';
    }
  }
  
  String get emoji {
    switch (this) {
      case RecommendationPriority.high:
        return '🔴';
      case RecommendationPriority.medium:
        return '🟡';
      case RecommendationPriority.low:
        return '🟢';
    }
  }
}
