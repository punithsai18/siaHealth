import 'package:flutter/material.dart';
import '../models/meal_item.dart';
import '../models/client_profile.dart';
import '../utils/responsive.dart';

class MealPlanCard extends StatelessWidget {
  final MealPlan mealPlan;
  final ClientProfile? client;
  final VoidCallback? onEditPressed;

  const MealPlanCard({
    super.key, 
    required this.mealPlan,
    this.client,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final columns = ResponsiveHelper.getGridColumns(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, isMobile),
        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 20)),
        _buildMealDays(context, columns),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Meal Plan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232823),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white54, size: 14),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Week of ${mealPlan.date}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onEditPressed,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF7ed321),
                  side: const BorderSide(color: Color(0xFF7ed321)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      );
    }
    
    return Row(
      children: [
        const Text(
          'Weekly Meal Plan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF232823),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white54, size: 14),
              const SizedBox(width: 6),
              Text(
                'Week of ${mealPlan.date}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: onEditPressed,
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit Plan'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF7ed321),
            side: const BorderSide(color: Color(0xFF7ed321)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildMealDays(BuildContext context, int columns) {
    final days = [
      ('Monday', mealPlan.meals.take(2).toList()),
      ('Tuesday', mealPlan.meals.skip(2).take(2).toList()),
      ('Wednesday', mealPlan.meals.skip(4).toList()),
    ];

    if (columns == 1) {
      // Mobile: Single column
      return Column(
        children: days.map((day) {
          final totalCalories = day.$2.fold(0.0, (sum, m) => sum + m.totalCalories);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildDayCard(day.$1, day.$2, totalCalories),
          );
        }).toList(),
      );
    } else {
      // Tablet/Desktop: Grid layout
      final spacing = ResponsiveHelper.getSpacing(context);
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: days.map((day) {
          final totalCalories = day.$2.fold(0.0, (sum, m) => sum + m.totalCalories);
          return SizedBox(
            width: columns == 2 
                ? ResponsiveHelper.getContentWidth(context, columns: 2, extraSpacing: spacing * 3)
                : null,
            child: _buildDayCard(day.$1, day.$2, totalCalories),
          );
        }).toList(),
      );
    }
  }

  Widget _buildDayCard(String day, List<Meal> dayMeals, double totalCalories) {
    final hasWarning = totalCalories < 1600 || totalCalories > 2000;
    final info = hasWarning ? 'Review needed' : '${totalCalories.toInt()} kcal';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF232823),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                day,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (hasWarning)
                const Icon(Icons.warning, color: Colors.orange, size: 18),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            info,
            style: TextStyle(
              color: hasWarning ? Colors.orange : const Color(0xFF7ed321),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          // Show actual meals from data
          ...dayMeals.take(3).map((meal) {
            final mealName = meal.items.isNotEmpty ? meal.items[0].name : 'Meal';
            final icon = _getMealIconData(meal.type);
            return _buildMealItem(meal.type.toUpperCase(), mealName, icon);
          }),
          const SizedBox(height: 12),
          // Show snacks
          ...dayMeals.skip(3).expand((meal) => meal.items.map((item) => 
            _buildSnackItem(item.name)
          )),
        ],
      ),
    );
  }

  IconData _getMealIconData(String mealType) {
    if (mealType.toLowerCase().contains('breakfast')) return Icons.breakfast_dining;
    if (mealType.toLowerCase().contains('lunch')) return Icons.lunch_dining;
    if (mealType.toLowerCase().contains('dinner')) return Icons.dinner_dining;
    return Icons.fastfood;
  }

  Widget _buildMealItem(String label, String name, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF2d3a2d),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF7ed321), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSnackItem(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.white38),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
