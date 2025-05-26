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
      padding: EdgeInsets.symmetric(horizontal: responsive.appbarHorizontal),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: responsive.iconSize,
            color: AppColors().primary,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Align(
              alignment:
                  title == "안심하이" ? Alignment.centerLeft : Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    title == "안심하이"
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
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
                  SizedBox(width: responsive.itemSpacing / 2),
                  Text(
                    title,
                    style: TextStyle(
                      color:
                          title == "안심하이"
                              ? const Color(0xFFFB5457)
                              : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.fontLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (title != "안심하이")
            SizedBox(width: responsive.iconSize + responsive.itemSpacing),
        ],
      ),
    );
  }
}
