import 'package:flutter/material.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';

class DefaultBackAppBar extends StatelessWidget {
  final String title;

  const DefaultBackAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      color: AppColors().background,
      padding: EdgeInsets.symmetric(vertical: responsive.itemSpacing),
      child: SizedBox(
        height: responsive.iconSize + 12,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ✅ 왼쪽 뒤로가기 버튼
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: responsive.iconSize,
                color: AppColors().primary,
                padding: const EdgeInsets.only(left: 4),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // ✅ 가운데 로고 + 제목
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(0, 3),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: responsive.iconSize,
                      height: responsive.iconSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: responsive.itemSpacing),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.fontLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
