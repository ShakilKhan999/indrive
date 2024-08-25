import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_appbar.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/driver/freight/controller/freight_controller.dart';
import 'package:indrive/screens/driver/freight/views/freight_basicInfo_screen.dart';
import 'package:indrive/screens/driver/freight/views/freight_driverLicence_screen.dart';
import 'package:indrive/screens/driver/freight/views/freight_idConfirmation_screen.dart';
import 'package:indrive/screens/driver/freight/views/freight_national_idCardBirth_screen.dart';
import 'package:indrive/screens/driver/freight/views/freight_vehicleInfo_screen.dart';

class FreightInfoScreen extends StatelessWidget {
  FreightInfoScreen({super.key});
  final FreightController _freightController = Get.put(FreightController());
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: CommonComponents().commonButton(
                  text: "Save All Data",
                  onPressed: () async {},
                  disabled: false),
            )
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
                  Get.to(FreightBasicinfoScreen(),
                      transition: Transition.rightToLeft);
                }),
            const Divider(),
            textIconRow(
                text: "Driver Licence",
                onTap: () {
                  Get.to(FreightDriverlicenceScreen(),
                      transition: Transition.rightToLeft);
                }),
            const Divider(),
            textIconRow(
                text: "ID Confirmation",
                onTap: () {
                  Get.to(FreightIdconfirmationScreen(),
                      transition: Transition.rightToLeft);
                }),
            const Divider(),
            textIconRow(
              text: "National Identity Card or Birth Certificate",
              onTap: () {
                Get.to(FreightNationalIdcardbirthScreen(),
                    transition: Transition.rightToLeft);
              },
            ),
            const Divider(),
            textIconRow(
              text: "Vehicle Info",
              onTap: () {
                Get.to(FreightVehicleinfoScreen(),
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
