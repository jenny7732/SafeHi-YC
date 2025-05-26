import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safehi_yc/provider/nav/bottom_nav_provider.dart';
import 'package:safehi_yc/view_model/signup_view_model.dart';
import 'package:safehi_yc/widget/bottom_menubar/bottom_menubar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SignupViewModel())],
      child: const _MainScreenContent(),
    );
  }
}

class _MainScreenContent extends StatelessWidget {
  const _MainScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<BottomNavProvider>();
    return Scaffold(
      body: navProvider.pageBuilders[navProvider.currentIndex](),
      bottomNavigationBar: const BottomMenubar(),
    );
  }
}
