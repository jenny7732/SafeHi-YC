import 'package:flutter/material.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/widget/appbar/default_appbar.dart';

class PreviousRecordsPage extends StatelessWidget {
  const PreviousRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors().background,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.paddingHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DefaultAppBar(title: '이전 기록'),
              SizedBox(height: responsive.sectionSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
