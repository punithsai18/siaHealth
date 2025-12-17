/// Enum representing the different permissions in the SIA Health system
/// This provides type-safe permission checking and avoids string-based keys
enum UserPermission {
  /// Permission to create and edit meal plans
  editMealPlans,

  /// Permission to review and approve meal plans
  reviewMealPlans,

  /// Permission to view quality check results
  viewQualityChecks,

  /// Permission to view AI-powered insights
  viewAIInsights,

  /// Permission to access the internal dashboard
  accessDashboard,

  /// Permission to view review feedback
  viewReviews,

  /// Permission to escalate cases to senior staff
  escalateCases,
}
