import '../models/food_database.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class FoodChatbotService {
  // Constants for response text
  static const String _helpText = 
      "I can help you with:\n\n"
      "1. **Nutritional Information**: Ask about calories, protein, carbs, or fats in any food\n"
      "2. **Food Recommendations**: Get suggestions for breakfast, lunch, dinner, or snacks\n"
      "3. **Health-Specific Advice**: Learn about foods good for PCOS, thyroid, or hormonal balance\n"
      "4. **Portion Sizes**: Get information about appropriate serving sizes\n\n"
      "Try asking things like:\n"
      "• 'What's in paneer curry?'\n"
      "• 'Suggest breakfast for PCOS'\n"
      "• 'Which foods are high in protein?'\n"
      "• 'What are good thyroid foods?'";

  static List<ChatMessage> getChatHistory() {
    return [];
  }

  static String getBotResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase().trim();

    // Greeting responses
    if (_isGreeting(lowerMessage)) {
      return "Hello! I'm your food assistant. I can help you with:\n"
          "• Information about food items and their nutrition\n"
          "• Meal suggestions for PCOS, thyroid, and hormonal health\n"
          "• Portion sizes and calorie information\n"
          "• Dietary recommendations\n\n"
          "What would you like to know?";
    }

    // Nutrition query
    if (_isNutritionQuery(lowerMessage)) {
      return _getNutritionInfo(lowerMessage);
    }

    // Food recommendation query
    if (_isFoodRecommendationQuery(lowerMessage)) {
      return _getFoodRecommendations(lowerMessage);
    }

    // Calorie query
    if (_isCalorieQuery(lowerMessage)) {
      return _getCalorieInfo(lowerMessage);
    }

    // PCOS specific query
    if (_isPCOSQuery(lowerMessage)) {
      return _getPCOSAdvice(lowerMessage);
    }

    // Thyroid specific query
    if (_isThyroidQuery(lowerMessage)) {
      return _getThyroidAdvice(lowerMessage);
    }

    // Protein query
    if (_isProteinQuery(lowerMessage)) {
      return _getProteinInfo(lowerMessage);
    }

    // General help
    if (_isHelpQuery(lowerMessage)) {
      return _helpText;
    }

    // Default response with suggestions
    return "I'd love to help! You can ask me about:\n\n"
        "• Nutritional info (e.g., 'calories in dosa')\n"
        "• Food recommendations (e.g., 'breakfast ideas')\n"
        "• Health-specific advice (e.g., 'PCOS-friendly foods')\n"
        "• Protein sources (e.g., 'high protein foods')\n\n"
        "What would you like to know?";
  }

  // Helper methods to identify query types
  static bool _isGreeting(String message) {
    return message.contains('hi') ||
        message.contains('hello') ||
        message.contains('hey') ||
        message == 'h';
  }

  static bool _isHelpQuery(String message) {
    return message.contains('help') ||
        message.contains('what can you do') ||
        message.contains('how to use');
  }

  static bool _isNutritionQuery(String message) {
    return message.contains('nutrition') ||
        message.contains('nutrients') ||
        message.contains('what is in') ||
        message.contains('tell me about') ||
        message.contains('info about');
  }

  static bool _isFoodRecommendationQuery(String message) {
    return message.contains('suggest') ||
        message.contains('recommend') ||
        message.contains('what should i eat') ||
        message.contains('ideas for') ||
        message.contains('options for');
  }

  static bool _isCalorieQuery(String message) {
    return message.contains('calorie') ||
        message.contains('kcal') ||
        message.contains('how many calories');
  }

  static bool _isPCOSQuery(String message) {
    return message.contains('pcos') || message.contains('polycystic');
  }

  static bool _isThyroidQuery(String message) {
    return message.contains('thyroid');
  }

  static bool _isProteinQuery(String message) {
    return message.contains('protein') ||
        message.contains('high protein') ||
        message.contains('protein rich');
  }

  // Response generators
  static String _getNutritionInfo(String message) {
    // Search for food items mentioned in the message
    final matchedFoods = FoodDatabase.allFoods.where((food) {
      return message.contains(food.name.toLowerCase());
    }).toList();

    if (matchedFoods.isNotEmpty) {
      final food = matchedFoods.first;
      return "**${food.name}** (${food.defaultPortion})\n\n"
          "📊 Nutritional Information:\n"
          "• Calories: ${food.calories} kcal\n"
          "• Protein: ${food.protein}g\n"
          "• Carbs: ${food.carbs}g\n"
          "• Fats: ${food.fats}g\n"
          "• Category: ${food.category}\n\n"
          "This is a nutritious option that can be part of a balanced meal plan!";
    }

    return "I can provide nutritional information for various foods. Try asking about specific items like 'paneer curry', 'moong dal cheela', 'idli', 'dosa', or other Indian foods!";
  }

  static String _getFoodRecommendations(String message) {
    if (message.contains('breakfast')) {
      final breakfastFoods = FoodDatabase.allFoods
          .where((food) => food.category == 'Breakfast')
          .take(5)
          .toList();

      String response = "🌅 **Breakfast Recommendations:**\n\n";
      for (var food in breakfastFoods) {
        response += "• **${food.name}** (${food.calories} kcal)\n";
      }
      response +=
          "\nAll these options are nutritious and can support your health goals!";
      return response;
    }

    if (message.contains('lunch') || message.contains('dinner')) {
      return "🍽️ **Meal Recommendations:**\n\n"
          "• **Paneer curry** with roti (balanced protein and carbs)\n"
          "• **Dal** with rice and vegetables (complete protein)\n"
          "• **Chicken curry** with chapati (high protein)\n"
          "• **Mixed vegetable curry** with quinoa\n"
          "• **Grilled fish** with brown rice and salad\n\n"
          "These meals provide good nutrition for hormonal health!";
    }

    if (message.contains('snack')) {
      return "🥜 **Healthy Snack Ideas:**\n\n"
          "• Nuts and seeds (almonds, walnuts)\n"
          "• Fresh fruits with yogurt\n"
          "• Roasted chickpeas\n"
          "• Vegetable sticks with hummus\n"
          "• Boiled eggs\n\n"
          "These snacks help maintain stable blood sugar levels!";
    }

    return "I can suggest meals for breakfast, lunch, dinner, or snacks. What meal are you planning?";
  }

  static String _getCalorieInfo(String message) {
    final matchedFoods = FoodDatabase.allFoods.where((food) {
      return message.contains(food.name.toLowerCase());
    }).toList();

    if (matchedFoods.isNotEmpty) {
      final food = matchedFoods.first;
      return "**${food.name}** contains **${food.calories} calories** per ${food.defaultPortion}.\n\n"
          "For context:\n"
          "• Low calorie: < 150 kcal\n"
          "• Moderate: 150-250 kcal\n"
          "• Higher: > 250 kcal\n\n"
          "This is ${_getCalorieCategory(food.calories)} in calories.";
    }

    return "I can tell you the calorie content of various foods. Try asking about a specific food item!";
  }

  static String _getPCOSAdvice(String message) {
    return "🌸 **PCOS-Friendly Foods:**\n\n"
        "**Best Choices:**\n"
        "• High-fiber foods: Moong dal, oats, whole grains\n"
        "• Lean proteins: Paneer, dal, chicken, fish\n"
        "• Anti-inflammatory: Turmeric, ginger, leafy greens\n"
        "• Low GI foods: Idli, dosa (fermented foods)\n\n"
        "**Foods to Moderate:**\n"
        "• Refined carbs and sugary items\n"
        "• Processed foods\n\n"
        "Focus on balanced meals with protein, healthy fats, and complex carbs to help manage PCOS symptoms!";
  }

  static String _getThyroidAdvice(String message) {
    return "🦋 **Thyroid-Supportive Foods:**\n\n"
        "**Beneficial:**\n"
        "• Iodine-rich: Seafood, dairy products\n"
        "• Selenium: Nuts, eggs, fish\n"
        "• Zinc: Legumes, seeds, paneer\n"
        "• Iron: Dal, leafy greens, lean meats\n\n"
        "**Important:**\n"
        "• Eat regular, balanced meals\n"
        "• Include good protein sources\n"
        "• Stay hydrated\n\n"
        "These nutrients support healthy thyroid function!";
  }

  static String _getProteinInfo(String message) {
    final highProteinFoods = FoodDatabase.allFoods
        .where((food) => food.protein >= 10.0)
        .take(8)
        .toList();

    String response = "💪 **High Protein Foods:**\n\n";
    for (var food in highProteinFoods) {
      response += "• **${food.name}** - ${food.protein}g protein\n";
    }
    response +=
        "\nProtein is essential for hormone production and overall health!";
    return response;
  }

  static String _getCalorieCategory(double calories) {
    if (calories < 150) return "relatively low";
    if (calories < 250) return "moderate";
    return "relatively higher";
  }
}
