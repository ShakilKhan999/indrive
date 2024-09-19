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

class CityToCityTripDetailsScreen extends StatelessWidget {
  final CityToCityTripModel cityToCityTripModel;
  final int index;

  CityToCityTripDetailsScreen(
      {required this.cityToCityTripModel, required this.index});

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
            Column(children: [
              cityToCityTripModel.tripCurrentStatus == 'accepted'
                  ? _buildPickupButtonView()
                  : cityToCityTripModel.tripCurrentStatus == 'picked up'
                      ? _buildDropButtonView()
                      : SizedBox(),
              SpaceHelper.verticalSpace10,
              cityToCityTripModel.tripCurrentStatus == 'accepted'
                  ? _buildCancelButtonView()
                  : SizedBox(),
            ]),
          ],
        ),
      ),
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

  Widget _buildPickupButtonView() {
    return CommonComponents().commonButton(
      text: 'Pick up',
      color: ColorHelper.primaryColor,
      onPressed: () {
        showConfirmationDialog(
            title: 'Pickup',
            onPressConfirm: () async {
              _cityToCityTripController.onPressPickup(
                  index: index, fromDetails: true);
            },
            onPressCancel: () => Get.back(),
            controller: _cityToCityTripController);
      },
    );
  }

  Widget _buildDropButtonView() {
    return CommonComponents().commonButton(
      text: 'Drop',
      color: ColorHelper.primaryColor,
      onPressed: () {
        showConfirmationDialog(
            title: 'Drop',
            onPressConfirm: () async {
              _cityToCityTripController.onPressDrop(
                  index: index, fromDetails: true);
            },
            onPressCancel: () => Get.back(),
            controller: _cityToCityTripController);
      },
    );
  }

  Widget _buildCancelButtonView() {
    return CommonComponents().commonButton(
      text: 'Cancel Ride',
      color: ColorHelper.red,
      onPressed: () {
        showConfirmationDialog(
            title: 'Cancel Ride',
            onPressConfirm: () {
              _cityToCityTripController.onPressCancel(
                  index: index, fromDetails: true);
            },
            onPressCancel: () => Get.back(),
            controller: _cityToCityTripController);
      },
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
            SpaceHelper.verticalSpace10,
            Row(
              children: [
                Expanded(
                  child: CommonComponents().CommonCard(
                    context: context,
                    icon: Icons.person_outline_outlined,
                    number: '${cityToCityTripModel.numberOfPassengers}',
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
