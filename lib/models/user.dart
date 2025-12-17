import 'user_role.dart';
import 'user_permission.dart';

/// Represents a user in the SIA Health system
class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? title; // Job title for internal users (e.g., "Senior Nutritionist")
  final String? department; // Department for internal users

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.title,
    this.department,
  });

  /// Create a sample nutritionist user for demonstration
  static User getSampleNutritionist() {
    return User(
      id: 'user_001',
      name: 'Dr. Anjali Kumar',
      email: 'anjali.kumar@siahealth.com',
      role: UserRole.nutritionist,
      title: 'Senior Nutritionist',
      department: 'Nutrition Services',
    );
  }

  /// Create a sample health coach user for demonstration
  static User getSampleHealthCoach() {
    return User(
      id: 'user_002',
      name: 'Priya Menon',
      email: 'priya.menon@siahealth.com',
      role: UserRole.healthCoach,
      title: 'Lead Health Coach',
      department: 'Client Success',
    );
  }

  /// Create a sample client user for demonstration
  static User getSampleClient() {
    return User(
      id: 'client_001',
      name: 'Priya Sharma',
      email: 'priya.sharma@example.com',
      role: UserRole.client,
    );
  }

  /// Check if user has permission to perform an action
  /// Uses type-safe UserPermission enum instead of string keys
  bool hasPermission(UserPermission permission) {
    switch (permission) {
      case UserPermission.editMealPlans:
        return role.canEditMealPlans;
      case UserPermission.reviewMealPlans:
        return role.canReviewMealPlans;
      case UserPermission.viewQualityChecks:
        return role.canViewQualityChecks;
      case UserPermission.viewAIInsights:
        return role.canViewAIInsights;
      case UserPermission.accessDashboard:
        return role.canAccessDashboard;
      case UserPermission.viewReviews:
        return role.canViewReviews;
      case UserPermission.escalateCases:
        return role.canEscalateCases;
    }
  }

  /// Get a formatted display name with title (for internal users)
  String get displayNameWithTitle {
    if (title != null && role.isInternalUser) {
      return '$name, $title';
    }
    return name;
  }
}
