import '../models/meal_item.dart';
import '../models/quality_check.dart';

class QualityCheckService {
  // Protein thresholds (grams per main meal)
  static const double proteinOptimalMin = 10.0;
  static const double proteinOptimalMax = 14.0;
  static const double proteinWarningMin = 8.0;
  static const double proteinWarningMax = 20.0;

  // Carb thresholds for PCOS management (grams per main meal)
  static const double lowCarbThreshold = 30.0;
  static const double moderateCarbThreshold = 45.0;

  /// Check 1: Protein Check (10-14g in breakfast, lunch, dinner)
  static QualityCheckResult checkProteinContent(MealPlan mealPlan) {
    List<String> details = [];
    int passCount = 0;
    int failCount = 0;
    int warningCount = 0;

    // Check main meals (Breakfast, Lunch, Dinner)
    for (var meal in mealPlan.meals) {
      if (meal.type == "Breakfast" ||
          meal.type == "Lunch" ||
          meal.type == "Dinner") {
        double protein = meal.totalProtein;

        if (protein >= proteinOptimalMin && protein <= proteinOptimalMax) {
          passCount++;
          details.add("✓ ${meal.type}: ${protein.toStringAsFixed(1)}g protein (optimal)");
        } else if (protein >= proteinWarningMin && protein < proteinOptimalMin) {
          warningCount++;
          details.add("⚠ ${meal.type}: ${protein.toStringAsFixed(1)}g protein (slightly low, aim for $proteinOptimalMin-${proteinOptimalMax}g)");
        } else if (protein > proteinOptimalMax && protein <= proteinWarningMax) {
          warningCount++;
          details.add("⚠ ${meal.type}: ${protein.toStringAsFixed(1)}g protein (slightly high, aim for $proteinOptimalMin-${proteinOptimalMax}g)");
        } else {
          failCount++;
          details.add("✗ ${meal.type}: ${protein.toStringAsFixed(1)}g protein (outside range, needs adjustment)");
        }
      }
    }

    // Determine overall status
    CheckStatus status;
    String feedback;

    if (failCount == 0 && warningCount == 0) {
      status = CheckStatus.ok;
      feedback = "All main meals have optimal protein content (10-14g). Good for satiety and muscle maintenance.";
    } else if (failCount == 0) {
      status = CheckStatus.warning;
      feedback = "Most meals are close to target, but $warningCount meal(s) could be adjusted for optimal protein balance.";
    } else {
      status = CheckStatus.needsImprovement;
      feedback = "$failCount meal(s) have protein significantly outside the recommended range. Adjust portions to achieve 10-14g per main meal.";
    }

    return QualityCheckResult(
      checkName: "Protein Content Check",
      status: status,
      feedback: feedback,
      details: details,
    );
  }

  /// Check 2: Portion Size Check (all items have defined portions)
  static QualityCheckResult checkPortionSizes(MealPlan mealPlan) {
    List<String> details = [];
    int totalItems = 0;
    int itemsWithPortions = 0;
    int itemsWithVaguePortions = 0;

    // Define vague portion indicators
    List<String> vaguePhrases = [
      "handful",
      "some",
      "few",
      "little",
      "bit",
      "as needed",
    ];

    for (var meal in mealPlan.meals) {
      for (var item in meal.items) {
        totalItems++;
        String portionLower = item.portion.toLowerCase();

        if (portionLower.isEmpty || portionLower == "n/a" || portionLower == "-") {
          details.add("✗ ${meal.type} - ${item.name}: No portion size defined");
        } else if (vaguePhrases.any((phrase) => portionLower.contains(phrase))) {
          itemsWithVaguePortions++;
          itemsWithPortions++;
          details.add("⚠ ${meal.type} - ${item.name}: Vague portion '${item.portion}' (consider more specific measurement)");
        } else {
          itemsWithPortions++;
          details.add("✓ ${meal.type} - ${item.name}: '${item.portion}' (clearly defined)");
        }
      }
    }

    // Determine overall status
    CheckStatus status;
    String feedback;

    if (itemsWithPortions == totalItems && itemsWithVaguePortions == 0) {
      status = CheckStatus.ok;
      feedback = "All $totalItems items have clear, specific portion sizes. This ensures accurate tracking and consistency.";
    } else if (itemsWithPortions == totalItems) {
      status = CheckStatus.warning;
      feedback = "All items have portions, but $itemsWithVaguePortions have vague descriptions. Consider more specific measurements (e.g., cups, grams).";
    } else {
      int missing = totalItems - itemsWithPortions;
      status = CheckStatus.needsImprovement;
      feedback = "$missing items are missing portion sizes. All items must have defined portions for proper adherence and tracking.";
    }

    return QualityCheckResult(
      checkName: "Portion Size Check",
      status: status,
      feedback: feedback,
      details: details,
    );
  }

  /// Check 3: Low-Carb Consistency Check (for PCOS management)
  static QualityCheckResult checkLowCarbConsistency(MealPlan mealPlan) {
    List<String> details = [];
    int mainMealCount = 0;
    int lowCarbMeals = 0;
    int moderateCarbMeals = 0;
    int highCarbMeals = 0;

    for (var meal in mealPlan.meals) {
      if (meal.type == "Breakfast" ||
          meal.type == "Lunch" ||
          meal.type == "Dinner") {
        mainMealCount++;
        double carbs = meal.totalCarbs;

        if (carbs <= lowCarbThreshold) {
          lowCarbMeals++;
          details.add("✓ ${meal.type}: ${carbs.toStringAsFixed(1)}g carbs (low-carb)");
        } else if (carbs <= moderateCarbThreshold) {
          moderateCarbMeals++;
          details.add("⚠ ${meal.type}: ${carbs.toStringAsFixed(1)}g carbs (moderate, watch portions)");
        } else {
          highCarbMeals++;
          details.add("✗ ${meal.type}: ${carbs.toStringAsFixed(1)}g carbs (high for PCOS management)");
        }
      }
    }

    // Determine overall status
    CheckStatus status;
    String feedback;

    if (highCarbMeals == 0 && moderateCarbMeals <= 1) {
      status = CheckStatus.ok;
      feedback = "Meal plan follows low-carb principles consistently. This supports insulin sensitivity for PCOS management.";
    } else if (highCarbMeals == 0) {
      status = CheckStatus.warning;
      feedback = "$moderateCarbMeals meal(s) have moderate carbs. Consider reducing portions if client shows insulin resistance symptoms.";
    } else {
      status = CheckStatus.needsImprovement;
      feedback = "$highCarbMeals meal(s) have high carb content. For PCOS management, aim to keep main meals under $lowCarbThreshold-${moderateCarbThreshold}g carbs.";
    }

    return QualityCheckResult(
      checkName: "Low-Carb Consistency Check",
      status: status,
      feedback: feedback,
      details: details,
    );
  }

  /// Check 4: Formatting and Typo Check (basic)
  static QualityCheckResult checkFormatting(MealPlan mealPlan) {
    List<String> details = [];
    int issues = 0;

    // Check for basic formatting issues
    for (var meal in mealPlan.meals) {
      // Check meal type capitalization
      if (meal.type != meal.type.trim()) {
        issues++;
        details.add("✗ Extra whitespace in meal type: '${meal.type}'");
      }

      for (var item in meal.items) {
        // Check for empty names
        if (item.name.trim().isEmpty) {
          issues++;
          details.add("✗ ${meal.type}: Empty item name");
          continue;
        }

        // Check for consistent capitalization (should start with capital or lowercase consistently)
        if (item.name.length > 1 && item.name[0] == item.name[0].toUpperCase()) {
          // This is fine, starts with capital
          details.add("✓ ${meal.type} - ${item.name}: Properly formatted");
        } else if (item.name.length > 1 && item.name[0] == item.name[0].toLowerCase()) {
          // This is also fine for items like "dal", "roti"
          details.add("✓ ${meal.type} - ${item.name}: Properly formatted");
        }

        // Check for multiple consecutive spaces
        if (item.name.contains('  ')) {
          issues++;
          details.add("⚠ ${meal.type} - ${item.name}: Contains multiple spaces");
        }
      }
    }

    // Check plan notes
    if (mealPlan.notes.trim().isEmpty) {
      issues++;
      details.add("⚠ Meal plan notes are empty. Consider adding guidance for the client.");
    } else {
      details.add("✓ Plan notes present: ${mealPlan.notes}");
    }

    // Determine overall status
    CheckStatus status;
    String feedback;

    if (issues == 0) {
      status = CheckStatus.ok;
      feedback = "Meal plan is professionally formatted with clear item names and proper structure.";
    } else if (issues <= 2) {
      status = CheckStatus.warning;
      feedback = "Minor formatting issues found. Review for consistency and professionalism.";
    } else {
      status = CheckStatus.needsImprovement;
      feedback = "$issues formatting issues detected. Clean up spacing, capitalization, and ensure all fields are filled.";
    }

    return QualityCheckResult(
      checkName: "Formatting & Quality Check",
      status: status,
      feedback: feedback,
      details: details,
    );
  }

  /// Run all quality checks
  static List<QualityCheckResult> runAllChecks(MealPlan mealPlan) {
    return [
      checkProteinContent(mealPlan),
      checkPortionSizes(mealPlan),
      checkLowCarbConsistency(mealPlan),
      checkFormatting(mealPlan),
    ];
  }
}
