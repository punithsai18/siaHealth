class MealItem {
  final String name;
  final String portion;
  final double protein;
  final double carbs;
  final double fats;
  final double calories;

  MealItem({
    required this.name,
    required this.portion,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.calories,
  });
}

class Meal {
  final String type; // Breakfast, Lunch, Dinner, Snack
  final List<MealItem> items;

  Meal({
    required this.type,
    required this.items,
  });

  double get totalProtein =>
      items.fold(0, (sum, item) => sum + item.protein);
  double get totalCarbs => items.fold(0, (sum, item) => sum + item.carbs);
  double get totalFats => items.fold(0, (sum, item) => sum + item.fats);
  double get totalCalories =>
      items.fold(0, (sum, item) => sum + item.calories);
}

class MealPlan {
  final String date;
  final List<Meal> meals;
  final String notes;

  MealPlan({
    required this.date,
    required this.meals,
    required this.notes,
  });

  static MealPlan getSampleMealPlan() {
    return MealPlan(
      date: "2024-01-15",
      notes: "Balanced meal plan for PCOS management, focus on protein, fiber, "
          "and healthy fats. Maintain steady blood sugar levels throughout the day.",
      meals: [
        Meal(
          type: "Breakfast",
          items: [
            MealItem(
              name: "Moong dal cheela",
              portion: "2 medium pieces",
              protein: 12.0,
              carbs: 25.0,
              fats: 5.0,
              calories: 200,
            ),
            MealItem(
              name: "Green chutney",
              portion: "2 tbsp",
              protein: 1.0,
              carbs: 3.0,
              fats: 0.5,
              calories: 20,
            ),
            MealItem(
              name: "Greek yogurt",
              portion: "1 bowl",
              protein: 10.0,
              carbs: 8.0,
              fats: 5.0,
              calories: 120,
            ),
          ],
        ),
        Meal(
          type: "Mid-Morning Snack",
          items: [
            MealItem(
              name: "Handful of almonds",
              portion: "10 pieces",
              protein: 6.0,
              carbs: 6.0,
              fats: 14.0,
              calories: 170,
            ),
            MealItem(
              name: "Apple",
              portion: "1 medium",
              protein: 0.5,
              carbs: 25.0,
              fats: 0.3,
              calories: 95,
            ),
          ],
        ),
        Meal(
          type: "Lunch",
          items: [
            MealItem(
              name: "Roti",
              portion: "2 medium",
              protein: 6.0,
              carbs: 40.0,
              fats: 2.0,
              calories: 200,
            ),
            MealItem(
              name: "Paneer curry",
              portion: "1 bowl (100g)",
              protein: 18.0,
              carbs: 8.0,
              fats: 12.0,
              calories: 220,
            ),
            MealItem(
              name: "Mixed vegetable salad",
              portion: "1 bowl",
              protein: 3.0,
              carbs: 8.0,
              fats: 0.5,
              calories: 50,
            ),
            MealItem(
              name: "Dal tadka",
              portion: "1 bowl",
              protein: 9.0,
              carbs: 20.0,
              fats: 5.0,
              calories: 165,
            ),
          ],
        ),
        Meal(
          type: "Evening Snack",
          items: [
            MealItem(
              name: "Sprouts chaat",
              portion: "1 small bowl",
              protein: 7.0,
              carbs: 15.0,
              fats: 2.0,
              calories: 110,
            ),
            MealItem(
              name: "Green tea",
              portion: "1 cup",
              protein: 0.0,
              carbs: 0.0,
              fats: 0.0,
              calories: 2,
            ),
          ],
        ),
        Meal(
          type: "Dinner",
          items: [
            MealItem(
              name: "Grilled paneer",
              portion: "100g",
              protein: 14.0,
              carbs: 4.0,
              fats: 10.0,
              calories: 170,
            ),
            MealItem(
              name: "Stir-fried vegetables",
              portion: "1 large bowl",
              protein: 4.0,
              carbs: 12.0,
              fats: 3.0,
              calories: 90,
            ),
            MealItem(
              name: "Tomato soup",
              portion: "1 bowl",
              protein: 2.0,
              carbs: 10.0,
              fats: 1.0,
              calories: 60,
            ),
            MealItem(
              name: "Quinoa",
              portion: "1 bowl",
              protein: 8.0,
              carbs: 39.0,
              fats: 4.0,
              calories: 222,
            ),
          ],
        ),
        Meal(
          type: "Late Evening Snack",
          items: [
            MealItem(
              name: "Roasted makhana",
              portion: "1 bowl",
              protein: 5.0,
              carbs: 18.0,
              fats: 1.0,
              calories: 100,
            ),
          ],
        ),
      ],
    );
  }
}
