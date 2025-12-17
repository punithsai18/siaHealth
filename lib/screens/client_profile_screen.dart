import 'package:flutter/material.dart';
import '../models/client_profile.dart';
import '../models/meal_item.dart';
import '../models/ai_analysis.dart';
import '../widgets/food_search_dialog.dart';
import '../widgets/ai_analysis_card.dart';
import '../services/ai_analysis_service.dart';

class ClientProfileScreen extends StatefulWidget {
  final ClientProfile client;
  final MealPlan? mealPlan;
  final int initialTabIndex;

  const ClientProfileScreen({
    super.key,
    required this.client,
    this.mealPlan,
    this.initialTabIndex = 0,
  });

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late MealPlan _mealPlan;
  late AIAnalysisResult _aiAnalysis;
  bool _isEditingMeal = false;
  int? _editingMealIndex;
  
  // Breakpoint constants
  static const double _mobileBreakpoint = 600;
  static const double _totalMobilePadding = 64; // 16px * 4 (left + right + card padding)
  
  // Helper getter for mobile detection
  bool get _isMobile => MediaQuery.of(context).size.width < _mobileBreakpoint;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3, 
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _mealPlan = widget.mealPlan ?? MealPlan.getSampleMealPlan();
    // Generate AI analysis
    _aiAnalysis = AIAnalysisService.analyzeMealPlan(
      client: widget.client,
      mealPlan: _mealPlan,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _generateHealthLogSummary() {
    List<String> summaryParts = [];
    
    if (widget.client.cravings.isNotEmpty && widget.client.cravings.toLowerCase() != 'none') {
      summaryParts.add(widget.client.cravings);
    }
    
    if (widget.client.bloatingIssues.isNotEmpty && widget.client.bloatingIssues.toLowerCase() != 'none') {
      summaryParts.add(widget.client.bloatingIssues);
    }
    
    if (summaryParts.isEmpty) {
      return 'Summary: No significant health log patterns reported.';
    }
    
    return 'Summary: ${summaryParts.join(' and ')}.';
  }

  Future<void> _showAddFoodDialog(int mealIndex) async {
    final selectedItem = await showDialog<MealItem>(
      context: context,
      builder: (context) => const FoodSearchDialog(),
    );

    if (selectedItem != null) {
      setState(() {
        _mealPlan.meals[mealIndex].items.add(selectedItem);
      });
    }
  }

  void _deleteMealItem(int mealIndex, MealItem item) {
    setState(() {
      _mealPlan.meals[mealIndex].items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1f1a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF232823),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.5),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2d3a2d),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF7ed321), size: 20),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF7ed321).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFF7ed321),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.client.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF7ed321),
          indicatorWeight: 3,
          labelColor: const Color(0xFF7ed321),
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          tabs: const [
            Tab(text: 'Client Profile'),
            Tab(text: 'Meal Plan'),
            Tab(text: 'AI Analysis'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(),
          _buildMealPlanTab(),
          _buildAIAnalysisTab(),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final spacing = _isMobile ? 16.0 : 24.0;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(_isMobile ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildClientOverview(),
          SizedBox(height: spacing),
          _buildMedicalHistory(),
          SizedBox(height: spacing),
          _buildLifestyleHabits(),
          SizedBox(height: spacing),
          _buildHealthLogs(),
          SizedBox(height: spacing),
          _buildGoalsMetrics(),
          SizedBox(height: spacing),
          _buildRiskFlags(),
          SizedBox(height: spacing),
          _buildSystemMetadata(),
        ],
      ),
    );
  }

  Widget _buildClientOverview() {
    return _buildSection(
      title: '1️⃣ Client Overview',
      subtitle: 'Quick context in 5-10 seconds',
      child: Column(
        children: [
          // Profile Photo Section
          Row(
            children: [
              // Profile Photo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF7ed321).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF7ed321),
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF7ed321),
                  size: 56,
                ),
              ),
              const SizedBox(width: 20),
              // Client Name and Basic Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.client.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7ed321).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Age: ${widget.client.age}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF7ed321),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF42a5f5).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'ID: ${widget.client.clientId}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF42a5f5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          _buildChipRow(
            'Primary Conditions',
            widget.client.primaryConditions,
            Colors.red,
          ),
          _buildChipRow(
            'Current Goals',
            widget.client.currentGoals,
            const Color(0xFF7ed321),
          ),
          _buildInfoRow('Plan Start Date', widget.client.planStartDate),
          _buildInfoRow('Plan Duration', widget.client.planDuration),
          _buildInfoRow(
            'Assigned Nutritionist',
            widget.client.assignedNutritionist,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalHistory() {
    return _buildSection(
      title: '2️⃣ Medical & Health History',
      subtitle: 'Understand constraints and risks',
      child: Column(
        children: [
          _buildChipRow(
            'Diagnosed Conditions',
            widget.client.diagnosedConditions,
            Colors.orange,
          ),
          _buildChipRow(
            'Medications/Supplements',
            widget.client.medications,
            Colors.blue,
          ),
          _buildChipRow(
            'Food Allergies/Intolerances',
            widget.client.foodAllergies,
            Colors.red,
          ),
          _buildInfoRow('Dietary Preference', widget.client.dietaryPreference),
          _buildChipRow(
            'Past Issues',
            widget.client.pastIssues,
            Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildLifestyleHabits() {
    return _buildSection(
      title: '3️⃣ Lifestyle & Habits',
      subtitle: 'Check feasibility of the meal plan',
      child: Column(
        children: [
          _buildInfoRow('Daily Activity Level', widget.client.activityLevel),
          _buildInfoRow('Sleep Quality', widget.client.sleepQuality),
          _buildInfoRow('Work Schedule', widget.client.workSchedule),
          _buildInfoRow('Stress Level', widget.client.stressLevel),
          _buildInfoRow('Water Intake', widget.client.waterIntake),
        ],
      ),
    );
  }

  Widget _buildHealthLogs() {
    return _buildSection(
      title: '4️⃣ Health Logs & Patterns',
      subtitle: 'Identify trends for AI + QC checks',
      child: Column(
        children: [
          _buildInfoRow('Energy Levels', widget.client.energyLevels),
          _buildInfoRow('Cravings', widget.client.cravings),
          _buildInfoRow('Bloating/Digestion Issues', widget.client.bloatingIssues),
          _buildInfoRow('Mood Changes', widget.client.moodChanges),
          _buildInfoRow('Cycle Notes', widget.client.cycleNotes),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2d3a2d),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF7ed321), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _generateHealthLogSummary(),
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsMetrics() {
    return _buildSection(
      title: '5️⃣ Goals & Success Metrics',
      subtitle: 'Align meal plan evaluation',
      child: Column(
        children: [
          _buildInfoRow('Primary Goal', widget.client.primaryGoal),
          _buildInfoRow('Secondary Goal', widget.client.secondaryGoal),
          _buildInfoRow(
            'Short-term Expectations (2-4 weeks)',
            widget.client.shortTermExpectations,
          ),
          _buildInfoRow('Long-term Outcomes', widget.client.longTermOutcomes),
        ],
      ),
    );
  }

  Widget _buildRiskFlags() {
    return _buildSection(
      title: '6️⃣ Risk Flags / Notes',
      subtitle: 'Surface concerns quickly',
      child: Column(
        children: [
          _buildChipRow(
            'Risk Flags',
            widget.client.riskFlags,
            Colors.red,
          ),
          _buildInfoRow('Coach Notes', widget.client.coachNotes),
        ],
      ),
    );
  }

  Widget _buildSystemMetadata() {
    return _buildSection(
      title: '7️⃣ System Metadata',
      subtitle: 'Traceability & accountability',
      child: Column(
        children: [
          _buildInfoRow('Profile Last Updated', widget.client.lastUpdated),
          _buildInfoRow(
            'Data Completeness Status',
            widget.client.dataCompletenessStatus,
          ),
          _buildChipRow(
            'System Flags',
            widget.client.systemFlags,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(_isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFF232823),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2d3a2d),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF7ed321),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: _isMobile ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: _isMobile ? 12 : 13,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: _isMobile ? 16 : 20),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2d3a2d).withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7ed321),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7ed321),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildChipRow(String label, List<String> items, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2d3a2d).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.label_outline,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.25),
                      color.withOpacity(0.15),
                    ],
                  ),
                  border: Border.all(color: color.withOpacity(0.6), width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: color,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        color: color,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlanTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_isMobile ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use Column layout for mobile to prevent overflow
          _isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meal Plan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${_mealPlan.date}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7ed321).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Created by SIA Health Nutritionist',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7ed321),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Meal Plan',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Date: ${_mealPlan.date}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7ed321).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Created by SIA Health Nutritionist',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7ed321),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 24),
          _buildTotalNutrition(),
          const SizedBox(height: 24),
          ..._mealPlan.meals.asMap().entries.map((entry) {
            return Column(
              children: [
                _buildMealCard(entry.value, entry.key),
                const SizedBox(height: 16),
              ],
            );
          }),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF232823),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _mealPlan.notes,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalNutrition() {
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFats = 0;
    double totalCalories = 0;

    for (var meal in _mealPlan.meals) {
      totalProtein += meal.totalProtein;
      totalCarbs += meal.totalCarbs;
      totalFats += meal.totalFats;
      totalCalories += meal.totalCalories;
    }

    return Container(
      padding: EdgeInsets.all(_isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7ed321).withOpacity(0.15),
            const Color(0xFF7ed321).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFF7ed321), width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7ed321).withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF7ed321),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Total Daily Nutrition',
                  style: TextStyle(
                    fontSize: _isMobile ? 16 : 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7ed321),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _isMobile ? 16 : 20),
          // Use Wrap for mobile to prevent overflow
          _isMobile
              ? Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - _totalMobilePadding) / 2,
                      child: _buildNutrientBox(
                        'Protein',
                        '${totalProtein.toStringAsFixed(1)}g',
                        Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - _totalMobilePadding) / 2,
                      child: _buildNutrientBox(
                        'Carbs',
                        '${totalCarbs.toStringAsFixed(1)}g',
                        Colors.orange,
                      ),
                    ),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - _totalMobilePadding) / 2,
                      child: _buildNutrientBox(
                        'Fats',
                        '${totalFats.toStringAsFixed(1)}g',
                        Colors.purple,
                      ),
                    ),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - _totalMobilePadding) / 2,
                      child: _buildNutrientBox(
                        'Calories',
                        '${totalCalories.toStringAsFixed(0)}',
                        const Color(0xFF7ed321),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildNutrientBox(
                        'Protein',
                        '${totalProtein.toStringAsFixed(1)}g',
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildNutrientBox(
                        'Carbs',
                        '${totalCarbs.toStringAsFixed(1)}g',
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildNutrientBox(
                        'Fats',
                        '${totalFats.toStringAsFixed(1)}g',
                        Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildNutrientBox(
                        'Calories',
                        '${totalCalories.toStringAsFixed(0)}',
                        const Color(0xFF7ed321),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildNutrientBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            _getNutrientIcon(label),
            color: color,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNutrientIcon(String label) {
    switch (label.toLowerCase()) {
      case 'protein':
        return Icons.fitness_center;
      case 'carbs':
        return Icons.grain;
      case 'fats':
        return Icons.water_drop;
      case 'calories':
        return Icons.local_fire_department;
      default:
        return Icons.restaurant;
    }
  }

  Widget _buildMealCard(Meal meal, int mealIndex) {
    final isEditing = _isEditingMeal && _editingMealIndex == mealIndex;

    return Container(
      padding: EdgeInsets.all(_isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFF232823),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEditing ? const Color(0xFF7ed321) : const Color(0xFF2d3a2d),
          width: isEditing ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isEditing ? const Color(0xFF7ed321) : Colors.black).withOpacity(0.2),
            blurRadius: isEditing ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                meal.type,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  if (!isEditing)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF7ed321)),
                      onPressed: () {
                        setState(() {
                          _isEditingMeal = true;
                          _editingMealIndex = mealIndex;
                        });
                      },
                    )
                  else
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditingMeal = false;
                          _editingMealIndex = null;
                        });
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Color(0xFF7ed321)),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...meal.items.map((item) => _buildMealItemRow(item, isEditing, mealIndex)),
          if (isEditing) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _showAddFoodDialog(mealIndex),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Food Item'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF7ed321),
                side: const BorderSide(color: Color(0xFF7ed321)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),
          // Use Wrap for better mobile support
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMealNutrient(
                'Protein',
                '${meal.totalProtein.toStringAsFixed(1)}g',
                Colors.blue,
              ),
              _buildMealNutrient(
                'Carbs',
                '${meal.totalCarbs.toStringAsFixed(1)}g',
                Colors.orange,
              ),
              _buildMealNutrient(
                'Fats',
                '${meal.totalFats.toStringAsFixed(1)}g',
                Colors.purple,
              ),
              _buildMealNutrient(
                'Calories',
                '${meal.totalCalories.toStringAsFixed(0)}',
                const Color(0xFF7ed321),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealItemRow(MealItem item, bool isEditing, int mealIndex) {
    if (_isMobile) {
      // Mobile: Stack layout to prevent overflow
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7ed321),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item.portion,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isEditing)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _deleteMealItem(mealIndex, item),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  Text(
                    'P: ${item.protein.toStringAsFixed(1)}g',
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                  Text(
                    'C: ${item.carbs.toStringAsFixed(1)}g',
                    style: const TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                  Text(
                    'F: ${item.fats.toStringAsFixed(1)}g',
                    style: const TextStyle(fontSize: 12, color: Colors.purple),
                  ),
                  Text(
                    '${item.calories.toStringAsFixed(0)} cal',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7ed321),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    
    // Tablet/Desktop: Original horizontal layout
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF7ed321),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item.portion,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () => _deleteMealItem(mealIndex, item),
            ),
          Expanded(
            child: Text(
              'P: ${item.protein.toStringAsFixed(1)}g',
              style: const TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
          Expanded(
            child: Text(
              'C: ${item.carbs.toStringAsFixed(1)}g',
              style: const TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ),
          Expanded(
            child: Text(
              'F: ${item.fats.toStringAsFixed(1)}g',
              style: const TextStyle(fontSize: 12, color: Colors.purple),
            ),
          ),
          Expanded(
            child: Text(
              '${item.calories.toStringAsFixed(0)} cal',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF7ed321),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealNutrient(String label, String value, Color color) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAnalysisTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_isMobile ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(_isMobile ? 16 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7ed321).withOpacity(0.2),
                  const Color(0xFF42a5f5).withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF7ed321).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF7ed321),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'AI-Powered Meal Plan Analysis',
                        style: TextStyle(
                          fontSize: _isMobile ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Comprehensive analysis evaluating meal plan alignment with medical history, '
                  'health log patterns, and providing actionable recommendations.',
                  style: TextStyle(
                    fontSize: _isMobile ? 13 : 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: _isMobile ? 20 : 24),
          
          // Client Context Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF232823),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF2d3a2d),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.person_outline, color: Color(0xFF7ed321), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Client Context',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7ed321),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildContextChip('Age: ${widget.client.age}', Icons.cake),
                    ...widget.client.primaryConditions.map(
                      (c) => _buildContextChip(c, Icons.local_hospital),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white24),
                const SizedBox(height: 8),
                Text(
                  'Health Patterns: ${widget.client.energyLevels}, ${widget.client.cravings}, ${widget.client.bloatingIssues}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: _isMobile ? 20 : 24),
          
          // AI Analysis Card
          AIAnalysisCard(
            analysis: _aiAnalysis,
            isMobile: _isMobile,
          ),
          
          SizedBox(height: _isMobile ? 20 : 24),
          
          // Disclaimer
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF232823).withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.orange.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'AI Analysis Note: This analysis is generated based on nutritional guidelines '
                    'and client data. It should be used as a decision support tool alongside '
                    'professional judgment and client feedback.',
                    style: TextStyle(
                      fontSize: _isMobile ? 12 : 13,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2d3a2d).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF7ed321).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF7ed321), size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
