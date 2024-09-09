import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/components/custom_appbar.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/driver/courier/controller/courier_controller.dart';
import 'package:callandgo/screens/driver/courier/views/courier_basicInfo_screen.dart';
import 'package:callandgo/screens/driver/courier/views/courier_driverLicence_screen.dart';
import 'package:callandgo/screens/driver/courier/views/courier_idConfirmation_screen.dart';
import 'package:callandgo/screens/driver/courier/views/courier_national_idCardBirth_screen.dart';
import 'package:callandgo/screens/driver/courier/views/courier_vehicleInfo_screen.dart';

class CourierInfoScreen extends StatelessWidget {
  CourierInfoScreen({super.key});
  final CourierController _courierController = Get.put(CourierController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: CustomAppbar(titleText: 'Registration', onTap: () {}),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildSelectionView(context),
            SpaceHelper.verticalSpace10,
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: CommonComponents().commonButton(
                    text: "Save All Data",
                    onPressed: () async {
                      _courierController.saveDriverInfo();
                    },
                    disabled: _courierController.isCourierDataSaving.value,
                    isLoading: _courierController.isCourierDataSaving.value),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildSelectionView(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.5,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 30.w,
        child: Column(
          children: [
            textIconRow(
                text: "Basic Info",
                onTap: () {
                  Get.to(CourierBasicinfoScreen(),
                      transition: Transition.rightToLeft);
                }),
            const Divider(),
            textIconRow(
                text: "Driver Licence",
                onTap: () {
                  Get.to(CourierDriverlicenceScreen(),
                      transition: Transition.rightToLeft);
                }),
            const Divider(),
            textIconRow(
                text: "ID Confirmation",
                onTap: () {
                  Get.to(CourierIdconfirmationScreen(),
                      transition: Transition.rightToLeft);
                }),
            const Divider(),
            textIconRow(
              text: "National Identity Card or Birth Certificate",
              onTap: () {
                Get.to(CourierNationalIdcardbirthScreen(),
                    transition: Transition.rightToLeft);
              },
            ),
            const Divider(),
            textIconRow(
              text: "Vehicle Info",
              onTap: () {
                Get.to(CourierVehicleinfoScreen(),
                    transition: Transition.rightToLeft);
              },
            )
            // const Divider(),
            // textIconRow(text: "Agent Referral Code"),
          ],
        ),
      ),
    );
  }

  Widget textIconRow({required String text, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CommonComponents().printText(
                  color: Colors.black,
                  fontSize: 15,
                  textData: text,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20.sp,
              color: ColorHelper.blueColor,
            )
          ],
        ),
      ),
    );
  }
}
