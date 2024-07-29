import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_appbar.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/driver/basic_info_screen.dart';
import 'package:indrive/screens/driver/driver_licence_screen.dart';
import 'package:indrive/screens/driver/id_confirmation_screen.dart';
import 'package:indrive/screens/driver/nid_card_birth_certificate_screen.dart';
import 'package:indrive/screens/driver/vehicle_info_screen.dart';

class DriverInfoPage extends StatelessWidget {
  const DriverInfoPage({super.key});

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
              child: CommonComponents()
                  .commonButton(text: "Done", onPressed: () {}, disabled: true),
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
        height: 300.h,
        width: MediaQuery.of(context).size.width - 30.w,
        child: Column(
          children: [
            textIconRow(
                text: "Basic Info",
                onTap: () => Get.to(BasicInfoScreen(),
                    transition: Transition.rightToLeft)),
            const Divider(),
            textIconRow(
                text: "Driver Licence",
                onTap: () => Get.to(DriverLicenceScreen(),
                    transition: Transition.rightToLeft)),
            const Divider(),
            textIconRow(
                text: "ID Confirmation",
                onTap: () => Get.to(const IdConfirmationScreen(),
                    transition: Transition.rightToLeft)),
            const Divider(),
            textIconRow(
                text: "National Identity Card or Birth Certificate",
                onTap: () => Get.to(const NidCardBirthCertificateScreen(),
                    transition: Transition.rightToLeft)),
            const Divider(),
            textIconRow(
                text: "Vehicle Info",
                onTap: () => Get.to(VehicleInfoScreen(),
                    transition: Transition.rightToLeft)),
            const Divider(),
            textIconRow(text: "Agent Referral Code"),
          ],
        ),
      ),
    );
  }

  Widget textIconRow({required String text, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonComponents().printText(
              color: Colors.black,
              fontSize: 15,
              textData: text,
              fontWeight: FontWeight.bold),
          InkWell(
            onTap: onTap,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20.sp,
              color: ColorHelper.blueColor,
            ),
          )
        ],
      ),
    );
  }
}
