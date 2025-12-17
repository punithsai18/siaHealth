import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Stay updated with client reviews and system alerts',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check_circle, size: 16),
                      label: const Text('Mark all as read'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF7ed321),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Stay updated with client reviews and system alerts',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check_circle, size: 18),
                      label: const Text('Mark all as read'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF7ed321),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: spacing),
          // Today Section
          _buildDateSection('Today'),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.assignment,
            iconColor: const Color(0xFFffa726),
            title: 'Meal Plan Review Pending',
            message: 'Priya Sharma\'s meal plan is ready for review',
            time: '2 hours ago',
            isUnread: true,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF7ed321),
            title: 'Review Approved',
            message: 'You approved Anjali Patel\'s meal plan',
            time: '5 hours ago',
            isUnread: true,
          ),
          const SizedBox(height: 24),
          // Yesterday Section
          _buildDateSection('Yesterday'),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.person_add,
            iconColor: const Color(0xFF42a5f5),
            title: 'New Client Added',
            message: 'Meera Singh has been assigned to you',
            time: '1 day ago',
            isUnread: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.warning,
            iconColor: const Color(0xFFef5350),
            title: 'Quality Check Failed',
            message: 'Kavya Reddy\'s plan needs improvements',
            time: '1 day ago',
            isUnread: false,
          ),
          const SizedBox(height: 24),
          // This Week Section
          _buildDateSection('This Week'),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.update,
            iconColor: const Color(0xFF7ed321),
            title: 'System Update',
            message: 'New quality check rules have been added',
            time: '3 days ago',
            isUnread: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.comment,
            iconColor: const Color(0xFF42a5f5),
            title: 'Client Feedback',
            message: 'Priya Sharma left feedback on her meal plan',
            time: '4 days ago',
            isUnread: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.verified,
            iconColor: const Color(0xFF7ed321),
            title: 'All Checks Passed',
            message: 'Anjali Patel\'s meal plan passed all quality checks',
            time: '5 days ago',
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(String date) {
    return Text(
      date,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isUnread
            ? const Color(0xFF2d3a2d)
            : const Color(0xFF232823),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnread 
              ? const Color(0xFF7ed321).withOpacity(0.4) 
              : const Color(0xFF2d3a2d),
          width: isUnread ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isUnread ? const Color(0xFF7ed321) : Colors.black).withOpacity(0.15),
            blurRadius: isUnread ? 10 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withOpacity(0.3),
                  iconColor.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: iconColor.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 18),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7ed321),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7ed321).withOpacity(0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.white38,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white38,
                        fontStyle: FontStyle.italic,
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
}
