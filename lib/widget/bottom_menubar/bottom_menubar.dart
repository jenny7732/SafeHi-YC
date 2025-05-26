import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/provider/nav/bottom_nav_provider.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';

class BottomMenubar extends StatelessWidget {
  const BottomMenubar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<BottomNavProvider>();
    final currentIndex = navProvider.currentIndex;
    final responsive = Responsive(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (newIndex) {
        navProvider.setIndex(newIndex);
      },
      backgroundColor: AppColors().background,
      selectedItemColor: AppColors().primary,
      unselectedItemColor: const Color(0xFFB3A5A5),
      type: BottomNavigationBarType.fixed,
      selectedFontSize: responsive.fontBase,
      unselectedFontSize: responsive.fontSmall,
      iconSize: responsive.iconSize,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          label: '이전기록',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '마이페이지',
        ),
      ],
    );
  }
}
