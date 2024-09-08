import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';

import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/main.dart';
import 'package:indrive/screens/city_to_city_user/controller/city_to_city_trip_controller.dart';

import 'package:indrive/screens/driver/city_to_city/views/cityToCity_types_screen.dart';
import 'package:indrive/screens/driver/courier/views/courier_types_screen.dart';
import 'package:indrive/screens/driver/driver_info/views/vehicle_type_screen.dart';
import 'package:indrive/screens/driver/freight/views/freight_info_screen.dart';
import 'package:indrive/screens/freight_user/controller/freight_trip_controller.dart';
import 'package:indrive/screens/profile/controller/profile_controller.dart';

import 'package:indrive/screens/profile/views/profile_screen.dart';
import 'package:indrive/utils/global_toast_service.dart';

import '../../auth_screen/controller/auth_controller.dart';
import '../../city_to_city_user/views/driver_city_to_city_request_list.dart';
import '../../freight_user/view/freight_request_for_rider.dart';

class ChooseProfileScreen extends StatelessWidget {
  ChooseProfileScreen({super.key});
  final ProfileController _profileController = Get.put(ProfileController());
  final AuthController _authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.bgColor,
      appBar: _buildAppbarView(),
      body: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: Column(
          children: [
            SpaceHelper.verticalSpace10,
            _buildSelectionView(context),
            SpaceHelper.verticalSpace10,
            _buildLocationView(context)
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionView(BuildContext context) {
    return Obx(
      () => _profileController.isUserDataLoaded.value
          ? Container(
              width: MediaQuery.of(context).size.width - 30.w,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12.r)),
              padding: EdgeInsets.all(16.sp),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 30.w,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonComponents().printText(
                            fontSize: 20,
                            textData: 'Do you want to make profit with us?',
                            fontWeight: FontWeight.bold,
                            maxLine: 2),
                        SpaceHelper.verticalSpace5,
                        CommonComponents().printText(
                            fontSize: 16,
                            color: ColorHelper.lightGreyColor,
                            textData: 'Choose a profile and register',
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),
                  Container(
                    height: 60.h,
                    width: MediaQuery.of(context).size.width - 30.w,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => VehicleTypeScreen(),
                              transition: Transition.rightToLeft);
                        },
                        child: ListTile(
                          leading: SizedBox(
                              height: 30.h,
                              width: 40.h,
                              child: Image.asset("assets/images/car.png")),
                          title: CommonComponents().printText(
                              fontSize: 18,
                              textData: "City Rider",
                              fontWeight: FontWeight.bold),
                          subtitle: CommonComponents().printText(
                              fontSize: 14,
                              textData: "Not Registered",
                              color: ColorHelper.greyColor,
                              fontWeight: FontWeight.normal),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60.h,
                    width: MediaQuery.of(context).size.width - 30.w,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => CourierTypsScreen(),
                              transition: Transition.rightToLeft);
                        },
                        child: ListTile(
                          leading: SizedBox(
                              height: 30.h,
                              width: 40.h,
                              child: Image.asset(
                                  "assets/images/delivery-courier.png")),
                          title: CommonComponents().printText(
                              fontSize: 18,
                              textData: "Courier",
                              fontWeight: FontWeight.bold),
                          subtitle: CommonComponents().printText(
                              fontSize: 14,
                              textData: "Not Registered",
                              color: ColorHelper.greyColor,
                              fontWeight: FontWeight.normal),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60.h,
                    width: MediaQuery.of(context).size.width - 30.w,
                    decoration: BoxDecoration(color: Colors.black),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          fToast.init(context);
                          if (_profileController.freightStatus.value.status ==
                              'Registration completed') {
                            FreightTripController _freightTripController =
                                Get.put(FreightTripController());
                            _freightTripController.getFreightTrips();
                            _freightTripController.getCityToCityMyTrips();
                            Get.to(() => FreightRequesForRider(),
                                transition: Transition.rightToLeft);
                          } else if (_profileController
                                  .freightStatus.value.status ==
                              'Not Registered') {
                            Get.to(() => FreightInfoScreen(),
                                transition: Transition.rightToLeft);
                          } else if (_profileController
                                  .freightStatus.value.status ==
                              'Verification pending') {
                            showToast(
                                toastText:
                                    'Documents submitted but verification pending',
                                toastColor: ColorHelper.red);
                          } else if (_profileController
                                  .freightStatus.value.status ==
                              'Verification failed') {}
                        },
                        child: ListTile(
                          leading: SizedBox(
                              height: 30.h,
                              width: 40.h,
                              child: Image.asset(
                                  "assets/images/freight-delivery.png")),
                          title: CommonComponents().printText(
                              fontSize: 18,
                              textData: "Freight",
                              fontWeight: FontWeight.bold),
                          subtitle: CommonComponents().printText(
                              fontSize: 14,
                              textData: _profileController
                                  .freightStatus.value.status!,
                              color:
                                  _profileController.freightStatus.value.color!,
                              fontWeight: FontWeight.normal),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60.h,
                    width: MediaQuery.of(context).size.width - 30.w,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          fToast.init(context);
                          if (_profileController
                                  .cityToCityStatus.value.status ==
                              'Registration completed') {
                            CityToCityTripController _cityToCityTripController =
                                Get.put(CityToCityTripController());
                            _cityToCityTripController.getCityToCityTrips();
                            _cityToCityTripController.getCityToCityMyTrips();
                            Get.to(() => DriverCityToCityRequestList(),
                                transition: Transition.rightToLeft);
                          } else if (_profileController
                                  .cityToCityStatus.value.status ==
                              'Not Registered') {
                            Get.to(() => CitytocityTypesScreen(),
                                transition: Transition.rightToLeft);
                          } else if (_profileController
                                  .cityToCityStatus.value.status ==
                              'Verification pending') {
                            showToast(
                                toastText:
                                    'Documents submitted but verification pending',
                                toastColor: ColorHelper.red);
                          } else if (_profileController
                                  .cityToCityStatus.value.status ==
                              'Verification failed') {}
                        },
                        child: ListTile(
                          leading: SizedBox(
                              height: 30.h,
                              width: 40.h,
                              child: Image.asset("assets/images/location.png",
                                  color: ColorHelper.primaryColor)),
                          title: CommonComponents().printText(
                              fontSize: 18,
                              textData: "City to City",
                              fontWeight: FontWeight.bold),
                          subtitle: CommonComponents().printText(
                              fontSize: 14,
                              textData: _profileController
                                  .cityToCityStatus.value.status!,
                              color: _profileController
                                  .cityToCityStatus.value.color!,
                              fontWeight: FontWeight.normal),
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
              ),
            )
          : Container(
              height: 100.h,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorHelper.primaryColor,
                ),
              ),
            ),
    );
  }

  Widget _buildLocationView(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30.w,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(12.r)),
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonComponents().printText(
                  fontSize: 20, textData: 'Dhaka', fontWeight: FontWeight.bold),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.location_on),
              )
            ],
          ),
          SpaceHelper.verticalSpace5,
          CommonComponents().printText(
              fontSize: 16,
              color: ColorHelper.lightGreyColor,
              textData: 'Change the city',
              fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  AppBar _buildAppbarView() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back)),
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(
        color: ColorHelper.whiteColor,
      ),
      title: Title(
        color: Colors.white,
        child: CommonComponents().printText(
            fontSize: 20,
            textData: FirebaseAuth.instance.currentUser != null
                ? FirebaseAuth.instance.currentUser!.displayName!
                : 'Name',
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: ColorHelper.blackColor,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
            onTap: () {
              Get.to(() => ProfileScreen(), transition: Transition.rightToLeft);
            },
            child: Container(
              height: 35.h,
              width: 35.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Colors.white,
                  border: Border.all(color: Colors.white)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: _authController.currentUser.value.photo != null
                    ? Image.network(
                        _authController.currentUser.value.photo!,
                        height: 35.h,
                        width: 35.h,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/person.jpg",
                        height: 35.h,
                        width: 35.h,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
