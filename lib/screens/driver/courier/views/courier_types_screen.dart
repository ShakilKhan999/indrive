import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_appbar.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/driver/courier/controller/courier_controller.dart';
import 'package:indrive/screens/driver/courier/views/courier_info_screen.dart';

class CourierTypsScreen extends StatelessWidget {
  CourierTypsScreen({super.key});

  final CourierController _courierController = Get.put(CourierController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorHelper.bgColor,
      appBar: CustomAppbar(titleText: 'Going to work as:', onTap: () {}),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildSelectionView(context),
            SpaceHelper.verticalSpace10,
          ],
        ),
      ),
    ));
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
                _courierController.vehicleType.value = 'car';
                _courierController.setVehicleType(
                    vehicleType: _courierController.vehicleType.value);
                Get.to(CourierInfoScreen(), transition: Transition.rightToLeft);
              },
              child: ListTile(
                leading: SizedBox(
                    height: 40.h,
                    width: 40.h,
                    child: Image.asset("assets/images/car_courier.png")),
                title: CommonComponents().printText(
                    fontSize: 18,
                    textData: "Car courier",
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
                _courierController.vehicleType.value = 'moto';
                _courierController.setVehicleType(
                    vehicleType: _courierController.vehicleType.value);
                Get.to(CourierInfoScreen(), transition: Transition.rightToLeft);
              },
              child: ListTile(
                leading: SizedBox(
                    height: 30.h,
                    width: 40.h,
                    child: Image.asset("assets/images/moto_courier.png")),
                title: CommonComponents().printText(
                    fontSize: 18,
                    textData: "Moto courier",
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
        // Container(
        //   height: 60.h,
        //   width: MediaQuery.of(context).size.width - 30.w,
        //   decoration: BoxDecoration(
        //       color: Colors.black, borderRadius: BorderRadius.circular(12)),
        //   child: Center(
        //     child: InkWell(
        //       onTap: () {
        //         Get.to(CourierInfoScreen(), transition: Transition.rightToLeft);
        //       },
        //       child: ListTile(
        //         leading: SizedBox(
        //             height: 30.h,
        //             width: 40.h,
        //             child: Image.asset("assets/images/foot_courier.png")),
        //         title: CommonComponents().printText(
        //             fontSize: 18,
        //             textData: "Foot courier",
        //             fontWeight: FontWeight.bold),
        //         trailing: Icon(
        //           Icons.arrow_forward_ios,
        //           color: Colors.white,
        //           size: 18.sp,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // SpaceHelper.verticalSpace5,
      ],
    );
  }
}
