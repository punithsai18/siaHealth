import 'package:flutter/material.dart';
import '../models/ai_analysis.dart';

/// Widget to display AI-powered meal plan analysis results
class AIAnalysisCard extends StatelessWidget {
  final AIAnalysisResult analysis;
  final bool isMobile;
  
  // Theme colors
  static const Color _primaryGreen = Color(0xFF7ed321);
  static const Color _primaryBlue = Color(0xFF42a5f5);
  static const Color _backgroundDark = Color(0xFF232823);
  static const Color _backgroundMedium = Color(0xFF2d3a2d);

  const AIAnalysisCard({
    super.key,
    required this.analysis,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _primaryGreen.withOpacity(0.1),
            _primaryBlue.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryGreen.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryGreen.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.black,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Meal Plan Analysis',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Powered by advanced nutritional intelligence',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: isMobile ? 20 : 24),
          
          // Overall Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _primaryGreen.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.summarize, color: _primaryGreen, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Overall Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  analysis.summary,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: isMobile ? 16 : 20),
          
          // Question 1: Medical History Alignment
          _buildAnalysisSection(
            icon: Icons.medical_services,
            title: '1. Medical History Alignment',
            subtitle: analysis.medicalHistoryAlignment.explanation,
            isPositive: analysis.medicalHistoryAlignment.isAligned,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (analysis.medicalHistoryAlignment.strengths.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildSubSection(
                    '✅ Strengths',
                    analysis.medicalHistoryAlignment.strengths,
                    Colors.green,
                  ),
                ],
                if (analysis.medicalHistoryAlignment.concerns.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildSubSection(
                    '⚠️ Areas for Attention',
                    analysis.medicalHistoryAlignment.concerns,
                    Colors.orange,
                  ),
                ],
              ],
            ),
          ),
          
          SizedBox(height: isMobile ? 16 : 20),
          
          // Question 2: Health Log Contradictions
          _buildAnalysisSection(
            icon: Icons.warning_amber_rounded,
            title: '2. Health Log Contradictions',
            subtitle: analysis.healthLogContradictions.explanation,
            isPositive: !analysis.healthLogContradictions.hasContradictions,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (analysis.healthLogContradictions.contradictions.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildSubSection(
                    '⚠️ Contradictions Found',
                    analysis.healthLogContradictions.contradictions,
                    Colors.red,
                  ),
                ],
                if (analysis.healthLogContradictions.suggestions.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildSubSection(
                    '💡 Suggestions',
                    analysis.healthLogContradictions.suggestions,
                    _primaryGreen,
                  ),
                ],
              ],
            ),
          ),
          
          SizedBox(height: isMobile ? 16 : 20),
          
          // Question 3: High-Level Recommendations
          _buildRecommendationsSection(),
        ],
      ),
    );
  }
  
  Widget _buildAnalysisSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isPositive,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPositive 
              ? Colors.green.withOpacity(0.3)
              : Colors.orange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isPositive ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 15 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(
                isPositive ? Icons.check_circle : Icons.info,
                color: isPositive ? Colors.green : Colors.orange,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isMobile ? 13 : 14,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          child,
        ],
      ),
    );
  }
  
  Widget _buildSubSection(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
  
  Widget _buildRecommendationsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _primaryGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb,
                color: _primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '3. High-Level Recommendations',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...analysis.recommendations.asMap().entries.map((entry) {
            final index = entry.key;
            final rec = entry.value;
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 16),
                _buildRecommendationCard(rec, index + 1),
              ],
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildRecommendationCard(Recommendation rec, int number) {
    Color priorityColor;
    switch (rec.priority) {
      case RecommendationPriority.high:
        priorityColor = Colors.red;
        break;
      case RecommendationPriority.medium:
        priorityColor = Colors.orange;
        break;
      case RecommendationPriority.low:
        priorityColor = Colors.green;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _backgroundMedium.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: priorityColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: priorityColor, width: 1),
                ),
                child: Text(
                  '${rec.priority.emoji} ${rec.priority.displayName}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$number. ${rec.title}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            rec.description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          if (rec.actionableSteps.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Actionable Steps:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _primaryGreen,
              ),
            ),
            const SizedBox(height: 6),
            ...rec.actionableSteps.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key + 1}. ',
                      style: const TextStyle(
                        fontSize: 12,
                        color: _primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
