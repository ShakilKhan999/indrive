import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_appbar.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/driver/city_to_city/views/cityToCity_info_screen.dart';

class CitytocityTypsScreen extends StatelessWidget {
  const CitytocityTypsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(
            titleText: 'Chosse Vehicle Type',
            onTap: () {
              Navigator.pop(context);
            }),
        backgroundColor: ColorHelper.bgColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpaceHelper.verticalSpace35,
              _buildSelectionView(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionView(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60.h,
          width: MediaQuery.of(context).size.width - 30.w,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: InkWell(
              onTap: () {
                Get.to(CitytocityInfoScreen(),
                    transition: Transition.rightToLeft);
              },
              child: ListTile(
                leading: SizedBox(
                    height: 30.h,
                    width: 40.h,
                    child: Image.asset("assets/images/car.png")),
                title: CommonComponents().printText(
                    fontSize: 18, textData: "Car", fontWeight: FontWeight.bold),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ),
        SpaceHelper.verticalSpace5,
        Container(
          height: 60.h,
          width: MediaQuery.of(context).size.width - 30.w,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: InkWell(
              onTap: () {
                Get.to(CitytocityInfoScreen(),
                    transition: Transition.rightToLeft);
              },
              child: ListTile(
                leading: SizedBox(
                    height: 30.h,
                    width: 40.h,
                    child: Image.asset("assets/images/rickshaw.png")),
                title: CommonComponents().printText(
                    fontSize: 18,
                    textData: "Texi",
                    fontWeight: FontWeight.bold),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ),
        SpaceHelper.verticalSpace5,
        Container(
          height: 60.h,
          width: MediaQuery.of(context).size.width - 30.w,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: InkWell(
              onTap: () {
                Get.to(CitytocityInfoScreen(),
                    transition: Transition.rightToLeft);
              },
              child: ListTile(
                leading: SizedBox(
                    height: 30.h,
                    width: 40.h,
                    child: Image.asset("assets/images/bike.png")),
                title: CommonComponents().printText(
                    fontSize: 18,
                    textData: "Moto",
                    fontWeight: FontWeight.bold),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
