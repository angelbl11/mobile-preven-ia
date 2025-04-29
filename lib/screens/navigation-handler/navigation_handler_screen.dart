// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-files/health_files_controller.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-form/health_form_controller.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/screens/home/home_screen.dart';
import 'package:mobile_preven_ia_app/screens/upload-file/upload_file_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class NavigationHandlerScreen extends ConsumerWidget {
  NavigationHandlerScreen({super.key});

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const UploadFileScreen(), // Placeholder for health form screen
      const Center(
          child: Text(
              'Health Files Screen')), // Placeholder for health files screen
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(LucideIcons.house, size: 22),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: AppColors.text1,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(LucideIcons.clipboardPlus,
            size: 22, color: Colors.white),
        activeColorPrimary: AppColors.primary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(LucideIcons.fileClock, size: 22),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: AppColors.text1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      backgroundColor: AppColors.gray4,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: 60,
      confineToSafeArea: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
        colorBehindNavBar: Colors.transparent,
      ),
      navBarStyle: NavBarStyle.style15,
      onItemSelected: (index) {
        ref.invalidate(healthFilesControllerProvider);
        ref.invalidate(healthFormControllerProvider);
      },
    );
  }
}
