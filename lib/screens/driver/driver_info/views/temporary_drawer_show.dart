import 'package:flutter/material.dart';
import 'package:indrive/components/custom_drawer.dart';
import 'package:indrive/helpers/color_helper.dart';

class TemporaryDrawerShow extends StatelessWidget {
  TemporaryDrawerShow({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        // backgroundColor: ColorHelper.bgColor,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: ColorHelper.bgColor,
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
              } else {
                scaffoldKey.currentState!.openDrawer();
              }
            },
          ),
        ),
      ),
    );
  }
}
