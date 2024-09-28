import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/components/custom_appbar.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/driver/city_to_city/views/cityToCity_info_screen.dart';

import '../controller/cityToCity_controller.dart';

class CitytocityTypesScreen extends StatelessWidget {
  CitytocityTypesScreen({super.key});
  final CityToCityInfoController _cityToCityInfoController =
      Get.put(CityToCityInfoController());

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
                _cityToCityInfoController.vehicleType.value = 'car';
                _cityToCityInfoController.selectedVehicleBrand.value = '';
                _cityToCityInfoController.selectedVehicleModel.value = '';
                _cityToCityInfoController.setVehicleType(vehicleType: 'car');
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
                _cityToCityInfoController.vehicleType.value = 'taxi';
                _cityToCityInfoController.selectedVehicleBrand.value = '';
                _cityToCityInfoController.selectedVehicleModel.value = '';
                _cityToCityInfoController.setVehicleType(vehicleType: 'taxi');
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
                    textData: "Taxi",
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
                _cityToCityInfoController.vehicleType.value = 'moto';
                _cityToCityInfoController.selectedVehicleBrand.value = '';
                _cityToCityInfoController.selectedVehicleModel.value = '';
                _cityToCityInfoController.setVehicleType(vehicleType: 'moto');
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
