import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/models/courier_trip_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../components/confirmation_dialog.dart';
import '../controller/courier_trip_controller.dart';

class CourierTripDetailsForRequestScreen extends StatelessWidget {
  final CourierTripModel courierTripModel;
  final int index;
  final bool fromUser;
  CourierTripDetailsForRequestScreen(
      {required this.courierTripModel,
      required this.index,
      required this.fromUser});

  final CourierTripController _courierTripController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: SimpleAppbar(titleText: 'Courier Trip Details'),
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
                  _courierTripController.cancelRideForUser(
                      docId: _courierTripController.tripListForUser[index].id!);
                  Get.back();
                },
                onPressCancel: () => Get.back(),
                controller: _courierTripController);
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
                  _courierTripController.selectedTripIndex.value = index;
                  _courierTripController.declineRide();
                  Get.back();
                },
                onPressCancel: () => Get.back(),
                controller: _courierTripController);
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
                  _courierTripController.selectedTripIndex.value = index;
                  _courierTripController.acceptRide();
                  Get.back();
                },
                onPressCancel: () => Get.back(),
                controller: _courierTripController);
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
              markers: _courierTripController.allMarkers.cast<Marker>().toSet(),
              onMapCreated: (controller) =>
                  _courierTripController.onMapCreatedForRide,
              onCameraMove: (position) =>
                  _courierTripController.onCameraMoveForRide,
              initialCameraPosition: CameraPosition(
                target: _courierTripController.rideRoute.value,
                zoom: 14,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("poly"),
                  points: _courierTripController.polylineCoordinates
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
              _courierTripController.onPressPickup(
                  index: index, fromDetails: true);
            },
            onPressCancel: () => Get.back(),
            controller: _courierTripController);
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
              _courierTripController.onPressDrop(
                  index: index, fromDetails: true);
            },
            onPressCancel: () => Get.back(),
            controller: _courierTripController);
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
              _courierTripController.onPressCancel(
                  index: index, fromDetails: true);
            },
            onPressCancel: () => Get.back(),
            controller: _courierTripController);
      },
    );
  }

  Widget _buildTextInfoView(BuildContext context) {
    return Container(
      height: 200.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
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
                        textData: '${courierTripModel.from!}',
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
                SpaceHelper.verticalSpace5,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.radio_button_checked,
                        color: ColorHelper.blueColor),
                    SpaceHelper.horizontalSpace10,
                    Expanded(
                      child: CommonComponents().printText(
                        fontSize: 12,
                        textData: '${courierTripModel.to!}',
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
                SpaceHelper.verticalSpace10,
                _buildPickupInfoView(),
                _buildDeliverInfoView(),
                _buildDescriptionView(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionView(BuildContext context) {
    return Column(
      children: [
        courierTripModel.description != ''
            ? CommonComponents().CommonCard(
                context: context,
                icon: Icons.description_outlined,
                number: '${courierTripModel.description}',
                text: 'Description',
                cardColor: ColorHelper.blackColor,
                isDescription: true,
              )
            : CommonComponents().CommonCard(
                context: context,
                icon: Icons.description_outlined,
                number: 'Description not found',
                text: 'Description',
                cardColor: ColorHelper.blackColor,
                isDescription: true,
              ),
      ],
    );
  }

  Widget _buildDeliverInfoView() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CommonComponents().printText(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              textData: 'Deliver Info:',
              color: ColorHelper.primaryColor),
        ),
        courierTripModel.destinationFullAddress != ''
            ? SpaceHelper.verticalSpace10
            : SizedBox(),
        courierTripModel.destinationFullAddress != ''
            ? _buildInfoTextView(
                'Street,building :${courierTripModel.destinationFullAddress} ')
            : SizedBox(),
        courierTripModel.destinationHomeAddress != ''
            ? SpaceHelper.verticalSpace10
            : SizedBox(),
        courierTripModel.destinationHomeAddress != ''
            ? _buildInfoTextView(
                'Floor,apartment,entryphone : ${courierTripModel.destinationHomeAddress}')
            : SizedBox(),
        SpaceHelper.verticalSpace5,
        courierTripModel.recipientPhone != null
            ? _buildInfoTextView(
                'Sender phone number : ${courierTripModel.recipientPhone}')
            : _buildInfoTextView('Sender phone number not found'),
        SpaceHelper.verticalSpace10,
      ],
    );
  }

  Widget _buildPickupInfoView() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CommonComponents().printText(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              textData: 'Picup Info:',
              color: ColorHelper.primaryColor),
        ),
        courierTripModel.pickupFullAddress != ''
            ? SpaceHelper.verticalSpace10
            : SizedBox(),
        courierTripModel.pickupFullAddress != ''
            ? _buildInfoTextView(
                'Street,building :${courierTripModel.pickupFullAddress} ')
            : SizedBox(),
        courierTripModel.pickupHomeAddress != ''
            ? SpaceHelper.verticalSpace10
            : SizedBox(),
        courierTripModel.pickupHomeAddress != ''
            ? _buildInfoTextView(
                'Floor,apartment,entryphone : ${courierTripModel.pickupHomeAddress}')
            : SizedBox(),
        SpaceHelper.verticalSpace5,
        courierTripModel.senderPhone != null
            ? _buildInfoTextView(
                'Sender phone number : ${courierTripModel.senderPhone}')
            : _buildInfoTextView('Sender phone number not found'),
        SpaceHelper.verticalSpace10,
      ],
    );
  }

  Widget _buildInfoTextView(String info) {
    return Container(
      height: 50.h,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: ColorHelper.blackColor),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 5.w),
      child: CommonComponents()
          .printText(fontSize: 14, textData: info, fontWeight: FontWeight.bold),
    );
  }
}
