import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/driver/city_to_city/views/cityToCity_types_screen.dart';
import 'package:indrive/screens/driver/courier/views/courier_typs_screen.dart';
import 'package:indrive/screens/driver/driver_info/views/vehicle_type_screen.dart';
import 'package:indrive/screens/driver/freight/views/freight_info_screen.dart';

class DriverCategoriesScreen extends StatelessWidget {
  const DriverCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.bgColor,
      body: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: Column(
          children: [
            SpaceHelper.verticalSpace35,
            _buildTopCardView(),
            SpaceHelper.verticalSpace35,
            _buildSelectionView(context)
          ],
        ),
      ),
    );
  }

  Widget _buildTopCardView() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorHelper.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonComponents().printText(
                    fontSize: 18,
                    textData: 'Get income with us',
                    fontWeight: FontWeight.bold),
                SpaceHelper.horizontalSpace5,
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    SpaceHelper.horizontalSpace5,
                    CommonComponents().printText(
                        fontSize: 15,
                        textData: 'Flexible hours',
                        fontWeight: FontWeight.normal),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    SpaceHelper.horizontalSpace5,
                    CommonComponents().printText(
                        fontSize: 15,
                        textData: 'Your prices',
                        fontWeight: FontWeight.normal),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    SpaceHelper.horizontalSpace5,
                    CommonComponents().printText(
                        fontSize: 15,
                        textData: 'Low service payments',
                        fontWeight: FontWeight.normal),
                  ],
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/your_image.png', // Replace with your asset
            width: 80,
            height: 80,
          ),
        ],
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
                Get.to(VehicleTypeScreen(), transition: Transition.rightToLeft);
              },
              child: ListTile(
                leading: SizedBox(
                    height: 30.h,
                    width: 40.h,
                    child: Image.asset("assets/images/car.png")),
                title: CommonComponents().printText(
                    fontSize: 18,
                    textData: "Driver",
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
                Get.to(CourierTypsScreen(), transition: Transition.rightToLeft);
              },
              child: ListTile(
                leading: SizedBox(
                    height: 30.h,
                    width: 40.h,
                    child: Image.asset("assets/images/delivery-courier.png")),
                title: CommonComponents().printText(
                    fontSize: 18,
                    textData: "Courier",
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
                Get.to(FreightInfoScreen(), transition: Transition.rightToLeft);
              },
              child: ListTile(
                leading: SizedBox(
                    height: 30.h,
                    width: 40.h,
                    child: Image.asset("assets/images/freight-delivery.png")),
                title: CommonComponents().printText(
                    fontSize: 18,
                    textData: "Freight",
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
                Get.to(CitytocityTypesScreen(),
                    transition: Transition.rightToLeft);
              },
              child: ListTile(
                leading: SizedBox(
                    height: 30.h,
                    width: 40.h,
                    child: Image.asset("assets/images/location.png")),
                title: CommonComponents().printText(
                    fontSize: 18,
                    textData: "City to City",
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
