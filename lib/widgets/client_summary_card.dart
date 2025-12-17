import 'package:flutter/material.dart';
import '../models/client_profile.dart';
import '../utils/responsive.dart';

class ClientSummaryCard extends StatelessWidget {
  final ClientProfile client;

  const ClientSummaryCard({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    // Get initials from client name
    final nameParts = client.name.split(' ');
    final initials = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[1][0]}'
        : nameParts[0].substring(0, 2).toUpperCase();

    // Extract dietary preferences as tags
    final dietPref = 'Balanced Diet';
    final condition = client.condition;

    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final padding = ResponsiveHelper.getScreenPadding(context);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF232823),
        borderRadius: BorderRadius.circular(12),
      ),
      child: isMobile
          ? _buildMobileLayout(initials, condition, dietPref)
          : _buildDesktopLayout(initials, condition, dietPref, isTablet),
    );
  }

  Widget _buildMobileLayout(
    String initials,
    String condition,
    String dietPref,
  ) {
    return Column(
      children: [
        // Profile Picture and Name
        Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: const Color(0xFF7ed321),
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildInfoChip(
                        'ID:',
                        '#${client.age}920',
                        Colors.white38,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip('Age:', '${client.age}', Colors.white38),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Calorie Target
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1f1a),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    '1800',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'KCAL TARGET',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMacroRow('Protein', '120g', const Color(0xFF7ed321)),
                  const SizedBox(height: 8),
                  _buildMacroRow('Carbs', '150g', const Color(0xFF5a9ad5)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Phase badge
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2d4a2d),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Follicular Phase',
              style: TextStyle(
                color: Color(0xFF7ed321),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTag('$condition Management'),
            if (dietPref.isNotEmpty) _buildTag(dietPref),
            _buildTag('Low-Glycemic'),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(
    String initials,
    String condition,
    String dietPref,
    bool isTablet,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Picture
        CircleAvatar(
          radius: isTablet ? 40 : 50,
          backgroundColor: const Color(0xFF7ed321),
          child: Text(
            initials,
            style: TextStyle(
              fontSize: isTablet ? 28 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: isTablet ? 16 : 24),
        // Client Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                client.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 24 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildInfoChip('ID:', '#${client.age}920', Colors.white38),
                  _buildInfoChip('Age:', '${client.age}', Colors.white38),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2d4a2d),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Follicular Phase',
                      style: TextStyle(
                        color: Color(0xFF7ed321),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag('$condition Management'),
                  if (dietPref.isNotEmpty) _buildTag(dietPref),
                  _buildTag('Low-Glycemic'),
                ],
              ),
            ],
          ),
        ),
        // Calorie Target & Macros
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '1800',
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 40 : 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'KCAL TARGET',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildMacroRow('Protein', '120g', const Color(0xFF7ed321)),
            const SizedBox(height: 8),
            _buildMacroRow('Carbs', '150g', const Color(0xFF5a9ad5)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 14)),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2d3a2d),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF3d4a3d)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  Widget _buildMacroRow(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(width: 8),
        Container(
          width: 60,
          height: 6,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.8,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
