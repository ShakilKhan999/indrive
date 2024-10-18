import 'package:callandgo/screens/courier_user/controller/courier_trip_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';

import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/main.dart';
import 'package:callandgo/screens/city_to_city_user/controller/city_to_city_trip_controller.dart';

import 'package:callandgo/screens/driver/city_to_city/views/cityToCity_types_screen.dart';
import 'package:callandgo/screens/driver/courier/views/courier_types_screen.dart';
import 'package:callandgo/screens/driver/driver_info/views/vehicle_type_screen.dart';
import 'package:callandgo/screens/driver/freight/views/freight_info_screen.dart';
import 'package:callandgo/screens/freight_user/controller/freight_trip_controller.dart';
import 'package:callandgo/screens/profile/controller/profile_controller.dart';

import 'package:callandgo/screens/profile/views/profile_screen.dart';
import 'package:callandgo/utils/global_toast_service.dart';

import '../../../helpers/style_helper.dart';
import '../../auth_screen/controller/auth_controller.dart';
import '../../city_to_city_user/views/driver_city_to_city_request_list.dart';
import '../../courier_user/views/courier_request_for_rider.dart';
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
      body: SingleChildScrollView(
        child: Padding(
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
                          fToast.init(context);

                          if (_profileController.cityRiderStatus.value.status ==
                              'Registration completed') {
                          } else if (_profileController
                                  .cityRiderStatus.value.status ==
                              'Not Registered') {
                            Get.to(() => VehicleTypeScreen(),
                                transition: Transition.rightToLeft);
                          } else if (_profileController
                                  .cityRiderStatus.value.status ==
                              'Verification pending') {
                            showToast(
                                toastText:
                                    'Documents submitted but verification pending',
                                toastColor: ColorHelper.red);
                          } else if (_profileController
                                  .cityRiderStatus.value.status ==
                              'Verification failed') {}
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
                              textData: _profileController
                                  .cityRiderStatus.value.status!,
                              color: _profileController
                                  .cityRiderStatus.value.color!,
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
                          if (_profileController.courierStatus.value.status ==
                              'Registration completed') {
                            CourierTripController courierTripController =
                                Get.put(CourierTripController());
                            AuthController authController = Get.find();
                            if (!authController.checkProfile()) {
                              showToast(
                                  toastText: 'Please complete your profile',
                                  toastColor: ColorHelper.red);
                              Get.to(() => ProfileScreen(),
                                  transition: Transition.rightToLeft);
                              return;
                            }
                            courierTripController.getCourierTrips();
                            courierTripController.getCourierMyTrips();
                            Get.to(() => CourierRequesForRider(),
                                transition: Transition.rightToLeft);
                          } else if (_profileController
                                  .courierStatus.value.status ==
                              'Not Registered') {
                            Get.to(() => CourierTypsScreen(),
                                transition: Transition.rightToLeft);
                          } else if (_profileController
                                  .courierStatus.value.status ==
                              'Verification pending') {
                            showToast(
                                toastText:
                                    'Documents submitted but verification pending',
                                toastColor: ColorHelper.red);
                          } else if (_profileController
                                  .courierStatus.value.status ==
                              'Verification failed') {}
                        },
                        child: ListTile(
                          leading: SizedBox(
                              height: 30.h,
                              width: 40.h,
                              child: Image.asset("assets/images/courier.png")),
                          title: CommonComponents().printText(
                              fontSize: 18,
                              textData: "Courier",
                              fontWeight: FontWeight.bold),
                          subtitle: CommonComponents().printText(
                              fontSize: 14,
                              textData: _profileController
                                  .courierStatus.value.status!,
                              color:
                                  _profileController.courierStatus.value.color!,
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
                            AuthController authController = Get.find();
                            if (!authController.checkProfile()) {
                              showToast(
                                  toastText: 'Please complete your profile',
                                  toastColor: ColorHelper.red);
                              Get.to(() => ProfileScreen(),
                                  transition: Transition.rightToLeft);
                              return;
                            }
                            _freightTripController.getFreightTrips();
                            _freightTripController.getFreightMyTrips();
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
                              child: Image.asset("assets/images/freight.png")),
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
                            AuthController authController = Get.find();
                            if (!authController.checkProfile()) {
                              showToast(
                                  toastText: 'Please complete your profile',
                                  toastColor: ColorHelper.red);
                              Get.to(() => ProfileScreen(),
                                  transition: Transition.rightToLeft);
                              return;
                            }
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
                              child: Image.asset(
                                "assets/images/city_to_city.png",
                                height: 30.h,
                                width: 30.w,
                              )),
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
    return InkWell(
      onTap: () {
        _showLocationSelectionSheet();
      },
      child: Container(
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
                Obx(
                  () => CommonComponents().printText(
                      fontSize: 20,
                      textData: _authController.userLocation.value,
                      fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.location_on,
                    color: ColorHelper.primaryColor,
                  ),
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
      ),
    );
  }

  void _showLocationSelectionSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: ColorHelper.bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0.sp),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose your location',
                          style: StyleHelper.heading,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      style: StyleHelper.regular14,
                      autofocus: true,
                      controller: _authController.searchCityController.value,
                      onChanged: (value) {
                        _authController.onSearchTextChanged(value);
                      },
                      cursorColor: ColorHelper.primaryColor,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: StyleHelper.regular14,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: ColorHelper.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide:
                              BorderSide(color: ColorHelper.primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: ColorHelper.primaryColor, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Obx(() => SizedBox(
                          height: 250.h,
                          child: ListView.builder(
                              itemCount: _authController.suggestions.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () async {
                                    _authController.placeName.value =
                                        _authController.suggestions[index]
                                            ["description"];

                                    _authController.updateLocation();
                                  },
                                  child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(
                                        Icons.location_on_outlined,
                                        color: ColorHelper.primaryColor,
                                      ),
                                      trailing: CommonComponents().printText(
                                          fontSize: 12,
                                          textData: "",
                                          fontWeight: FontWeight.bold),
                                      title: CommonComponents().printText(
                                          fontSize: 14,
                                          maxLine: 2,
                                          textData:
                                              _authController.suggestions[index]
                                                  ["description"],
                                          fontWeight: FontWeight.bold)),
                                );
                              }),
                        )),
                  ),
                ],
              ),
            );
          },
        );
      },
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
            textData: _authController.currentUser.value.name!,
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
                  color: ColorHelper.whiteColor,
                  border: Border.all(color: ColorHelper.whiteColor)),
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
