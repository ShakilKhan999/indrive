import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/models/city_to_city_trip_model.dart';
import 'package:callandgo/screens/city_to_city_user/controller/city_to_city_trip_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/confirmation_dialog.dart';

class CityToCityTripDetailsForRequestScreen extends StatelessWidget {
  final CityToCityTripModel cityToCityTripModel;
  final int index;
  final bool fromUser;

  CityToCityTripDetailsForRequestScreen(
      {required this.cityToCityTripModel,
      required this.index,
      required this.fromUser});

  final _cityToCityTripController = Get.find<CityToCityTripController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: SimpleAppbar(
        titleText: 'City to City Trip Details',
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildInofView(context),
            ),
            SpaceHelper.verticalSpace10,
            fromUser
                ? _buildUserActionsView()
                : _buildRiderActionsView(index: index),
          ],
        ),
      ),
    );
  }

  Widget _buildUserActionsView() {
    return Obx(
      () => Container(
        width: double.infinity,
        child: CommonComponents().commonButton(
          text: 'Cancel Ride',
          onPressed: () {
            _cityToCityTripController.cancelRideForUser(
                docId: cityToCityTripModel.id!);
            Get.back();
          },
          isLoading: _cityToCityTripController.isRideCancelLoading.value,
          disabled: _cityToCityTripController.isRideCancelLoading.value,
        ),
      ),
    );
  }

  Widget _buildRiderActionsView({required int index}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            showConfirmationDialog(
                title: 'Decline',
                onPressConfirm: () async {
                  _cityToCityTripController.selectedTripIndex.value = index;
                  _cityToCityTripController.declineRide();
                  Get.back();
                },
                onPressCancel: () => Get.back(),
                controller: _cityToCityTripController);
          },
          child: Container(
            height: 30.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: ColorHelper.red,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: CommonComponents().printText(
                  fontSize: 14,
                  textData: 'Decline',
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            showConfirmationDialog(
                title: 'Accept',
                onPressConfirm: () async {
                  _cityToCityTripController.selectedTripIndex.value = index;
                  _cityToCityTripController.acceptRide();
                  Get.back();
                },
                onPressCancel: () => Get.back(),
                controller: _cityToCityTripController);
          },
          child: Container(
            height: 30.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: ColorHelper.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: CommonComponents().printText(
                  fontSize: 14,
                  textData: 'Accept',
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInofView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Container(
            height: 200.h,
            child: Obx(
              () => GoogleMap(
                markers:
                    _cityToCityTripController.allMarkers.cast<Marker>().toSet(),
                onMapCreated: (controller) =>
                    _cityToCityTripController.onMapCreatedForRide,
                onCameraMove: (position) =>
                    _cityToCityTripController.onCameraMoveForRide,
                initialCameraPosition: CameraPosition(
                  target: _cityToCityTripController.rideRoute.value,
                  zoom: 14,
                ),
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("poly"),
                    points: _cityToCityTripController.polylineCoordinates
                        .map((geoPoint) =>
                            LatLng(geoPoint.latitude, geoPoint.longitude))
                        .toList(),
                    color: ColorHelper.primaryColor,
                    width: 5,
                  ),
                },
                mapType: MapType.normal,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(child: _buildTextInfoView(context))
      ],
    );
  }

  Widget _buildTextInfoView(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpaceHelper.verticalSpace15,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.radio_button_checked,
                    color: ColorHelper.primaryColor),
                SpaceHelper.horizontalSpace10,
                Expanded(
                  child: CommonComponents().printText(
                    fontSize: 12,
                    textData: '${cityToCityTripModel.cityFrom!}',
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
            SpaceHelper.verticalSpace5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.radio_button_checked, color: ColorHelper.blueColor),
                SpaceHelper.horizontalSpace10,
                Expanded(
                  child: CommonComponents().printText(
                    fontSize: 12,
                    textData: '${cityToCityTripModel.cityTo!}',
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
            SpaceHelper.verticalSpace5,
            CommonComponents().printText(
                fontSize: 12,
                textData:
                    'Trip Type: ${cityToCityTripModel.tripType!.toUpperCase()}',
                fontWeight: FontWeight.bold),
            SpaceHelper.verticalSpace10,
            Row(
              children: [
                Expanded(
                  child: CommonComponents().CommonCard(
                    context: context,
                    icon: Icons.person_outline_outlined,
                    number: '${cityToCityTripModel.numberOfPassengers ?? 0}',
                    text: 'Passenger',
                    cardColor: ColorHelper.blackColor,
                  ),
                ),
                SpaceHelper.horizontalSpace10,
                Expanded(
                  child: CommonComponents().CommonCard(
                    context: context,
                    icon: Icons.monetization_on_outlined,
                    number: '${cityToCityTripModel.finalPrice}',
                    text: 'Fare',
                    cardColor: ColorHelper.blackColor,
                  ),
                ),
              ],
            ),
            CommonComponents().CommonCard(
              context: context,
              icon: Icons.description_outlined,
              number: '${cityToCityTripModel.description}',
              text: 'Description',
              cardColor: ColorHelper.blackColor,
              isDescription: true,
            ),
          ],
        ),
      ),
    );
  }
}
