import 'package:flutter/material.dart';
import 'package:indrive/helpers/color_helper.dart';

class DriverCityToCityRequestList extends StatelessWidget {
  const DriverCityToCityRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.bgColor,
      appBar: buildAppBar(),
      body: Center(
        child: Text('City to City Requests'),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: ColorHelper.bgColor,
      iconTheme: IconThemeData(color: ColorHelper.whiteColor),
      title: const Text('City to City Requests'),
    );
  }
}
