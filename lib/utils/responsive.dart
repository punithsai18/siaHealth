import 'package:flutter/material.dart';

/// Responsive breakpoints for the app
/// Mobile: < 600px
/// Tablet: 600px - 1200px
/// Desktop: >= 1200px
class Breakpoints {
  static const double mobile = 600;
  static const double desktop = 1200;
}

/// Responsive helper class to determine device type
class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < Breakpoints.mobile;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Breakpoints.mobile && width < Breakpoints.desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.desktop;
  }

  static bool isMobileOrTablet(BuildContext context) {
    return MediaQuery.of(context).size.width < Breakpoints.desktop;
  }

  /// Returns the sidebar width based on screen size
  static double getSidebarWidth(BuildContext context) {
    if (isMobile(context)) return 0; // Hidden on mobile
    if (isTablet(context)) return 200; // Narrower on tablet
    return 240; // Full width on desktop
  }

  /// Returns the number of columns for grid layouts
  static int getGridColumns(BuildContext context, {int mobile = 1, int tablet = 2, int desktop = 3}) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Returns responsive padding
  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(16);
    if (isTablet(context)) return const EdgeInsets.all(20);
    return const EdgeInsets.all(24);
  }

  /// Returns responsive spacing
  static double getSpacing(BuildContext context, {double mobile = 12, double tablet = 16, double desktop = 24}) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Calculates content width accounting for sidebar and spacing
  static double getContentWidth(BuildContext context, {int columns = 1, double extraSpacing = 0}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = getSidebarWidth(context);
    final spacing = getSpacing(context);
    
    // Calculate total spacing needed
    final totalSpacing = (columns - 1) * spacing + extraSpacing;
    
    return (screenWidth - sidebarWidth - totalSpacing) / columns;
  }
}

/// Responsive widget that builds different widgets based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (ResponsiveHelper.isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}
