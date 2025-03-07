import 'package:flutter/material.dart';

/// A responsive layout widget that adapts to different screen sizes.
///
/// This widget helps create responsive UI by providing different layouts
/// for mobile, tablet, and desktop screen sizes. It also provides utility
/// methods for responsive measurements.
class Responsive extends StatelessWidget {
  /// The child widget to be rendered within the responsive container.
  final Widget child;

  /// Whether to wrap the content with a [SafeArea].
  final bool useSafeArea;

  /// Whether to apply safe area padding at the top.
  final bool safeAreaTop;

  /// Whether to apply safe area padding at the bottom.
  final bool safeAreaBottom;

  /// Whether to apply safe area padding on the left.
  final bool safeAreaLeft;

  /// Whether to apply safe area padding on the right.
  final bool safeAreaRight;

  /// Maximum width constraint for the content.
  final double? maxWidth;

  /// Custom padding to apply to the child widget.
  final EdgeInsets? padding;

  /// Background color for the container.
  final Color? backgroundColor;

  /// Custom builder function for mobile layout.
  final Widget Function(BuildContext, Widget)? mobileLayoutBuilder;

  /// Custom builder function for tablet layout.
  final Widget Function(BuildContext, Widget)? tabletLayoutBuilder;

  /// Custom builder function for desktop layout.
  final Widget Function(BuildContext, Widget)? desktopLayoutBuilder;

  /// Whether to show the sidebar in desktop layout.
  final bool showSidebar;

  /// Creates a responsive widget.
  ///
  /// The [child] parameter is required and defines the content of the widget.
  const Responsive({
    super.key,
    required this.child,
    this.useSafeArea = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.maxWidth,
    this.padding,
    this.backgroundColor,
    this.mobileLayoutBuilder,
    this.tabletLayoutBuilder,
    this.desktopLayoutBuilder,
    this.showSidebar = true,
  });

  /// Returns the screen width from the MediaQuery.
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Returns the screen height from the MediaQuery.
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Determines if the current screen size is considered mobile.
  ///
  /// Screen width < 600px is considered mobile.
  static bool isMobile(BuildContext context) => screenWidth(context) < 600;

  /// Determines if the current screen size is considered tablet.
  ///
  /// Screen width between 600px and 1200px is considered tablet.
  static bool isTablet(BuildContext context) =>
      screenWidth(context) >= 600 && screenWidth(context) < 1200;

  /// Determines if the current screen size is considered desktop.
  ///
  /// Screen width >= 1200px is considered desktop.
  static bool isDesktop(BuildContext context) => screenWidth(context) >= 1200;

  /// Determines if the current screen size is considered large desktop.
  ///
  /// Screen width >= 1600px is considered large desktop.
  static bool isLargeDesktop(BuildContext context) =>
      screenWidth(context) >= 1600;

  /// Determines if the device is in portrait orientation.
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  /// Determines if the device is in landscape orientation.
  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Calculates a width as a fraction of the screen width.
  ///
  /// [fraction] should be a value between 0 and 1.
  static double responsiveWidth(BuildContext context, double fraction) {
    return screenWidth(context) * fraction;
  }

  /// Calculates a height as a fraction of the screen height.
  ///
  /// [fraction] should be a value between 0 and 1.
  static double responsiveHeight(BuildContext context, double fraction) {
    return screenHeight(context) * fraction;
  }

  /// Calculates a responsive font size based on device type.
  ///
  /// [baseSize] is the starting font size.
  /// [minSize] is the minimum allowable font size (optional).
  /// [maxSize] is the maximum allowable font size (optional).
  static double responsiveFontSize(BuildContext context, double baseSize,
      {double? minSize, double? maxSize}) {
    double scaleFactor;
    if (isDesktop(context)) {
      scaleFactor = 1.2; // Larger font size for desktop
    } else if (isTablet(context)) {
      scaleFactor =
          isPortrait(context) ? 1.1 : 1.15; // Slightly larger for tablet
    } else {
      scaleFactor = isPortrait(context) ? 1.0 : 1.05; // Adjust for mobile
    }

    double size = baseSize * scaleFactor;

    if (minSize != null && size < minSize) return minSize;
    if (maxSize != null && size > maxSize) return maxSize;

    return size;
  }

  /// Returns different sizes based on the device orientation.
  ///
  /// [portraitSize] is used when device is in portrait mode.
  /// [landscapeSize] is used when device is in landscape mode.
  static double responsiveSize(
      BuildContext context, double portraitSize, double landscapeSize) {
    return isPortrait(context) ? portraitSize : landscapeSize;
  }

  /// Returns different values based on the device type.
  ///
  /// [mobile] is the value for mobile devices (required).
  /// [tablet] is the value for tablet devices (optional, falls back to mobile).
  /// [desktop] is the value for desktop devices (optional, falls back to tablet or mobile).
  /// [largeDesktop] is the value for large desktop devices (optional, falls back to desktop, tablet, or mobile).
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    if (isLargeDesktop(context)) {
      return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  /// Returns the device pixel ratio from the MediaQuery.
  static double devicePixelRatio(BuildContext context) =>
      MediaQuery.of(context).devicePixelRatio;

  /// Calculates the actual pixel size based on the logical size and device pixel ratio.
  static double actualPixelSize(BuildContext context, double logicalSize) {
    return logicalSize * devicePixelRatio(context);
  }

  /// Returns a responsive spacing value based on device type.
  ///
  /// The base value is multiplied by a factor depending on the device type:
  /// - Mobile: 1.0x
  /// - Tablet: 1.25x
  /// - Desktop: 1.5x
  static double responsiveSpacing(BuildContext context, double baseValue) {
    return responsiveValue(
      context,
      mobile: baseValue,
      tablet: baseValue * 1.25,
      desktop: baseValue * 1.5,
    );
  }

  /// Creates responsive EdgeInsets that adapt to different screen sizes.
  ///
  /// The values are multiplied by a factor depending on the device type.
  static EdgeInsets responsivePadding(
    BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    double factor =
        responsiveValue(context, mobile: 1.0, tablet: 1.25, desktop: 1.5);

    return EdgeInsets.only(
      left: (left ?? horizontal ?? all ?? 0) * factor,
      top: (top ?? vertical ?? all ?? 0) * factor,
      right: (right ?? horizontal ?? all ?? 0) * factor,
      bottom: (bottom ?? vertical ?? all ?? 0) * factor,
    );
  }

  /// Calculates a size relative to screen dimensions.
  ///
  /// [widthFraction] is the fraction of screen width (0 to 1).
  /// [heightFraction] is the fraction of screen height (0 to 1).
  static Size relativeSize(
      BuildContext context, double widthFraction, double heightFraction) {
    return Size(
      screenWidth(context) * widthFraction,
      screenHeight(context) * heightFraction,
    );
  }

  /// Builds the desktop layout, optionally including a sidebar.
  Widget _buildDesktopLayout(BuildContext context, Widget content) {
    if (!showSidebar) {
      return SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? 1200,
            ),
            child: content,
          ),
        ),
      );
    }
    return Row(
      children: [
        Container(
          width: responsiveWidth(context, isLargeDesktop(context) ? 0.2 : 0.15),
          color: Colors.grey[200],
          child: ListView(
            children: const [
              ListTile(title: Text('Menu 1')),
              ListTile(title: Text('Menu 2')),
            ],
          ),
        ),
        // Main content area
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth ?? 1000,
                ),
                child: content,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the tablet layout.
  Widget _buildTabletLayout(BuildContext context, Widget content) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? 800,
          ),
          child: content,
        ),
      ),
    );
  }
  
  /// Builds the mobile layout.
  Widget _buildMobileLayout(BuildContext context, Widget content) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? 600,
        ),
        child: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine padding based on screen size
        final effectivePadding = padding ??
            responsivePadding(
              context,
              horizontal: responsiveValue(context,
                  mobile: 16.0, tablet: 24.0, desktop: 32.0),
              vertical: 16.0,
            );

        final childWithPadding = Padding(
          padding: effectivePadding,
          child: child,
        );

        final responsiveLayout = Builder(
          builder: (context) {
            if (isDesktop(context)) {
              return desktopLayoutBuilder?.call(context, childWithPadding) ??
                  _buildDesktopLayout(context, childWithPadding);
            } else if (isTablet(context)) {
              return tabletLayoutBuilder?.call(context, childWithPadding) ??
                  _buildTabletLayout(context, childWithPadding);
            } else {
              return mobileLayoutBuilder?.call(context, childWithPadding) ??
                  _buildMobileLayout(context, childWithPadding);
            }
          },
        );

        return Container(
          color: backgroundColor ?? Colors.white,
          child: useSafeArea
              ? SafeArea(
                  top: safeAreaTop,
                  bottom: safeAreaBottom,
                  left: safeAreaLeft,
                  right: safeAreaRight,
                  child: responsiveLayout,
                )
              : responsiveLayout,
        );
      },
    );
  }
}
