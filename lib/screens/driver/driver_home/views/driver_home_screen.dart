import 'dart:developer';

import 'package:callandgo/helpers/method_helper.dart';
import 'package:callandgo/helpers/style_helper.dart';
import 'package:callandgo/screens/home/controller/home_controller.dart';
import 'package:callandgo/screens/home/repository/passenger_repositoy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/auth_screen/controller/auth_controller.dart';
import 'package:callandgo/screens/driver/driver_home/controller/driver_home_controller.dart';
import 'package:callandgo/screens/driver/driver_home/repository/driver_repository.dart';
import 'package:callandgo/screens/profile/views/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/confirmation_dialog.dart';
import '../../../../components/custom_drawer_for_driver.dart';

class DriverHomeScreen extends StatelessWidget {
  DriverHomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final DriverHomeController driverHomeController =
      Get.put(DriverHomeController());

  final HomeController homeController =
  Get.put(HomeController());
  final AuthController _authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawerForDriver(),
      appBar: AppBar(
        backgroundColor: ColorHelper.bgColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            if (scaffoldKey.currentState!.isDrawerOpen) {
              scaffoldKey.currentState!.closeDrawer();
            } else {
              scaffoldKey.currentState!.openDrawer();
            }
          },
        ),
      ),
      body: Center(
          child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Obx(() => SizedBox(
                height: MediaQuery.of(context).size.height -
                    (driverHomeController.activeCall.isNotEmpty ? 140.h : 90.h),
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  polylines: driverHomeController
                          .polylineCoordinates.value.isEmpty && driverHomeController.activeCall.isEmpty
                      ? {}
                      : {
                          Polyline(
                              polylineId: const PolylineId("route"),
                              points: driverHomeController
                                  .polylineCoordinates.value
                                  .map((geoPoint) => LatLng(
                                      geoPoint.latitude, geoPoint.longitude))
                                  .toList(),
                              color: Colors.deepPurpleAccent,
                              width: 5)
                        },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: driverHomeController.onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: driverHomeController.center.value,
                    zoom: 15.0,
                  ),
                ),
              )),
          Align(
            alignment: Alignment.center,
            child: Obx(() => driverHomeController.userLocationPicking.value
                ? SizedBox(
                    height: 100.h,
                    width: 100.h,
                    child: Image.asset(
                      "assets/images/searching-loading.gif",
                      height: 100.h,
                      width: 100.h,
                    ),
                  )
                : const SizedBox()),
          ),
          Positioned(
            top: 30.h,
            left: 10.w,
            child: Container(
              height: 40.h,
              width: 40.h,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(90)),
              child: Center(
                child: Icon(
                  Icons.search,
                  size: 20.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 30.h,
            right: 10.w,
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(90)),
              child: Center(
                  child: Obx(
                () => InkWell(
                  onTap: () {
                    Get.to(() => ProfileScreen(),
                        transition: Transition.rightToLeft);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SpaceHelper.horizontalSpace10,
                      CommonComponents().printText(
                          fontSize: 16,
                          textData:
                              _authController.currentUser.value.name != null
                                  ? "${_authController.currentUser.value.name!}"
                                  : "User Name",
                          fontWeight: FontWeight.bold),
                      SpaceHelper.horizontalSpace5,
                      Container(
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
                      )
                    ],
                  ),
                ),
              )),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() => AnimatedContainer(
                  duration: const Duration(microseconds: 200),
                  height: driverHomeController.activeCall.isNotEmpty
                      ? 160.h
                      : 100.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: ColorHelper.bgColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.sp),
                          topRight: Radius.circular(20.sp))),
                  child: Center(
                    child: driverHomeController.activeCall.isEmpty
                        ? CommonComponents().printText(
                            fontSize: 20,
                            textData: "Waiting for the call..",
                            fontWeight: FontWeight.bold)
                        : driverHomeController.activeCall[0].accepted
                            ? _buildPickactions(context)
                            : _buildcallactions(),
                  ),
                )),
          ),
          Align(
              alignment: Alignment.center,
              child: Obx(() => driverHomeController.myActiveTrips.isEmpty || driverHomeController.activeCall.isNotEmpty
                  ? SizedBox()
                  : _authController.checkProfile()?
                  _buildBidList():_buildNumberUpdateView()
              )
          ),
        ],
      )),
    );
  }

  Widget _buildNumberUpdateView(){
    return Container(
      width: 300.w,
      height: 200.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: ColorHelper.blackColor.withOpacity(0.9)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(()=>Column(
              children: [
                CommonComponents().printText(fontSize: 18, textData: "Incoming ride request ${driverHomeController.myActiveTrips.length.toString()}",
                    fontWeight: FontWeight.bold),
                CommonComponents().printText(fontSize: 14, textData: "Update your profile to take actions",
                    fontWeight: FontWeight.bold),
              ],
            )
            ),
            SpaceHelper.verticalSpace10,
            SizedBox(
              width: 120.w,
              child: CommonComponents().commonButton(text: "Update", onPressed: (){
                Get.to(() => ProfileScreen(),
                    transition: Transition.rightToLeft);
              }),
            )
                ],
        ),
      ),
    );
  }

  Widget _buildBidList(){
    return Container(
      width: 300.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: ColorHelper.blackColor.withOpacity(0.9)),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: driverHomeController.myActiveTrips.length,
        itemBuilder: (BuildContext context, int index) {
          var trip = driverHomeController.myActiveTrips[index];
          var bid = trip.bids.firstWhere((mybid) =>
          mybid.driverId ==
              _authController.currentUser.value.uid);
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 85.h,
                    width: 300.w,
                    child: trip.bids.any((mybid) =>
                    mybid.driverId ==
                        _authController.currentUser.value.uid &&
                        mybid.offerPrice != null)
                        ? Center(
                      child: CommonComponents().printText(
                          fontSize: 14,
                          textData:
                          "Waiting for user action",
                          fontWeight: FontWeight.bold),
                    )
                        : Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(trip.userImage??"https://thumb.ac-illust.com/30/30fa090868a2f8236c55ef8c1361db01_t.jpeg"),
                            ),
                            SpaceHelper.horizontalSpace10,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 220.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonComponents().printText(
                                          fontSize: 12,
                                          textData:
                                          trip.userName??"",
                                          fontWeight: FontWeight.bold),
                                      CommonComponents().printText(
                                          fontSize: 12,
                                          color: ColorHelper.primaryColor,
                                          textData:homeController.calculateDistance(
                                              point1:GeoPoint(driverHomeController.userLat.value, driverHomeController.userLong.value),
                                              point2: trip.pickLatLng),
                                          fontWeight: FontWeight.bold)
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 200.w,
                                  child: CommonComponents().printText(
                                      fontSize: 12,
                                      textData:
                                      "From: " + trip.pickUp.toString(),
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    CommonComponents().showRoutesDialog(context,trip.routes,false);
                                  },
                                  child: SizedBox(
                                    width: 220.w,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 160.w,
                                          child: CommonComponents().printText(
                                              fontSize: 12,
                                              textData:
                                              "To: " + trip.destination,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trip.routes.length>1?
                                        Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(90),color: ColorHelper.primaryColor),
                                          child:    Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: CommonComponents().printText(
                                                fontSize: 12,
                                                textData: "${(trip.routes.length-1).toString()} more",
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ):SizedBox()
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),

                        SpaceHelper.verticalSpace10,
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets
                                  .symmetric(
                                  horizontal: 10.0),
                              child: SizedBox(
                                  height: 30.h,
                                  width: 50.w,
                                  child: GestureDetector(
                                    onTap: () {
                                      driverHomeController.addingOffer.value = true;
                                      driverHomeController.offeringTrip.value = trip.tripId;

                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: ColorHelper.bgColor,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context).viewInsets.bottom, // To adjust for the keyboard
                                              left: 16.0,
                                              right: 16.0,
                                              top: 16.0,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  focusNode: driverHomeController.offerFocusNode,
                                                  autofocus: true,
                                                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
                                                  decoration: InputDecoration(
                                                    hintText: "${trip.rent.toString()} \$",
                                                    hintStyle: TextStyle(color: Colors.grey),
                                                    border: InputBorder.none, // No border
                                                  ),
                                                  controller: driverHomeController.offerPriceController,
                                                  keyboardType: TextInputType.number,
                                                ),
                                               SpaceHelper.verticalSpace10,
                                                CommonComponents().commonButton(text: "Submit Offer", onPressed: (){
                                                  driverHomeController.myActiveTrips.contains(trip)?
                                                  DriverRepository().offerRent(
                                                      tripId: trip.tripId,
                                                      driverId:
                                                      _authController.currentUser.value.uid!,
                                                      rent: double.parse(
                                                          driverHomeController
                                                              .offerPriceController
                                                              .text)):
                                                  HomeController().showToast("Request removed or engaged with someone else");
                                                  Navigator.pop(context);
                                                }),
                                                SpaceHelper.verticalSpace10,
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      " ${trip.rent.toString()} \$",
                                      style: StyleHelper.regular14,
                                    ),
                                  )

                              ),
                            ),
                            CommonComponents()
                                .commonButton(
                              color: Colors.red,
                                paddingHorizontal: 12, paddingVertical: 6,
                                text: "Cancel",
                                onPressed: () async{
                                  await PassengerRepository().removeBidByDriverId(tripId:trip.tripId , driverId: _authController.currentUser.value.uid!);
                                  driverHomeController
                                      .listenCall();
                                  await Future.delayed(Duration(seconds: 1));
                                  //driverHomeController.getPolyline(picking: true);
                                }),
                            CommonComponents()
                                .commonButton(
                              paddingHorizontal: 12, paddingVertical: 6,
                                text: "Accept",
                                onPressed: () async{
                                  await DriverRepository()
                                      .AcceptTrip(
                                      trip.tripId,
                                      _authController.currentUser.value.uid!,
                                      trip.rent);
                                  driverHomeController
                                      .listenCall();
                                  await Future.delayed(Duration(seconds: 1));

                                  driverHomeController.getPolyline(startPoint:GeoPoint(driverHomeController.userLat.value, driverHomeController.userLong.value),
                                      endPoint:driverHomeController.activeCall[0].pickLatLng );
                                })
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider()
                ],
              ));
        },
      ),
    );
  }

  Widget _buildcallactions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40.h,
          width: 300.w,
          decoration: BoxDecoration(
              color: ColorHelper.lightGreyColor,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonComponents().printText(
                    fontSize: 18, textData: "To:", fontWeight: FontWeight.bold),
                SpaceHelper.horizontalSpace10,
                SizedBox(
                  width: 210.w,
                  child: CommonComponents().printText(
                      fontSize: 18,
                      textData: driverHomeController.activeCall[0].destination,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
        SpaceHelper.verticalSpace10,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 40.h,
                child: CommonComponents().commonButton(
                    text: "Decline",
                    onPressed: () async {
                      await DriverRepository().cancelRide(
                          driverHomeController.activeCall[0].tripId, driverHomeController.activeCall[0].driverId);
                      driverHomeController.polyLines.clear();
                      driverHomeController.polylineCoordinates.clear();
                    },
                    color: Colors.red,
                    borderRadius: 14)),
            SpaceHelper.horizontalSpace10,
            SizedBox(
                height: 40.h,
                child: CommonComponents().commonButton(
                    text: "Accept",
                    onPressed: () async {
                      DriverRepository().updateTripState(
                          driverHomeController.activeCall[0].tripId,
                          "accepted",
                          true);
                      driverHomeController.getPolyline(startPoint:GeoPoint(driverHomeController.userLat.value, driverHomeController.userLong.value),
                          endPoint:driverHomeController.activeCall[0].pickLatLng );
                    },
                    color: Colors.green,
                    borderRadius: 14))
          ],
        ),
      ],
    );
  }

  Widget _buildPickactions(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            CommonComponents().showRoutesDialog(context,driverHomeController.activeCall[0].routes,true);
          },
          child: Container(
            height: 40.h,
            width: 300.w,
            decoration: BoxDecoration(
                color: ColorHelper.lightGreyColor,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonComponents().printText(
                      fontSize: 18, textData: "To:", fontWeight: FontWeight.bold),
                  SpaceHelper.horizontalSpace10,
                  SizedBox(
                    width: 210.w,
                    child: CommonComponents().printText(
                        fontSize: 18,
                        textData: driverHomeController.activeCall[0].routes
                            .firstWhere((route) => route.currentStatus == "Pending")
                            .destinationPoint,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ),
        SpaceHelper.verticalSpace10,
        driverHomeController.activeCall[0].picked &&
                driverHomeController.activeCall[0].dropped == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 40.h,
                      child: CommonComponents().commonButton(
                          text: "Cancel",
                          onPressed: () async {
                            await DriverRepository().cancelRide(
                                driverHomeController.activeCall[0].tripId, driverHomeController.activeCall[0].driverId);
                            driverHomeController.polyLines.clear();
                            driverHomeController.polylineCoordinates.clear();
                          },
                          color: Colors.red,
                          borderRadius: 14)),
                  SpaceHelper.horizontalSpace10,
                  driverHomeController.activeCall[0].routes.any((route) => route.currentStatus == "Pending")
                  && driverHomeController.activeCall[0].routes.indexWhere((route) => route.currentStatus == "Pending")!=driverHomeController.activeCall[0].routes.length-1
                      ?
                  SizedBox(
                      height: 40.h,
                      child: CommonComponents().commonButton(
                          text: "Next",
                          onPressed: () async {
                            showConfirmationDialog(title: "Completed the route?",
                                onPressConfirm: () async{
                                  await driverHomeController.completeRoute(tripId: driverHomeController.activeCall[0].tripId,
                                      encodedPoly: driverHomeController.activeCall[0].routes
                                          .firstWhere((route) => route.currentStatus == "Pending")
                                          .encodedPolyline
                                  );
                                  await Future.delayed(Duration(seconds: 1));
                                  var newRoute= driverHomeController.activeCall[0].routes[driverHomeController.activeCall[0].routes.indexWhere((route) => route.currentStatus == "Pending")];
                                  driverHomeController.makeGoingPolyLinles(encodePoly: newRoute.encodedPolyline);
                                  // driverHomeController.getPolyline(
                                  //     startPoint: newRoute.pickupLatLng,
                                  //     endPoint: newRoute.destinationLatLng);
                                  Navigator.pop(context);
                                },
                                onPressCancel: () { Navigator.pop(context); },
                                controller: driverHomeController);

                          },
                          color: Colors.green,
                          borderRadius: 14)):
                  SizedBox(
                      height: 40.h,
                      child: CommonComponents().commonButton(
                          text: "Drop and Finish",
                          onPressed: () async {

                            String tripId=driverHomeController.activeCall[0].tripId;
                            String encodedPoly=driverHomeController.activeCall[0].routes
                                .firstWhere((route) => route.currentStatus == "Pending")
                                .encodedPolyline;

                            await DriverRepository().completeRide(tripId,
                                driverHomeController.activeCall[0].driverId);

                            await DriverRepository().completeRoute(tripId: tripId,
                                encodedPoly: encodedPoly
                            );
                            driverHomeController.activeCall.clear();
                            driverHomeController.polylineCoordinates.clear();
                            driverHomeController.polyLines.clear();
                            driverHomeController.mapController.animateCamera(
                                CameraUpdate.newLatLng(
                                    driverHomeController.center.value));
                          },
                          color: Colors.green,
                          borderRadius: 14))
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 40.h,
                      child: CommonComponents().commonButton(
                          text: "Cancel",
                          onPressed: () async {
                            await DriverRepository().cancelRide(
                                driverHomeController.activeCall[0].tripId, driverHomeController.activeCall[0].driverId);
                            driverHomeController.polyLines.clear();
                            driverHomeController.polylineCoordinates.clear();
                          },
                          color: Colors.red,
                          borderRadius: 14)),
                  SpaceHelper.horizontalSpace10,
                  SizedBox(
                      height: 40.h,
                      child: CommonComponents().commonButton(
                          text: "Call",
                          onPressed: () async {
                            driverHomeController.activeCall[0].userPhone!=null?
                            MethodHelper().makePhoneCall(driverHomeController.activeCall[0].userPhone):
                            Fluttertoast.showToast(
                              msg: "Number not available",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );

                          },
                          color: ColorHelper.primaryColor,
                          borderRadius: 14)),
                  SpaceHelper.horizontalSpace10,
                  SizedBox(
                      height: 40.h,
                      child: CommonComponents().commonButton(
                          text: "Pick",
                          onPressed: () async {
                            DriverRepository().updateTripState(
                                driverHomeController.activeCall[0].tripId,
                                "picked",
                                true);
                            var newRoute= driverHomeController.activeCall[0].routes[driverHomeController.activeCall[0].routes.indexWhere((route) => route.currentStatus == "Pending")];
                            driverHomeController.makeGoingPolyLinles(encodePoly: newRoute.encodedPolyline);
                          },
                          color: Colors.green,
                          borderRadius: 14))
                ],
              ),
      ],
    );
  }


  FocusNode focusNode = FocusNode();
  void openKeyboard(BuildContext context){
    FocusScope.of(context).requestFocus(focusNode);
  }
}
