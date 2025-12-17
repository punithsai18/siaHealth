/// Enum representing the different user roles in the SIA Health system
enum UserRole {
  /// Client (End User) - Women receiving care for PCOS, thyroid, cycle health
  /// - Provides health history and daily health logs
  /// - Does NOT interact with this tool directly
  /// - Read-only access to their own data
  client,

  /// Nutritionist (Internal User) - Primary content creator
  /// - Creates meal plans
  /// - Updates or revises plans based on feedback
  /// - Full edit capabilities for meal plans
  nutritionist,

  /// Health Coach (Internal User) - Reviews client progress
  /// - Reviews client progress
  /// - Uses QC results + AI insights
  /// - Makes decisions or escalates issues
  /// - Review and approval capabilities but not meal plan editing
  healthCoach,
}

/// Extension to provide user-friendly names and descriptions for each role
extension UserRoleExtension on UserRole {
  /// Get the display name for the role
  String get displayName {
    switch (this) {
      case UserRole.client:
        return 'Client';
      case UserRole.nutritionist:
        return 'Nutritionist';
      case UserRole.healthCoach:
        return 'Health Coach';
    }
  }

  /// Get a description of the role's responsibilities
  String get description {
    switch (this) {
      case UserRole.client:
        return 'Women receiving care for PCOS, thyroid, cycle health';
      case UserRole.nutritionist:
        return 'Creates and updates personalized meal plans';
      case UserRole.healthCoach:
        return 'Reviews client progress and makes decisions';
    }
  }

  /// Check if this role has permission to create/edit meal plans
  bool get canEditMealPlans {
    return this == UserRole.nutritionist;
  }

  /// Check if this role has permission to approve meal plans for client delivery
  /// Only Health Coaches can make the final decision to approve plans
  /// Note: This is different from viewing reviews - see canViewReviews
  bool get canReviewMealPlans {
    return this == UserRole.healthCoach;
  }
  
  /// Check if this role has permission to view meal plan review feedback
  /// Both Nutritionists and Health Coaches can read review comments
  /// Nutritionists need this to see feedback and make revisions
  /// Health Coaches need this to track review history
  bool get canViewReviews {
    return this == UserRole.healthCoach || this == UserRole.nutritionist;
  }

  /// Check if this role has permission to view quality check results
  bool get canViewQualityChecks {
    return this == UserRole.healthCoach || this == UserRole.nutritionist;
  }

  /// Check if this role has permission to view AI insights
  bool get canViewAIInsights {
    return this == UserRole.healthCoach;
  }

  /// Check if this role is an internal user (not a client)
  bool get isInternalUser {
    return this == UserRole.nutritionist || this == UserRole.healthCoach;
  }

  /// Check if this role can access the internal dashboard
  bool get canAccessDashboard {
    return isInternalUser;
  }

  /// Check if this role has permission to escalate complex cases
  /// Only Health Coaches can escalate cases to senior staff or medical team
  bool get canEscalateCases {
    return this == UserRole.healthCoach;
  }
}
