import 'package:flutter/material.dart';
import '../models/client_profile.dart';
import '../models/meal_item.dart';
import '../models/quality_check.dart';
import '../models/user.dart';
import '../models/user_role.dart';
import '../services/quality_check_service.dart';
import '../widgets/client_summary_card.dart';
import '../widgets/meal_plan_card.dart';
import '../widgets/quality_check_card.dart';
import '../widgets/chatbot_floating_button.dart';
import '../utils/responsive.dart';
import 'overview_dashboard_screen.dart';
import 'clients_screen.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';
import 'rules_check_screen.dart';
import 'client_profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Navigation indices
  static const int dashboardIndex = 0;
  static const int clientsIndex = 1;
  static const int mealPlansIndex = 2;
  static const int qualityControlIndex = 3;
  static const int settingsIndex = 4;
  static const int notificationsIndex = 5;
  
  late ClientProfile client;
  late MealPlan mealPlan;
  late List<QualityCheckResult> checkResults;
  late User currentUser; // Current logged-in user
  bool isLoading = true;
  int selectedNavIndex = dashboardIndex; // Dashboard selected by default

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        // Set current user - for this demo, we'll use a Health Coach
        // In production, this would come from authentication
        currentUser = User.getSampleHealthCoach();
        
        client = ClientProfile.getSampleClient();
        mealPlan = MealPlan.getSampleMealPlan();
        checkResults = QualityCheckService.runAllChecks(mealPlan);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Scaffold(
      drawer: isMobile ? _buildDrawer() : null,
      bottomNavigationBar: isMobile ? _buildBottomNav() : null,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Row(
                  children: [
                    // Left Sidebar Navigation (hidden on mobile)
                    if (!isMobile) _buildSidebar(),
                    // Main Content Area
                    Expanded(
                      child: Column(
                        children: [
                          // Top App Bar
                          _buildTopBar(),
                          // Content
                          Expanded(
                            child: _buildContent(),
                          ),
                          // Bottom Action Bar (only show on Meal Plans page and not on mobile)
                          if (selectedNavIndex == mealPlansIndex && !isMobile)
                            _buildBottomActionBar(),
                        ],
                      ),
                    ),
                  ],
                ),
                // AI Chatbot Button
                const ChatbotFloatingButton(),
              ],
            ),
    );
  }

  Widget _buildContent() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final padding = ResponsiveHelper.getScreenPadding(context);
    final spacing = ResponsiveHelper.getSpacing(context);
    
    switch (selectedNavIndex) {
      case dashboardIndex:
        return const OverviewDashboardScreen();
      case clientsIndex:
        return const ClientsScreen();
      case mealPlansIndex:
        // Meal Plans view - responsive layout
        if (isMobile) {
          // Mobile: Single column with expandable quality check
          return SingleChildScrollView(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClientSummaryCard(client: client),
                SizedBox(height: spacing),
                MealPlanCard(
                  mealPlan: mealPlan,
                  client: client,
                  onEditPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientProfileScreen(
                          client: client,
                          mealPlan: mealPlan,
                          initialTabIndex: 1,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: spacing),
                // Quality checks as expandable card on mobile
                _buildMobileQualityCheck(),
                SizedBox(height: spacing),
                // Mobile action buttons
                if (selectedNavIndex == mealPlansIndex) _buildMobileActionButtons(),
              ],
            ),
          );
        } else {
          // Tablet/Desktop: Two column layout
          return Row(
            children: [
              // Left Content (Client + Meal Plan)
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClientSummaryCard(client: client),
                      SizedBox(height: spacing),
                      MealPlanCard(
                        mealPlan: mealPlan,
                        client: client,
                        onEditPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClientProfileScreen(
                                client: client,
                                mealPlan: mealPlan,
                                initialTabIndex: 1,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Right Sidebar (Quality Control)
              Container(
                width: ResponsiveHelper.isTablet(context) ? 320 : 400,
                color: const Color(0xFF1a1f1a),
                child: QualityCheckCard(results: checkResults),
              ),
            ],
          );
        }
      case qualityControlIndex:
        return const RulesCheckScreen();
      case settingsIndex:
        return const SettingsScreen();
      case notificationsIndex:
        return const NotificationsScreen();
      default:
        return const OverviewDashboardScreen();
    }
  }

  Widget _buildSidebar() {
    final isTablet = ResponsiveHelper.isTablet(context);
    final width = ResponsiveHelper.getSidebarWidth(context);
    
    return Container(
      width: width,
      color: const Color(0xFF151815),
      child: Column(
        children: [
          // Logo
          Padding(
            padding: EdgeInsets.all(isTablet ? 16.0 : 24.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7ed321),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.spa, color: Colors.white, size: 24),
                ),
                if (!isTablet) ...[
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SIA Health',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Coach Portal',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: isTablet ? 16 : 24),
          // Navigation Items
          _buildNavItem(Icons.dashboard, 'Dashboard', dashboardIndex, isTablet),
          _buildNavItem(Icons.people, 'Clients', clientsIndex, isTablet),
          _buildNavItem(Icons.restaurant_menu, 'Meal Plans', mealPlansIndex, isTablet),
          _buildNavItem(Icons.verified, 'Quality Control', qualityControlIndex, isTablet),
          _buildNavItem(Icons.settings, 'Settings', settingsIndex, isTablet),
          const Spacer(),
          // User Profile at bottom
          Container(
            margin: EdgeInsets.all(isTablet ? 8 : 16),
            padding: EdgeInsets.all(isTablet ? 8 : 12),
            decoration: BoxDecoration(
              color: const Color(0xFF232823),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: isTablet ? 16 : 20,
                  backgroundColor: _getRoleColor(currentUser.role),
                  child: Icon(Icons.person, color: Colors.white, size: isTablet ? 16 : 20),
                ),
                if (!isTablet) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          currentUser.title ?? currentUser.role.displayName,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, [bool compact = false]) {
    final isSelected = selectedNavIndex == index;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: compact ? 8 : 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2d3a2d) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF7ed321) : Colors.white54,
          size: 22,
        ),
        title: compact ? null : Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          setState(() {
            selectedNavIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildTopBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    return Container(
      height: isMobile ? 60 : 70,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1a1f1a),
        border: Border(
          bottom: BorderSide(color: Color(0xFF2d3a2d), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Menu button on mobile
          if (isMobile) ...[
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white54),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            const SizedBox(width: 8),
          ],
          // Search Bar
          Expanded(
            child: Container(
              height: isMobile ? 40 : 45,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
              decoration: BoxDecoration(
                color: const Color(0xFF232823),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white38, size: 20),
                  SizedBox(width: isMobile ? 8 : 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: isMobile ? 'Search...' : 'Search client by name or ID...',
                        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: isMobile ? 8 : 16),
          // User Role Badge (hide on mobile)
          if (!isMobile) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getRoleColor(currentUser.role).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _getRoleColor(currentUser.role),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getRoleIcon(currentUser.role),
                    color: _getRoleColor(currentUser.role),
                    size: 16,
                  ),
                  if (!isTablet) ...[
                    const SizedBox(width: 6),
                    Text(
                      currentUser.role.displayName,
                      style: TextStyle(
                        color: _getRoleColor(currentUser.role),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
          // Review Pending Badge (hide text on tablet)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: (isMobile || isTablet) ? 8 : 12, 
              vertical: 8
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFffa726),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, color: Colors.white, size: 8),
                if (!isMobile && !isTablet) ...[
                  const SizedBox(width: 6),
                  const Text(
                    'Review Pending',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: isMobile ? 8 : 16),
          // Notification Bell
          InkWell(
            onTap: () {
              setState(() {
                selectedNavIndex = notificationsIndex;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF232823),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.notifications, color: Colors.white54, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF151815),
        border: Border(
          top: BorderSide(color: Color(0xFF2d3a2d), width: 1),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Add notes for the client...',
                hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(width: 16),
          // Reject Button
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reject'),
          ),
          const SizedBox(width: 12),
          // Approve Button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7ed321),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, size: 18),
                SizedBox(width: 8),
                Text(
                  'Approve & Send',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mobile drawer
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF151815),
      child: Column(
        children: [
          // Logo header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7ed321),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.spa, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIA Health',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Coach Portal',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF2d3a2d)),
          const SizedBox(height: 16),
          // Navigation Items
          _buildNavItem(Icons.dashboard, 'Dashboard', dashboardIndex),
          _buildNavItem(Icons.people, 'Clients', clientsIndex),
          _buildNavItem(Icons.restaurant_menu, 'Meal Plans', mealPlansIndex),
          _buildNavItem(Icons.verified, 'Quality Control', qualityControlIndex),
          _buildNavItem(Icons.settings, 'Settings', settingsIndex),
          const Spacer(),
          // User Profile at bottom
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF232823),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _getRoleColor(currentUser.role),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        currentUser.title ?? currentUser.role.displayName,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mobile bottom navigation
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF151815),
      selectedItemColor: const Color(0xFF7ed321),
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedNavIndex > 4 ? 0 : selectedNavIndex,
      onTap: (index) {
        setState(() {
          selectedNavIndex = index;
        });
        // Close drawer if open
        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.pop(context);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Clients',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Meals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.verified),
          label: 'Quality',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  // Mobile quality check expandable widget
  Widget _buildMobileQualityCheck() {
    return ExpansionTile(
      title: const Text(
        'Quality Checks',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconColor: const Color(0xFF7ed321),
      collapsedIconColor: Colors.white54,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: QualityCheckCard(results: checkResults),
        ),
      ],
    );
  }

  // Mobile action buttons
  Widget _buildMobileActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151815),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              hintText: 'Add notes for the client...',
              hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2d3a2d)),
              ),
            ),
            style: TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
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
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7ed321),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Approve & Send',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods for role-based UI
  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.client:
        return const Color(0xFF42a5f5); // Blue for clients
      case UserRole.nutritionist:
        return const Color(0xFF7ed321); // Green for nutritionists
      case UserRole.healthCoach:
        return const Color(0xFFffa726); // Orange for health coaches
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.client:
        return Icons.person;
      case UserRole.nutritionist:
        return Icons.restaurant_menu;
      case UserRole.healthCoach:
        return Icons.verified_user;
    }
  }
}
