import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool emailDigest = true;
  bool darkMode = true;
  String selectedLanguage = 'English';

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
            'Settings',
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobile ? 4 : 8),
          const Text(
            'Manage your preferences and account settings',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
          SizedBox(height: spacing),
          // Profile Settings
          _buildSectionHeader('Profile Settings'),
          const SizedBox(height: 16),
          _buildSettingCard(
            icon: Icons.person,
            title: 'Personal Information',
            subtitle: 'Update your name, email, and profile picture',
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.lock,
            title: 'Change Password',
            subtitle: 'Update your account password',
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
          ),
          const SizedBox(height: 32),
          // Notification Settings
          _buildSectionHeader('Notification Settings'),
          const SizedBox(height: 16),
          _buildSettingCard(
            icon: Icons.notifications,
            title: 'Push Notifications',
            subtitle: 'Receive alerts for client updates',
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
              activeColor: const Color(0xFF7ed321),
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.email,
            title: 'Email Digest',
            subtitle: 'Daily summary of pending reviews',
            trailing: Switch(
              value: emailDigest,
              onChanged: (value) {
                setState(() {
                  emailDigest = value;
                });
              },
              activeColor: const Color(0xFF7ed321),
            ),
          ),
          const SizedBox(height: 32),
          // Appearance
          _buildSectionHeader('Appearance'),
          const SizedBox(height: 16),
          _buildSettingCard(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Use dark theme throughout the app',
            trailing: Switch(
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
              activeColor: const Color(0xFF7ed321),
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.language,
            title: 'Language',
            subtitle: selectedLanguage,
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
          ),
          const SizedBox(height: 32),
          // Quality Check Settings
          _buildSectionHeader('Quality Check Settings'),
          const SizedBox(height: 16),
          _buildSettingCard(
            icon: Icons.rule,
            title: 'Check Thresholds',
            subtitle: 'Configure protein, carb, and portion rules',
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.auto_awesome,
            title: 'AI Assistant',
            subtitle: 'Configure AI-powered meal plan analysis',
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
          ),
          const SizedBox(height: 32),
          // About
          _buildSectionHeader('About'),
          const SizedBox(height: 16),
          _buildSettingCard(
            icon: Icons.info,
            title: 'App Version',
            subtitle: 'Version 1.0.0',
            trailing: const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get help with using the app',
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
          ),
          const SizedBox(height: 32),
          // Sign Out Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF7ed321),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF232823),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF2d3a2d),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7ed321).withOpacity(0.25),
                  const Color(0xFF7ed321).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF7ed321).withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF7ed321),
              size: 26,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          trailing,
        ],
      ),
    );
  }
}
