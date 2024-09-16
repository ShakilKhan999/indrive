import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/components/custom_appbar.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/models/freight_trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FreightTripDetails extends StatelessWidget {
  final FreightTripModel freightTripModel;
  FreightTripDetails({required this.freightTripModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: CustomAppbar(titleText: 'Freight Trip Details', onTap: () {}),
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
