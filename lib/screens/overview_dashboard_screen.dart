import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class OverviewDashboardScreen extends StatelessWidget {
  const OverviewDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getScreenPadding(context);
    final spacing = ResponsiveHelper.getSpacing(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final columns = ResponsiveHelper.getGridColumns(context, mobile: 2, tablet: 2, desktop: 4);
    
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobile ? 4 : 8),
          const Text(
            'Overview of your clients and recent activities',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
          SizedBox(height: spacing),
          // Stats Cards - Responsive Grid
          _buildStatsGrid(context, columns, spacing),
          SizedBox(height: spacing),
          // Recent Activity Section - Responsive
          _buildActivitySection(context, spacing),
          SizedBox(height: spacing),
          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: spacing / 2),
          _buildQuickActions(context, columns, spacing),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.3),
                      color.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.5), width: 1),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up, color: color, size: 14),
                const SizedBox(width: 6),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String clientName,
    required String status,
    required Color statusColor,
    required String time,
    required String condition,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF232823),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2d3a2d),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7ed321).withOpacity(0.3),
                  const Color(0xFF7ed321).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF7ed321),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF7ed321),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clientName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2d3a2d),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        condition,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF232823),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2d3a2d),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
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
              border: Border.all(color: color.withOpacity(0.5), width: 1),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7ed321).withOpacity(0.3),
                  const Color(0xFF7ed321).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF7ed321).withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF7ed321),
              size: 36,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, int columns, double spacing) {
    final stats = [
      ('Total Clients', '24', Icons.people, const Color(0xFF7ed321), '+3 this month'),
      ('Pending Reviews', '7', Icons.pending_actions, const Color(0xFFffa726), '2 urgent'),
      ('Approved Today', '12', Icons.check_circle, const Color(0xFF42a5f5), '+4 from yesterday'),
      ('Quality Score', '94%', Icons.verified, const Color(0xFF7ed321), '+2% this week'),
    ];

    return Wrap(
      spacing: spacing / 2,
      runSpacing: spacing / 2,
      children: stats.map((stat) => SizedBox(
        width: ResponsiveHelper.getContentWidth(
          context, 
          columns: columns, 
          extraSpacing: spacing * (columns + 1)
        ),
        child: _buildStatCard(
          title: stat.$1,
          value: stat.$2,
          icon: stat.$3,
          color: stat.$4,
          trend: stat.$5,
        ),
      )).toList(),
    );
  }

  Widget _buildActivitySection(BuildContext context, double spacing) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: spacing / 2),
          _buildReviewItem(
            clientName: 'Priya Sharma',
            status: 'Pending',
            statusColor: const Color(0xFFffa726),
            time: '2 hours ago',
            condition: 'PCOS',
          ),
          const SizedBox(height: 12),
          _buildReviewItem(
            clientName: 'Anjali Patel',
            status: 'Approved',
            statusColor: const Color(0xFF7ed321),
            time: '5 hours ago',
            condition: 'Thyroid',
          ),
          SizedBox(height: spacing),
          const Text(
            'This Week',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: spacing / 2),
          _buildQuickStatCard(
            title: 'Reviews Completed',
            value: '45',
            icon: Icons.done_all,
            color: const Color(0xFF7ed321),
          ),
          const SizedBox(height: 12),
          _buildQuickStatCard(
            title: 'Avg. Review Time',
            value: '8 min',
            icon: Icons.timer,
            color: const Color(0xFF42a5f5),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildReviewItem(
                clientName: 'Priya Sharma',
                status: 'Pending',
                statusColor: const Color(0xFFffa726),
                time: '2 hours ago',
                condition: 'PCOS',
              ),
              const SizedBox(height: 12),
              _buildReviewItem(
                clientName: 'Anjali Patel',
                status: 'Approved',
                statusColor: const Color(0xFF7ed321),
                time: '5 hours ago',
                condition: 'Thyroid',
              ),
              const SizedBox(height: 12),
              _buildReviewItem(
                clientName: 'Meera Singh',
                status: 'Needs Changes',
                statusColor: const Color(0xFFef5350),
                time: '1 day ago',
                condition: 'PCOS',
              ),
              const SizedBox(height: 12),
              _buildReviewItem(
                clientName: 'Kavya Reddy',
                status: 'Approved',
                statusColor: const Color(0xFF7ed321),
                time: '1 day ago',
                condition: 'Cycle Health',
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This Week',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildQuickStatCard(
                title: 'Reviews Completed',
                value: '45',
                icon: Icons.done_all,
                color: const Color(0xFF7ed321),
              ),
              const SizedBox(height: 12),
              _buildQuickStatCard(
                title: 'Avg. Review Time',
                value: '8 min',
                icon: Icons.timer,
                color: const Color(0xFF42a5f5),
              ),
              const SizedBox(height: 12),
              _buildQuickStatCard(
                title: 'Quality Checks Run',
                value: '152',
                icon: Icons.verified_outlined,
                color: const Color(0xFFffa726),
              ),
              const SizedBox(height: 12),
              _buildQuickStatCard(
                title: 'Active Clients',
                value: '22',
                icon: Icons.person_outline,
                color: const Color(0xFF7ed321),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, int columns, double spacing) {
    final actions = [
      (Icons.person_add, 'Add New Client', 'Create a new client profile'),
      (Icons.restaurant_menu, 'Create Meal Plan', 'Start a new meal plan'),
      (Icons.rule, 'Run Quality Check', 'Check meal plan quality'),
      (Icons.settings, 'Configure Rules', 'Adjust quality rules'),
    ];

    return Wrap(
      spacing: spacing / 2,
      runSpacing: spacing / 2,
      children: actions.map((action) => SizedBox(
        width: ResponsiveHelper.getContentWidth(
          context, 
          columns: columns, 
          extraSpacing: spacing * (columns + 1)
        ),
        child: _buildActionCard(
          icon: action.$1,
          title: action.$2,
          description: action.$3,
        ),
      )).toList(),
    );
  }
}
