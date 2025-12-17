import 'package:flutter/material.dart';
import '../models/food_database.dart';
import '../models/meal_item.dart';

class FoodSearchDialog extends StatefulWidget {
  const FoodSearchDialog({super.key});

  @override
  State<FoodSearchDialog> createState() => _FoodSearchDialogState();
}

class _FoodSearchDialogState extends State<FoodSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<FoodItem> _filteredFoods = FoodDatabase.allFoods;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filterFoods();
    });
  }

  void _filterFoods() {
    List<FoodItem> results = FoodDatabase.searchFoods(_searchController.text);
    
    if (_selectedCategory != 'All') {
      results = results.where((food) => food.category == _selectedCategory).toList();
    }
    
    _filteredFoods = results;
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _filterFoods();
    });
  }

  void _selectFood(FoodItem food) {
    // Convert FoodItem to MealItem and return it
    final mealItem = MealItem(
      name: food.name,
      portion: food.defaultPortion,
      protein: food.protein,
      carbs: food.carbs,
      fats: food.fats,
      calories: food.calories,
    );
    Navigator.of(context).pop(mealItem);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...FoodDatabase.getAllCategories()];

    return Dialog(
      backgroundColor: const Color(0xFF1a1f1a),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7ed321).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: Color(0xFF7ed321),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add Food Item',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search Box
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF232823),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF7ed321).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search food items...',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF7ed321)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Filter
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          _onCategoryChanged(category);
                        }
                      },
                      backgroundColor: const Color(0xFF232823),
                      selectedColor: const Color(0xFF7ed321).withOpacity(0.3),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFF7ed321) : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF7ed321) : Colors.white24,
                        width: 1.5,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Results Count
            Text(
              '${_filteredFoods.length} items found',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Food List
            Expanded(
              child: _filteredFoods.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.white24,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No food items found',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredFoods.length,
                      itemBuilder: (context, index) {
                        final food = _filteredFoods[index];
                        return _buildFoodCard(food);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCard(FoodItem food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF232823),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2d3a2d),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _selectFood(food),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Food Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF7ed321).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getCategoryIcon(food.category),
                  color: const Color(0xFF7ed321),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Food Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7ed321).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            food.category,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF7ed321),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          food.defaultPortion,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildNutrientBadge('P', food.protein.toStringAsFixed(1), Colors.blue),
                        const SizedBox(width: 8),
                        _buildNutrientBadge('C', food.carbs.toStringAsFixed(1), Colors.orange),
                        const SizedBox(width: 8),
                        _buildNutrientBadge('F', food.fats.toStringAsFixed(1), Colors.purple),
                        const SizedBox(width: 8),
                        _buildNutrientBadge('Cal', food.calories.toStringAsFixed(0), const Color(0xFF7ed321)),
                      ],
                    ),
                  ],
                ),
              ),

              // Add Icon
              const Icon(
                Icons.add_circle,
                color: Color(0xFF7ed321),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return Icons.breakfast_dining;
      case 'main dish':
      case 'protein':
        return Icons.lunch_dining;
      case 'vegetables':
        return Icons.eco;
      case 'carbs':
        return Icons.rice_bowl;
      case 'snacks':
        return Icons.fastfood;
      case 'soup':
        return Icons.soup_kitchen;
      case 'condiment':
        return Icons.restaurant;
      case 'beverage':
        return Icons.local_drink;
      default:
        return Icons.restaurant_menu;
    }
  }
}
