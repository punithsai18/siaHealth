import 'package:flutter/material.dart';
import '../models/quality_rule.dart';

class RulesCheckScreen extends StatefulWidget {
  const RulesCheckScreen({super.key});

  @override
  State<RulesCheckScreen> createState() => _RulesCheckScreenState();
}

class _RulesCheckScreenState extends State<RulesCheckScreen> {
  late List<QualityRule> _rules;

  @override
  void initState() {
    super.initState();
    _initializeRules();
  }

  void _initializeRules() {
    _rules = [
      QualityRule(
        id: 'rule_1',
        ruleNumber: 1,
        title: 'Protein Content Check',
        description: 'Ensures main meals contain adequate protein for satiety and muscle maintenance',
        isActive: true,
        criteria: [
          'Target: 10-14g protein per main meal',
          'Warning: 8-10g or 14-20g (acceptable range)',
          'Fail: Outside acceptable range',
        ],
        appliesTo: ['Breakfast', 'Lunch', 'Dinner'],
      ),
      QualityRule(
        id: 'rule_2',
        ruleNumber: 2,
        title: 'Portion Size Specification',
        description: 'Validates that all meal items have clearly defined portions for accurate tracking',
        isActive: true,
        criteria: [
          'Must specify: quantity + unit (e.g., "2 medium pieces")',
          'Accepts: grams, bowls, pieces, cups, etc.',
          'Fail: Vague terms like "handful" or missing portions',
        ],
        appliesTo: ['All Meals', 'Snacks'],
      ),
      QualityRule(
        id: 'rule_3',
        ruleNumber: 3,
        title: 'Low-Carb Consistency (PCOS)',
        description: 'Monitors carbohydrate levels for PCOS management and insulin sensitivity',
        isActive: true,
        criteria: [
          'Optimal: ≤30g carbs per main meal',
          'Moderate: 30-45g carbs (acceptable)',
          'High: >45g carbs (needs improvement)',
        ],
        appliesTo: ['PCOS Clients Only'],
      ),
      QualityRule(
        id: 'rule_4',
        ruleNumber: 4,
        title: 'Formatting & Quality Standards',
        description: 'Ensures professional presentation with proper formatting and no errors',
        isActive: true,
        criteria: [
          'Check: Proper capitalization',
          'Check: No extra spaces or formatting issues',
          'Check: Complete nutritional information',
        ],
        appliesTo: ['All Content'],
      ),
    ];
  }

  void _toggleRule(String ruleId, bool value) {
    setState(() {
      final index = _rules.indexWhere((rule) => rule.id == ruleId);
      if (index != -1) {
        _rules[index] = _rules[index].copyWith(isActive: value);
      }
    });
  }

  void _deleteRule(String ruleId) {
    setState(() {
      // Only allow deletion of custom rules
      final ruleToDelete = _rules.firstWhere((rule) => rule.id == ruleId);
      if (!ruleToDelete.isCustom) {
        return; // Don't delete system rules
      }
      
      _rules.removeWhere((rule) => rule.id == ruleId);
      // Renumber only the remaining rules for consistent display
      for (int i = 0; i < _rules.length; i++) {
        _rules[i] = _rules[i].copyWith(ruleNumber: i + 1);
      }
    });
  }

  void _showAddCustomRuleDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final criteriaControllers = [TextEditingController()];
    final appliesToControllers = [TextEditingController()];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF232823),
              title: const Text(
                'Add Custom Rule',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 500,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Rule Title',
                          labelStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF7ed321)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descriptionController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF7ed321)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Criteria',
                        style: TextStyle(
                          color: Color(0xFF7ed321),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(criteriaControllers.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: criteriaControllers[index],
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Criterion ${index + 1}',
                                    labelStyle: const TextStyle(color: Colors.white54),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white24),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF7ed321)),
                                    ),
                                  ),
                                ),
                              ),
                              if (criteriaControllers.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () {
                                    setDialogState(() {
                                      criteriaControllers.removeAt(index);
                                    });
                                  },
                                ),
                            ],
                          ),
                        );
                      }),
                      TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            criteriaControllers.add(TextEditingController());
                          });
                        },
                        icon: const Icon(Icons.add, color: Color(0xFF7ed321)),
                        label: const Text(
                          'Add Criterion',
                          style: TextStyle(color: Color(0xFF7ed321)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Applies To',
                        style: TextStyle(
                          color: Color(0xFF7ed321),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(appliesToControllers.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: appliesToControllers[index],
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Scope ${index + 1}',
                                    labelStyle: const TextStyle(color: Colors.white54),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white24),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF7ed321)),
                                    ),
                                  ),
                                ),
                              ),
                              if (appliesToControllers.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () {
                                    setDialogState(() {
                                      appliesToControllers.removeAt(index);
                                    });
                                  },
                                ),
                            ],
                          ),
                        );
                      }),
                      TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            appliesToControllers.add(TextEditingController());
                          });
                        },
                        icon: const Icon(Icons.add, color: Color(0xFF7ed321)),
                        label: const Text(
                          'Add Scope',
                          style: TextStyle(color: Color(0xFF7ed321)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) {
                      // Show error if title is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Rule title is required'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final criteria = criteriaControllers
                        .map((c) => c.text.trim())
                        .where((text) => text.isNotEmpty)
                        .toList();
                    final appliesTo = appliesToControllers
                        .map((c) => c.text.trim())
                        .where((text) => text.isNotEmpty)
                        .toList();

                    setState(() {
                      _rules.add(
                        QualityRule(
                          id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                          ruleNumber: _rules.length + 1,
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim().isEmpty
                              ? 'Custom rule'
                              : descriptionController.text.trim(),
                          criteria: criteria.isNotEmpty ? criteria : ['No criteria specified'],
                          appliesTo: appliesTo.isNotEmpty ? appliesTo : ['All'],
                          isActive: true,
                          isCustom: true,
                        ),
                      );
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7ed321),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Add Rule'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quality Control Rules',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Configure automated quality check rules for meal plans',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 32),
          // Display all rules
          ..._rules.map((rule) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildRuleCard(rule),
              )),
          const SizedBox(height: 32),
          // Add Custom Rule Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showAddCustomRuleDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Custom Rule'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7ed321),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Statistics Card
          Container(
            padding: const EdgeInsets.all(28),
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
                const Text(
                  'Check Statistics (Last 30 Days)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Total Checks',
                        '247',
                        Icons.assessment,
                        const Color(0xFF42a5f5),
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Passed',
                        '189',
                        Icons.check_circle,
                        const Color(0xFF7ed321),
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Warnings',
                        '42',
                        Icons.warning,
                        const Color(0xFFffa726),
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Failed',
                        '16',
                        Icons.error,
                        const Color(0xFFef5350),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(QualityRule rule) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF232823),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: rule.isActive 
              ? const Color(0xFF7ed321).withOpacity(0.4) 
              : const Color(0xFF2d3a2d),
          width: rule.isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (rule.isActive ? const Color(0xFF7ed321) : Colors.black).withOpacity(0.15),
            blurRadius: rule.isActive ? 10 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: rule.isActive
                        ? [
                            const Color(0xFF7ed321).withOpacity(0.3),
                            const Color(0xFF7ed321).withOpacity(0.1),
                          ]
                        : [
                            const Color(0xFF2d3a2d),
                            const Color(0xFF1a1f1a),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: rule.isActive
                        ? const Color(0xFF7ed321).withOpacity(0.5)
                        : Colors.white24,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${rule.ruleNumber}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: rule.isActive
                          ? const Color(0xFF7ed321)
                          : Colors.white54,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            rule.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (rule.isCustom)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7ed321).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFF7ed321),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              'CUSTOM',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7ed321),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rule.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: rule.isActive,
                onChanged: (value) => _toggleRule(rule.id, value),
                activeColor: const Color(0xFF7ed321),
              ),
              if (rule.isCustom)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteRule(rule.id),
                  tooltip: 'Delete custom rule',
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Criteria:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7ed321),
            ),
          ),
          const SizedBox(height: 8),
          ...rule.criteria.map((criterion) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        criterion,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: rule.appliesTo.map((scope) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2d3a2d),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  scope,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2d3a2d).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white54,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
