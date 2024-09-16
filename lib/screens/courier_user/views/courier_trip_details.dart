import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/components/custom_appbar.dart';
import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/models/courier_trip_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourierTripDetails extends StatelessWidget {
  final CourierTripModel courierTripModel;
  CourierTripDetails({required this.courierTripModel});

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
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildTextView(),
              SpaceHelper.verticalSpace20,
              _buildMapView(context),
              SpaceHelper.verticalSpace10,
            ]),
            Column(children: [
              _buildPickupButtonView(),
              SpaceHelper.verticalSpace10,
              _buildCancelButtonView(),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200.h,
          color: ColorHelper.whiteColor,
          // child:
          //   Obx(
          //     () => GoogleMap(
          //       onMapCreated: (controller) =>
          //           // _cityToCityTripController.onMapCreatedForRide,
          //       onCameraMove: (position) =>
          //           _cityToCityTripController.onCameraMoveForRide,
          //       initialCameraPosition: CameraPosition(
          //         target: _cityToCityTripController.rideRoute.value,
          //         zoom: 12,
          //       ),
          //       polylines: {
          //         Polyline(
          //           polylineId: const PolylineId("poly"),
          //           points: _cityToCityTripController.polylineCoordinates
          //               .map((geoPoint) =>
          //                   LatLng(geoPoint.latitude, geoPoint.longitude))
          //               .toList(),
          //           color: ColorHelper.primaryColor,
          //           width: 7,
          //         ),
          //       },
          //     ),
          //   ),
        ),
        SizedBox(height: 10.h),
        _buildTextInfoView(context),
      ],
    );
  }

  Widget _buildTextView() {
    return CommonComponents().printText(
      fontSize: 16,
      textData: 'Ride Details',
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildPickupButtonView() {
    return CommonComponents().commonButton(
      text: 'Pick up',
      color: ColorHelper.primaryColor,
      onPressed: () {},
    );
  }

  Widget _buildCancelButtonView() {
    return CommonComponents().commonButton(
      text: 'Cancel Ride',
      color: ColorHelper.red,
      onPressed: () {},
    );
  }

  Widget _buildTextInfoView(BuildContext context) {
    return Container(
      height: 200.h,
      // color: Colors.red,
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
        SpaceHelper.verticalSpace10,
        courierTripModel.destinationFullAddress != ''
            ? _buildInfoTextView(
                'Street,building :${courierTripModel.destinationFullAddress} ')
            : SizedBox(),
        SpaceHelper.verticalSpace10,
        courierTripModel.destinationHomeAddress != ''
            ? _buildInfoTextView(
                'Floor,apartment,entryphone : ${courierTripModel.destinationHomeAddress}')
            : SizedBox(),
        SpaceHelper.verticalSpace10,
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
        SpaceHelper.verticalSpace10,
        courierTripModel.pickupFullAddress != ''
            ? _buildInfoTextView(
                'Street,building :${courierTripModel.pickupFullAddress} ')
            : SizedBox(),
        SpaceHelper.verticalSpace10,
        courierTripModel.pickupHomeAddress != ''
            ? _buildInfoTextView(
                'Floor,apartment,entryphone : ${courierTripModel.pickupHomeAddress}')
            : SizedBox(),
        SpaceHelper.verticalSpace10,
        courierTripModel.senderPhone != null
            ? _buildInfoTextView(
                'Sender phone number : ${courierTripModel.senderPhone}')
            : _buildInfoTextView('Sender phone number not found'),
        SpaceHelper.verticalSpace20,
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
