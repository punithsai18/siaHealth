import 'package:flutter/material.dart';
import '../models/client_profile.dart';
import '../models/meal_item.dart';
import '../utils/responsive.dart';
import 'client_profile_screen.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getScreenPadding(context);
    final spacing = ResponsiveHelper.getSpacing(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clients',
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobile ? 4 : 8),
          const Text(
            'Manage your client profiles and health records',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
          SizedBox(height: spacing),
          // Client List
          _buildClientCard(
            context,
            name: 'Priya Sharma',
            age: 28,
            condition: 'PCOS',
            status: 'Active',
            lastReview: '2 days ago',
          ),
          const SizedBox(height: 12),
          _buildClientCard(
            context,
            name: 'Anjali Patel',
            age: 32,
            condition: 'Thyroid',
            status: 'Review Pending',
            lastReview: '1 week ago',
          ),
          const SizedBox(height: 12),
          _buildClientCard(
            context,
            name: 'Meera Singh',
            age: 26,
            condition: 'PCOS',
            status: 'Active',
            lastReview: '3 days ago',
          ),
          const SizedBox(height: 12),
          _buildClientCard(
            context,
            name: 'Kavya Reddy',
            age: 30,
            condition: 'Cycle Health',
            status: 'Active',
            lastReview: '1 day ago',
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(
    BuildContext context, {
    required String name,
    required int age,
    required String condition,
    required String status,
    required String lastReview,
  }) {
    final isPending = status == 'Review Pending';
    final isMobile = ResponsiveHelper.isMobile(context);
    
    if (isMobile) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF232823),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPending ? const Color(0xFFffa726) : const Color(0xFF2d3a2d),
            width: isPending ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF7ed321).withOpacity(0.3),
                        const Color(0xFF7ed321).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF7ed321), width: 2),
                  ),
                  child: const Icon(Icons.person, color: Color(0xFF7ed321), size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isPending
                                ? [const Color(0xFFffa726), const Color(0xFFff9800)]
                                : [const Color(0xFF7ed321), const Color(0xFF6bc116)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2d3a2d),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cake, color: Colors.white54, size: 14),
                      const SizedBox(width: 4),
                      Text('Age: $age', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2d3a2d),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF7ed321).withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.medical_services, color: Color(0xFF7ed321), size: 14),
                      const SizedBox(width: 4),
                      Text(condition, style: const TextStyle(fontSize: 12, color: Color(0xFF7ed321))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white38, size: 12),
                const SizedBox(width: 4),
                Text(
                  'Last review: $lastReview',
                  style: const TextStyle(fontSize: 12, color: Colors.white38),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientProfileScreen(
                        client: ClientProfile.getClientByName(name),
                        mealPlan: MealPlan.getSampleMealPlan(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text('View Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7ed321),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    // Desktop/Tablet layout
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF232823),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPending ? const Color(0xFFffa726) : const Color(0xFF2d3a2d),
          width: isPending ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isPending ? const Color(0xFFffa726) : Colors.black).withOpacity(0.2),
            blurRadius: isPending ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with gradient
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7ed321).withOpacity(0.3),
                  const Color(0xFF7ed321).withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF7ed321),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF7ed321),
              size: 36,
            ),
          ),
          const SizedBox(width: 24),
          // Client Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isPending
                              ? [const Color(0xFFffa726), const Color(0xFFff9800)]
                              : [const Color(0xFF7ed321), const Color(0xFF6bc116)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: (isPending ? const Color(0xFFffa726) : const Color(0xFF7ed321))
                                .withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.cake,
                      color: Colors.white54,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Age: $age',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2d3a2d),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF7ed321).withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.medical_services,
                            color: Color(0xFF7ed321),
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            condition,
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white38,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Last review: $lastReview',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white38,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action Button
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7ed321),
                  Color(0xFF6bc116),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7ed321).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to client profile screen with specific client data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientProfileScreen(
                      client: ClientProfile.getClientByName(name),
                      mealPlan: MealPlan.getSampleMealPlan(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.visibility, size: 20),
              label: const Text(
                'View Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
