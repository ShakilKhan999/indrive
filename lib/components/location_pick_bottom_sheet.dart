import 'dart:developer';

import 'package:callandgo/screens/city_to_city_user/views/city_to_city_select_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../helpers/color_helper.dart';
import '../helpers/space_helper.dart';
import '../screens/courier_user/views/courier_select_location.dart';
import '../screens/freight_user/view/freight_select_location.dart';
import 'common_components.dart';

void buildDestinationBottomSheet(
    {required var controller, required bool isFrom, required String from}) {
  showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    scrollControlDisabledMaxHeightRatio: 0.8,
    context: Get.context!,
    builder: (BuildContext context) {
      return Container(
        height: 600.h,
        decoration: BoxDecoration(
            color: ColorHelper.bgColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.sp),
                topRight: Radius.circular(14.sp))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CommonComponents().printText(
                    fontSize: 18,
                    textData: "Choose Location",
                    fontWeight: FontWeight.bold),
                SpaceHelper.verticalSpace15,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      SpaceHelper.horizontalSpace10,
                      Expanded(
                        child: TextField(
                          controller: controller.fromController.value,
                          onChanged: (value) {
                            controller.onSearchTextChanged(value);
                          },
                          autofocus: isFrom ? true : false,
                          readOnly: isFrom ? false : true,
                          style:
                              TextStyle(color: Colors.white, fontSize: 15.sp),
                          decoration: const InputDecoration(
                            hintText: 'From',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SpaceHelper.verticalSpace10,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      SpaceHelper.horizontalSpace10,
                      Expanded(
                        child: TextField(
                          controller: controller.toController.value,
                          onChanged: (value) {
                            controller.onSearchTextChanged(value);
                          },
                          autofocus: !isFrom ? true : false,
                          readOnly: !isFrom ? false : true,
                          style:
                              TextStyle(color: Colors.white, fontSize: 15.sp),
                          decoration: const InputDecoration(
                            hintText: 'To',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SpaceHelper.verticalSpace10,
                InkWell(
                  onTap: () {
                    Get.back();
                    if (from == 'city_to_city') {
                      controller.changingPickup.value = isFrom;
                      Get.to(CityToCitySelectLocation(),
                          transition: Transition.rightToLeft);
                    }
                    if (from == 'freight') {
                      controller.changingPickup.value = isFrom;
                      Get.to(FreightSelectLocation(),
                          transition: Transition.rightToLeft);
                    }
                    if (from == 'courier') {
                      controller.changingPickup.value = isFrom;
                      Get.to(CourierSelectLocation(),
                          transition: Transition.rightToLeft);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 28.sp,
                        color: ColorHelper.primaryColor,
                      ),
                      SpaceHelper.horizontalSpace5,
                      CommonComponents().printText(
                          color: ColorHelper.primaryColor,
                          fontSize: 16,
                          textData: "Choose on map",
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
                SpaceHelper.verticalSpace15,
                Obx(() => Expanded(
              
                      child: ListView.builder(
                          itemCount: controller.suggestions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () async {
                                if (isFrom) {
                                  controller.fromController.value.text =
                                      controller.suggestions[index]
                                          ["description"];
                                  controller.fromPlaceName.value = controller
                                      .suggestions[index]["description"];
                                  var placeDetails = await controller
                                      .googlePlace.details
                                      .get(controller.suggestions[index]
                                          ["placeId"]);
                                  log("LatLong: ${placeDetails!.result!.geometry!.location!.lat}");
                                  double? lat = placeDetails
                                      .result!.geometry!.location!.lat;
                                  double? lng = placeDetails
                                      .result!.geometry!.location!.lng;
                                  controller.startPickedCenter.value =
                                      LatLng(lat!, lng!);
                                } else {
                                  controller.toController.value.text =
                                      controller.suggestions[index]
                                          ["description"];
                                  controller.toPlaceName.value = controller
                                      .suggestions[index]["description"];
                                  var placeDetails = await controller
                                      .googlePlace.details
                                      .get(controller.suggestions[index]
                                          ["placeId"]);
                                  log("LatLong: ${placeDetails!.result!.geometry!.location!.lat}");
                                  double? lat = placeDetails
                                      .result!.geometry!.location!.lat;
                                  double? lng = placeDetails
                                      .result!.geometry!.location!.lng;
                                  controller.destinationPickedCenter.value =
                                      LatLng(lat!, lng!);
                                }

                                Get.back();
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
                                      textData: controller.suggestions[index]
                                          ["description"],
                                      fontWeight: FontWeight.bold)),
                            );
                          }),
                    )),
              ],
            ),
          ),
        ),
      );
    },
  );
}
