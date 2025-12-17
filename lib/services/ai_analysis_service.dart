import '../models/client_profile.dart';
import '../models/meal_item.dart';
import '../models/ai_analysis.dart';

/// Service for AI-powered meal plan analysis
/// Analyzes meal plans based on client profile, medical history, and health patterns
class AIAnalysisService {
  // Nutritional thresholds for analysis
  static const double _lowCarbThresholdStrict = 30.0;
  static const double _lowCarbThresholdModerate = 45.0;
  static const double _lowCarbThresholdHigh = 50.0;
  static const double _optimalProteinMin = 12.0;
  static const double _optimalProteinMax = 15.0;
  static const double _minProteinForSatiety = 10.0;
  static const double _totalProteinThreshold = 60.0;
  static const double _highCarbLunchThreshold = 50.0;
  static const double _highCarbDinnerThreshold = 40.0;
  static const double _lowBreakfastCalories = 300.0;
  static const double _minCaloriesForActive = 1500.0;
  
  // Condition keywords for detection
  static const List<String> _pcosKeywords = ['PCOS', 'polycystic'];
  static const List<String> _thyroidKeywords = ['thyroid', 'hypothyroid'];
  static const List<String> _diabetesKeywords = ['diabetes', 'pre-diabetes'];
  static const List<String> _ironKeywords = ['iron', 'anemia'];
  
  // Food category keywords
  static const List<String> _dairyFoods = ['paneer', 'yogurt', 'milk'];
  static const List<String> _seafoodFoods = ['fish', 'seafood'];
  static const List<String> _meatFoods = ['chicken', 'meat', 'fish'];
  static const List<String> _ironRichFoods = ['dal', 'spinach', 'meat', 'chicken'];
  
  // Health pattern keywords
  static const List<String> _sugarCravingKeywords = ['sugar', 'sweet'];
  static const List<String> _bloatingKeywords = ['bloat'];
  static const List<String> _lowEnergyKeywords = ['low'];
  static const List<String> _morningKeywords = ['morning'];
  static const List<String> _eveningKeywords = ['evening'];
  static const List<String> _lunchKeywords = ['lunch', 'post-lunch'];
  static const List<String> _dairyKeywords = ['dairy'];
  /// Analyze a meal plan for a specific client
  /// 
  /// Evaluates three key aspects:
  /// 1. Alignment with medical history
  /// 2. Contradictions with health log patterns
  /// 3. High-level concerns and recommendations
  static AIAnalysisResult analyzeMealPlan({
    required ClientProfile client,
    required MealPlan mealPlan,
  }) {
    // Analyze alignment with medical history
    final medicalHistoryAlignment = _checkMedicalHistoryAlignment(client, mealPlan);
    
    // Check for contradictions with health log
    final healthLogContradictions = _checkHealthLogContradictions(client, mealPlan);
    
    // Generate high-level recommendations
    final recommendations = _generateRecommendations(client, mealPlan);
    
    // Create overall summary
    final summary = _generateSummary(
      client,
      medicalHistoryAlignment,
      healthLogContradictions,
      recommendations,
    );
    
    return AIAnalysisResult(
      medicalHistoryAlignment: medicalHistoryAlignment,
      healthLogContradictions: healthLogContradictions,
      recommendations: recommendations,
      summary: summary,
    );
  }
  
  /// Check if meal plan aligns with client's medical history
  static AlignmentCheck _checkMedicalHistoryAlignment(
    ClientProfile client,
    MealPlan mealPlan,
  ) {
    List<String> strengths = [];
    List<String> concerns = [];
    
    // Calculate total daily nutrition
    double totalCarbs = 0;
    double totalProtein = 0;
    double totalFats = 0;
    int mealCount = 0;
    
    for (var meal in mealPlan.meals) {
      totalCarbs += meal.totalCarbs;
      totalProtein += meal.totalProtein;
      totalFats += meal.totalFats;
      if (meal.type == "Breakfast" || meal.type == "Lunch" || meal.type == "Dinner") {
        mealCount++;
      }
    }
    
    // Check condition-specific requirements
    for (var condition in client.primaryConditions) {
      final conditionUpper = condition.toUpperCase();
      
      if (_pcosKeywords.any((k) => conditionUpper.contains(k.toUpperCase()))) {
        // PCOS: Check for low-carb, high-protein approach
        if (totalCarbs / mealCount < _lowCarbThresholdHigh) {
          strengths.add('Low-carb approach aligns well with PCOS management');
        } else {
          concerns.add('Carbohydrate intake may be too high for optimal PCOS management');
        }
        
        if (totalProtein / mealCount >= _optimalProteinMax) {
          strengths.add('Adequate protein supports hormonal balance');
        } else {
          concerns.add('Protein levels could be increased for better satiety');
        }
      } else if (_thyroidKeywords.any((k) => conditionUpper.contains(k.toUpperCase()))) {
        // Thyroid: Check for balanced nutrition
        if (totalProtein > _totalProteinThreshold) {
          strengths.add('Good protein intake supports thyroid function');
        }
        
        // Check for iodine-rich foods
        bool hasSeafoodOrDairy = false;
        for (var meal in mealPlan.meals) {
          for (var item in meal.items) {
            final itemLower = item.name.toLowerCase();
            if (_dairyFoods.any((f) => itemLower.contains(f)) ||
                _seafoodFoods.any((f) => itemLower.contains(f))) {
              hasSeafoodOrDairy = true;
              break;
            }
          }
        }
        
        if (hasSeafoodOrDairy) {
          strengths.add('Includes iodine-rich foods beneficial for thyroid health');
        } else {
          concerns.add('Consider adding more iodine-rich foods (dairy, seafood)');
        }
      } else if (_diabetesKeywords.any((k) => conditionUpper.contains(k.toUpperCase()))) {
        // Diabetes: Focus on glycemic control
        if (totalCarbs / mealCount < _lowCarbThresholdModerate) {
          strengths.add('Carb distribution supports blood sugar management');
        } else {
          concerns.add('Carbohydrate portions may need adjustment for blood sugar control');
        }
      } else if (_ironKeywords.any((k) => conditionUpper.contains(k.toUpperCase()))) {
        // Iron deficiency: Check for iron-rich foods
        bool hasIronRichFoods = false;
        for (var meal in mealPlan.meals) {
          for (var item in meal.items) {
            final itemLower = item.name.toLowerCase();
            if (_ironRichFoods.any((f) => itemLower.contains(f))) {
              hasIronRichFoods = true;
              break;
            }
          }
        }
        
        if (hasIronRichFoods) {
          strengths.add('Includes iron-rich foods to support hemoglobin levels');
        } else {
          concerns.add('Add more iron-rich foods (dal, leafy greens, lean meats)');
        }
      }
    }
    
    // Check dietary preferences
    bool respectsDietaryPreference = true;
    if (client.dietaryPreference.toLowerCase().contains('vegetarian')) {
      for (var meal in mealPlan.meals) {
        for (var item in meal.items) {
          final itemLower = item.name.toLowerCase();
          if (_meatFoods.any((f) => itemLower.contains(f))) {
            respectsDietaryPreference = false;
            concerns.add('Plan includes non-vegetarian items, conflicts with dietary preference');
            break;
          }
        }
      }
      if (respectsDietaryPreference) {
        strengths.add('Respects vegetarian dietary preference');
      }
    }
    
    // Check food allergies
    for (var allergy in client.foodAllergies) {
      if (allergy.toLowerCase() != 'none') {
        for (var meal in mealPlan.meals) {
          for (var item in meal.items) {
            if (item.name.toLowerCase().contains(allergy.toLowerCase())) {
              concerns.add('Contains ${allergy}, which client is allergic to');
            }
          }
        }
      }
    }
    
    // Determine overall alignment
    bool isAligned = concerns.isEmpty || strengths.length > concerns.length;
    String explanation;
    
    if (concerns.isEmpty) {
      explanation = 'The meal plan aligns well with the client\'s medical history and conditions. All major requirements are addressed.';
    } else if (isAligned) {
      explanation = 'The meal plan generally aligns with the client\'s needs, though some areas could be optimized.';
    } else {
      explanation = 'The meal plan has several areas that need adjustment to better align with the client\'s medical history.';
    }
    
    return AlignmentCheck(
      isAligned: isAligned,
      explanation: explanation,
      strengths: strengths.isEmpty ? ['Plan provides balanced nutrition'] : strengths,
      concerns: concerns,
    );
  }
  
  /// Check for contradictions between meal plan and health log patterns
  static ContradictionCheck _checkHealthLogContradictions(
    ClientProfile client,
    MealPlan mealPlan,
  ) {
    List<String> contradictions = [];
    List<String> suggestions = [];
    
    // Check cravings patterns
    final cravingsLower = client.cravings.toLowerCase();
    if (_sugarCravingKeywords.any((k) => cravingsLower.contains(k))) {
      // Check if plan has adequate protein and fiber to manage cravings
      double avgProteinPerMeal = 0;
      int mainMeals = 0;
      for (var meal in mealPlan.meals) {
        if (meal.type == "Breakfast" || meal.type == "Lunch" || meal.type == "Dinner") {
          avgProteinPerMeal += meal.totalProtein;
          mainMeals++;
        }
      }
      avgProteinPerMeal /= mainMeals;
      
      if (avgProteinPerMeal < _optimalProteinMin) {
        contradictions.add('Client reports sugar cravings, but meal protein levels may be insufficient for satiety');
        suggestions.add('Increase protein in main meals to $_optimalProteinMin-${_optimalProteinMax}g to help manage sugar cravings');
      }
      
      // Check timing of high-carb meals
      if (_eveningKeywords.any((k) => cravingsLower.contains(k))) {
        bool hasHighCarbDinner = false;
        for (var meal in mealPlan.meals) {
          if (meal.type == "Dinner" && meal.totalCarbs > _highCarbDinnerThreshold) {
            hasHighCarbDinner = true;
          }
        }
        if (hasHighCarbDinner) {
          contradictions.add('High-carb dinner may worsen evening sugar cravings');
          suggestions.add('Consider reducing dinner carbs and adding protein-rich snacks');
        }
      }
    }
    
    // Check bloating patterns
    final bloatingLower = client.bloatingIssues.toLowerCase();
    if (_bloatingKeywords.any((k) => bloatingLower.contains(k)) && 
        !bloatingLower.contains('none')) {
      // Check for common bloating triggers
      if (_lunchKeywords.any((k) => bloatingLower.contains(k))) {
        // Check lunch composition
        for (var meal in mealPlan.meals) {
          if (meal.type == "Lunch") {
            if (meal.totalCarbs > _highCarbLunchThreshold) {
              contradictions.add('High-carb lunch may contribute to post-lunch bloating');
              suggestions.add('Reduce lunch carbohydrates and increase vegetables for better digestion');
            }
          }
        }
      }
      
      // Check for dairy if client has dairy-related bloating
      if (_dairyKeywords.any((k) => bloatingLower.contains(k))) {
        for (var meal in mealPlan.meals) {
          for (var item in meal.items) {
            final itemLower = item.name.toLowerCase();
            if (_dairyFoods.any((f) => itemLower.contains(f))) {
              contradictions.add('Plan includes dairy products, which may trigger bloating');
              suggestions.add('Replace dairy with plant-based alternatives or lactose-free options');
              break;
            }
          }
        }
      }
    }
    
    // Check energy level patterns
    final energyLower = client.energyLevels.toLowerCase();
    if (_lowEnergyKeywords.any((k) => energyLower.contains(k))) {
      if (_morningKeywords.any((k) => energyLower.contains(k))) {
        // Check breakfast adequacy
        for (var meal in mealPlan.meals) {
          if (meal.type == "Breakfast") {
            if (meal.totalProtein < _minProteinForSatiety) {
              contradictions.add('Low breakfast protein may not address morning energy issues');
              suggestions.add('Boost breakfast protein to $_optimalProteinMin-${_optimalProteinMax}g for sustained morning energy');
            }
            if (meal.totalCalories < _lowBreakfastCalories) {
              contradictions.add('Breakfast may be too light to support morning energy needs');
              suggestions.add('Increase breakfast portion sizes or add a mid-morning snack');
            }
          }
        }
      }
    }
    
    // Check activity level vs calorie intake
    final activityLower = client.activityLevel.toLowerCase();
    if (activityLower.contains('active') || activityLower.contains('high')) {
      double totalCalories = 0;
      for (var meal in mealPlan.meals) {
        totalCalories += meal.totalCalories;
      }
      
      if (totalCalories < _minCaloriesForActive) {
        contradictions.add('Calorie intake may be too low for active lifestyle');
        suggestions.add('Increase portion sizes or add healthy snacks to meet energy demands');
      }
    }
    
    bool hasContradictions = contradictions.isNotEmpty;
    String explanation;
    
    if (hasContradictions) {
      explanation = '${contradictions.length} contradiction(s) found between the meal plan and client\'s health log patterns.';
    } else {
      explanation = 'No major contradictions found. The meal plan addresses the client\'s reported health patterns appropriately.';
    }
    
    return ContradictionCheck(
      hasContradictions: hasContradictions,
      explanation: explanation,
      contradictions: contradictions,
      suggestions: suggestions,
    );
  }
  
  /// Generate high-level recommendations
  static List<Recommendation> _generateRecommendations(
    ClientProfile client,
    MealPlan mealPlan,
  ) {
    List<Recommendation> recommendations = [];
    
    // Calculate meal plan metrics
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFats = 0;
    double totalCalories = 0;
    int mainMeals = 0;
    
    for (var meal in mealPlan.meals) {
      totalProtein += meal.totalProtein;
      totalCarbs += meal.totalCarbs;
      totalFats += meal.totalFats;
      totalCalories += meal.totalCalories;
      if (meal.type == "Breakfast" || meal.type == "Lunch" || meal.type == "Dinner") {
        mainMeals++;
      }
    }
    
    // Recommendation 1: Based on primary condition and goals
    if (client.primaryConditions.any((c) => 
        _pcosKeywords.any((k) => c.toUpperCase().contains(k.toUpperCase())))) {
      if (totalCarbs / mainMeals > _highCarbDinnerThreshold) {
        recommendations.add(Recommendation(
          priority: RecommendationPriority.high,
          title: 'Optimize Carbohydrate Distribution for PCOS',
          description: 'Current carb levels may impact insulin sensitivity. For PCOS management, keeping main meals under 30-35g carbs can improve hormonal balance.',
          actionableSteps: [
            'Reduce roti/rice portions by 25% in lunch and dinner',
            'Increase protein portions to maintain satiety',
            'Add more low-carb vegetables to increase volume',
            'Monitor client\'s response after 1 week',
          ],
        ));
      } else {
        recommendations.add(Recommendation(
          priority: RecommendationPriority.low,
          title: 'Maintain Current PCOS-Friendly Approach',
          description: 'The meal plan follows good low-carb principles for PCOS management. Continue monitoring client response.',
          actionableSteps: [
            'Track client\'s cycle regularity over next 4 weeks',
            'Monitor energy levels and cravings',
            'Adjust portions based on satiety feedback',
          ],
        ));
      }
    }
    
    // Recommendation 2: Based on health log patterns
    final cravingsLower = client.cravings.toLowerCase();
    if (cravingsLower.contains('craving') && !cravingsLower.contains('none')) {
      recommendations.add(Recommendation(
        priority: RecommendationPriority.medium,
        title: 'Address Craving Management Strategy',
        description: 'Client reports frequent cravings. Strategic meal timing and composition can help reduce cravings naturally.',
        actionableSteps: [
          'Ensure 12-15g protein in each main meal',
          'Add healthy fat sources (nuts, seeds) to increase satiety',
          'Time the evening snack closer to when cravings typically occur',
          'Include cinnamon or fenugreek to help stabilize blood sugar',
        ],
      ));
    }
    
    // Recommendation 3: Based on overall wellness and goals
    final primaryGoalLower = client.primaryGoal.toLowerCase();
    final energyLevelsLower = client.energyLevels.toLowerCase();
    if (primaryGoalLower.contains('energy') ||
        _lowEnergyKeywords.any((k) => energyLevelsLower.contains(k))) {
      recommendations.add(Recommendation(
        priority: RecommendationPriority.high,
        title: 'Boost Energy Through Meal Timing and Composition',
        description: 'Energy levels can be improved through strategic nutrient timing and adequate calorie distribution.',
        actionableSteps: [
          'Front-load calories to breakfast and lunch (60-70% of daily intake)',
          'Add iron-rich foods with vitamin C for better absorption',
          'Ensure adequate B-vitamin sources (whole grains, dal)',
          'Consider adding a small pre-workout snack if exercising',
        ],
      ));
    } else {
      final bloatingLower = client.bloatingIssues.toLowerCase();
      if (_bloatingKeywords.any((k) => bloatingLower.contains(k)) &&
          !bloatingLower.contains('none')) {
      recommendations.add(Recommendation(
        priority: RecommendationPriority.medium,
        title: 'Reduce Bloating Through Food Choices',
        description: 'Digestive comfort can be improved by adjusting meal composition and cooking methods.',
        actionableSteps: [
          'Reduce portion sizes and eat slowly',
          'Add digestive spices (cumin, ginger, fennel)',
          'Ensure adequate hydration between meals',
          'Consider temporarily reducing high-FODMAP foods',
        ],
      ));
      } else {
        recommendations.add(Recommendation(
        priority: RecommendationPriority.low,
        title: 'Continue Current Approach with Monitoring',
        description: 'The meal plan appears well-suited to client\'s current needs. Focus on consistency and monitoring.',
        actionableSteps: [
          'Track adherence for next 2 weeks',
          'Monitor changes in health log patterns',
          'Adjust portions based on satiety and results',
          'Review and iterate based on client feedback',
        ],
        ));
      }
    }
    
    // Limit to 3 recommendations, prioritized by importance
    recommendations.sort((a, b) {
      final priorityOrder = {
        RecommendationPriority.high: 0,
        RecommendationPriority.medium: 1,
        RecommendationPriority.low: 2,
      };
      return (priorityOrder[a.priority] ?? 2).compareTo(priorityOrder[b.priority] ?? 2);
    });
    
    return recommendations.take(3).toList();
  }
  
  /// Generate overall summary
  static String _generateSummary(
    ClientProfile client,
    AlignmentCheck alignment,
    ContradictionCheck contradictions,
    List<Recommendation> recommendations,
  ) {
    String summary = 'AI Analysis for ${client.name} (Age: ${client.age}, Conditions: ${client.primaryConditions.join(", ")})\n\n';
    
    if (alignment.isAligned && !contradictions.hasContradictions) {
      summary += '✅ Overall Assessment: The meal plan is well-suited for this client. ';
      summary += 'It aligns with medical history and addresses health log patterns appropriately. ';
    } else if (alignment.isAligned) {
      summary += '⚠️ Overall Assessment: The meal plan has good alignment with medical needs but shows some contradictions with health patterns. ';
    } else {
      summary += '❌ Overall Assessment: The meal plan needs adjustments to better align with client\'s medical history and health patterns. ';
    }
    
    int highPriorityCount = recommendations.where((r) => r.priority == RecommendationPriority.high).length;
    if (highPriorityCount > 0) {
      summary += '$highPriorityCount high-priority recommendation(s) require immediate attention.';
    } else {
      summary += 'Focus on implementing the suggested refinements for optimal results.';
    }
    
    return summary;
  }
}
