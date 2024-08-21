import 'package:flutter/material.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final VoidCallback onTap;

  const CustomAppbar({super.key, required this.titleText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: ColorHelper.blackColor,
      iconTheme: IconThemeData(
        color: ColorHelper.whiteColor,
      ),
      title: Title(
        color: Colors.white,
        child: CommonComponents().printText(
            fontSize: 20, textData: titleText, fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
              onTap: onTap,
              child: CommonComponents().printText(
                  fontSize: 18,
                  textData: "Close",
                  fontWeight: FontWeight.normal)),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
