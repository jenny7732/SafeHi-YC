import 'package:flutter/material.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';

class BottomTwoButton extends StatelessWidget {
  final String buttonText1;
  final String buttonText2;
  final VoidCallback? onButtonTap1;
  final VoidCallback? onButtonTap2;

  const BottomTwoButton({
    super.key,
    required this.buttonText1,
    required this.buttonText2,
    this.onButtonTap1,
    this.onButtonTap2,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      color: AppColors().background,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.paddingHorizontal,
        vertical: responsive.itemSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: onButtonTap1,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: AppColors().primary, width: 2),
              padding: EdgeInsets.symmetric(
                horizontal: responsive.isTablet ? 40 : 30,
                vertical: responsive.isTablet ? 22 : 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              buttonText1,
              style: TextStyle(
                color: AppColors().primary,
                fontSize: responsive.fontBase,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: responsive.itemSpacing * 2), // 버튼 간격
          ElevatedButton(
            onPressed: onButtonTap2,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors().primary,
              padding: EdgeInsets.symmetric(
                horizontal: responsive.isTablet ? 40 : 30,
                vertical: responsive.isTablet ? 22 : 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              buttonText2,
              style: TextStyle(
                color: Colors.white,
                fontSize: responsive.fontBase,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
