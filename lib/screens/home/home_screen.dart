// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/home/widgets/clinical_results.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Track the selected navigation index.
  int _selectedIndex = 0;

  // Navigation handler for bottom nav items.
  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation state here.
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/profile');
        break;
      case 2:
        Navigator.pushNamed(context, '/new');
        break;
      case 3:
        Navigator.pushNamed(context, '/history');
        break;
    }
  }

  // Build a nav item with icon, label, and animated dot indicator if selected.
  Widget _buildNavItem({
    required int index,
    required IconData iconData,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;
    final Color itemColor = isSelected ? AppColors.primary : AppColors.text1;
    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: 22,
            color: itemColor,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: isSelected
                ? Container(
                    key: ValueKey("dot$index"),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: itemColor,
                      shape: BoxShape.circle,
                    ),
                  )
                : SizedBox(
                    key: ValueKey("empty$index"),
                    height: 6,
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.gray4.withOpacity(0.7),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: BottomAppBar(
            clipBehavior: Clip.antiAlias,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                      index: 0, iconData: LucideIcons.house, label: "Home"),
                  _buildNavItem(
                      index: 1, iconData: LucideIcons.user, label: "Profile"),
                  _buildNavItem(
                      index: 2,
                      iconData: LucideIcons.clipboardPlus,
                      label: "New"),
                  _buildNavItem(
                      index: 3,
                      iconData: LucideIcons.fileClock,
                      label: "History"),
                ],
              ),
            ),
          ),
        ),
        // Body content.
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/300'),
                    ),
                    PviText(
                      text: '¡Hola, Juan!',
                      style: AppFonts.headline2,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.gray4,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PviText(
                          text: 'Realiza un nuevo check-up',
                          style: AppFonts.body2.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: PviButton(
                            child: PviText(
                              text: 'Subir archivo',
                              style: AppFonts.button1.copyWith(
                                color: AppColors.background,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                PviText(
                  text: 'Estos son tus últimos resultados',
                  style: AppFonts.headline3,
                ),
                const ClinicalResults(),
                const ClinicalResults(),
                const ClinicalResults(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
