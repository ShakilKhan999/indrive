import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_appbar.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/driver/city_to_city/views/cityToCity_basic_info_screen.dart';
import 'package:indrive/screens/driver/city_to_city/views/cityToCity_driver_licence_screen.dart';
import 'package:indrive/screens/driver/city_to_city/views/cityToCity_national_id_verfication_screen.dart';
import 'package:indrive/screens/driver/city_to_city/views/cityToCity_vehicle_info_screen.dart';
import 'package:indrive/screens/driver/city_to_city/views/cityToCityid_confirmation_screen.dart';
import 'package:indrive/screens/driver/city_to_city/controller/cityToCity_controller.dart';

class CitytocityInfoScreen extends StatelessWidget {
  CitytocityInfoScreen({super.key});
  final CityToCityInfoController _cityToCityInfoController =
      Get.put(CityToCityInfoController());
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
                  onPressed: () async {
                    await _cityToCityInfoController.saveDriverInfo();
                  },
                  disabled:
                      _cityToCityInfoController.isCityToCityDataSaving.value,
                  isLoading:
                      _cityToCityInfoController.isCityToCityDataSaving.value),
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
                  Get.to(CityToCityBasicInfoScreen(),
                      transition: Transition.rightToLeft);
                }),
            const Divider(),
            textIconRow(
                text: "Driver Licence",
                onTap: () {
                  Get.to(CityToCityDriverLicenceScreen(),
                      transition: Transition.rightToLeft);
                }),
            const Divider(),
            textIconRow(
                text: "ID Confirmation",
                onTap: () {
                  Get.to(CityToCityIdConfirmationScreen(),
                      transition: Transition.rightToLeft);
                }),
            const Divider(),
            textIconRow(
              text: "National Identity Card or Birth Certificate",
              onTap: () {
                Get.to(CityToCityNidCardBirthCertificateScreen(),
                    transition: Transition.rightToLeft);
              },
            ),
            const Divider(),
            textIconRow(
              text: "Vehicle Info",
              onTap: () {
                Get.to(CityToCityVehicleInfoScreen(),
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
