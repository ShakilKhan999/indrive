import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/models/freight_trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../components/confirmation_dialog.dart';
import '../controller/freight_trip_controller.dart';

class FreightTripDetailsForRequest extends StatelessWidget {
  final FreightTripModel freightTripModel;
  final int index;
  final bool fromUser;

  FreightTripDetailsForRequest(
      {required this.freightTripModel,
      required this.index,
      required this.fromUser});

  final FreightTripController _freightTripController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: SimpleAppbar(titleText: 'Freight Trip Details'),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildMapView(context),
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
    return Container(
      width: double.infinity,
      child: CommonComponents().commonButton(
        text: 'Cancel Ride',
        onPressed: () {
          showConfirmationDialog(
              title: 'Cancel Ride',
              onPressConfirm: () {
                _freightTripController.cancelRideForUser(
                    docId: _freightTripController.tripListForUser[index].id!);
                Get.back();
              },
              onPressCancel: () => Get.back(),
              controller: _freightTripController);
        },
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
                  _freightTripController.selectedTripIndex.value = index;
                  _freightTripController.declineRide();
                  Get.back();
                },
                onPressCancel: () => Get.back(),
                controller: _freightTripController);
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
                  _freightTripController.selectedTripIndex.value = index;
                  _freightTripController.acceptRide();
                  Get.back();
                },
                onPressCancel: () => Get.back(),
                controller: _freightTripController);
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

  Widget _buildMapView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200.h,
          color: ColorHelper.whiteColor,
          child: Obx(
            () => GoogleMap(
              markers: _freightTripController.allMarkers.cast<Marker>().toSet(),
              onMapCreated: (controller) =>
                  _freightTripController.onMapCreatedForRide,
              onCameraMove: (position) =>
                  _freightTripController.onCameraMoveForRide,
              initialCameraPosition: CameraPosition(
                target: _freightTripController.rideRoute.value,
                zoom: 14,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("poly"),
                  points: _freightTripController.polylineCoordinates
                      .map((geoPoint) =>
                          LatLng(geoPoint.latitude, geoPoint.longitude))
                      .toList(),
                  color: ColorHelper.primaryColor,
                  width: 5,
                ),
              },
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: _buildTextInfoView(context),
        )
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
              _freightTripController.onPressPickup(
                  index: index, fromDetails: true);
            },
            onPressCancel: () => Get.back(),
            controller: _freightTripController);
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
              _freightTripController.onPressDrop(
                  index: index, fromDetails: true);
            },
            onPressCancel: () => Get.back(),
            controller: _freightTripController);
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
              _freightTripController.onPressCancel(
                  index: index, fromDetails: true);
            },
            onPressCancel: () => Get.back(),
            controller: _freightTripController);
      },
    );
  }

  Widget _buildTextInfoView(BuildContext context) {
    return Container(
      height: 200.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    textData: '${freightTripModel.from!}',
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
                    textData: '${freightTripModel.to!}',
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
            SpaceHelper.verticalSpace10,
            _buildDateView(context),
            SpaceHelper.verticalSpace10,
            _buildFreightSizeView(context),
            SpaceHelper.verticalSpace10,
            _buildImageView(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateView(BuildContext context) {
    return Container(
      height: 50.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: ColorHelper.blackColor),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 6.w),
      child: Center(
          child: freightTripModel.date != null
              ? CommonComponents().printText(
                  fontSize: 14,
                  textData: 'Date : ${freightTripModel.date}',
                  fontWeight: FontWeight.bold)
              : CommonComponents().printText(
                  fontSize: 14,
                  textData: 'Date not found',
                  fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFreightSizeView(BuildContext context) {
    return Container(
      height: 50.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: ColorHelper.blackColor),
      child: Center(
          child: freightTripModel.truckSize != null
              ? CommonComponents().printText(
                  fontSize: 14,
                  textData: 'Freight Size : ${freightTripModel.truckSize}',
                  fontWeight: FontWeight.bold)
              : CommonComponents().printText(
                  fontSize: 14,
                  textData: 'Freight Size not found',
                  fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildImageView() {
    return Container(
      height: 100.h,
      width: 150.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: ColorHelper.blackColor),
      child: Center(
          child: freightTripModel.cargoImage != null
              ? Image.network(freightTripModel.cargoImage!, fit: BoxFit.cover)
              : Image.asset('assets/images/freight-delivery.png',
                  fit: BoxFit.cover)),
    );
  }
}
