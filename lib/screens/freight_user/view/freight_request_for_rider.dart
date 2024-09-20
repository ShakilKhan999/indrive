import 'package:callandgo/screens/freight_user/view/freight_trip_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/method_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/freight_user/controller/freight_trip_controller.dart';
import '../../../components/common_components.dart';
import '../../../components/confirmation_dialog.dart';

class FreightRequesForRider extends StatefulWidget {
  FreightRequesForRider({super.key});

  @override
  State<FreightRequesForRider> createState() => _FreightRequesForRiderState();
}

class _FreightRequesForRiderState extends State<FreightRequesForRider>
    with SingleTickerProviderStateMixin {
  // final CityToCityTripController _freightTripController =
  //     Get.put(CityToCityTripController());
  final FreightTripController _freightTripController =
      Get.put(FreightTripController());
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MethodHelper().hideKeyboard();
      },
      child: Scaffold(
        backgroundColor: ColorHelper.bgColor,
        appBar: _buildAppBarView(),
        // body: _buildBodyView(),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRequestListView(),
                  Obx(() => _buildMyRequestView()),
                ],
              ),
            ),
            _buildTabBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMyRequestView() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _freightTripController.onPressItem(
                  trip: _freightTripController.myTripList[index]);
              Get.to(() => FreightTripDetails(
                  freightTripModel: _freightTripController.myTripList[index]));
            },
            child: Card(
              color: ColorHelper.blackColor,
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 35.h,
                              width: 35.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: _freightTripController
                                            .myTripList[index].userImage !=
                                        null
                                    ? Image.network(
                                        _freightTripController
                                            .myTripList[index].userImage!,
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
                            SpaceHelper.horizontalSpace10,
                            Padding(
                              padding: EdgeInsets.only(left: 3.w),
                              child: SizedBox(
                                width: 120.w,
                                child: Text(
                                  '${_freightTripController.myTripList[index].userName}',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _freightTripController
                                        .myTripList[index].tripCurrentStatus ==
                                    'accepted'
                                ? _buildMyRideCancelRideButtonView(index: index)
                                : SizedBox(),
                            SpaceHelper.horizontalSpace5,
                            _freightTripController
                                        .myTripList[index].tripCurrentStatus ==
                                    'accepted'
                                ? _buildMyRidePickupButtonView(index: index)
                                : _freightTripController.myTripList[index]
                                            .tripCurrentStatus ==
                                        'picked up'
                                    ? _buildMyRideDropButtonView(index: index)
                                    : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                    SpaceHelper.verticalSpace15,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CommonComponents().printText(
                          fontSize: 12,
                          textData: 'Status :',
                          fontWeight: FontWeight.w600,
                        ),
                        SpaceHelper.horizontalSpace10,
                        CommonComponents().printText(
                            fontSize: 12,
                            textData:
                                '${_freightTripController.myTripList[index].tripCurrentStatus!.toUpperCase()}',
                            fontWeight: FontWeight.bold,
                            color: MethodHelper().statusColor(
                                status: _freightTripController
                                    .myTripList[index].tripCurrentStatus!)),
                      ],
                    ),
                    SpaceHelper.verticalSpace10,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CommonComponents().printText(
                          fontSize: 12,
                          textData: 'Price :',
                          fontWeight: FontWeight.w600,
                        ),
                        SpaceHelper.horizontalSpace10,
                        CommonComponents().printText(
                          fontSize: 12,
                          textData:
                              '${_freightTripController.myTripList[index].finalPrice}',
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SpaceHelper.verticalSpace10,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.radio_button_checked,
                            color: ColorHelper.primaryColor),
                        SpaceHelper.horizontalSpace10,
                        Expanded(
                          child: CommonComponents().printText(
                            fontSize: 12,
                            textData:
                                '${_freightTripController.myTripList[index].from}',
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
                            textData:
                                '${_freightTripController.myTripList[index].to}',
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SpaceHelper.verticalSpace5;
        },
        itemCount: _freightTripController.myTripList.length);
  }

  Widget _buildTabBar() {
    return Container(
      color: ColorHelper.secondaryBgColor,
      child: TabBar(
        padding: EdgeInsets.zero,
        controller: _tabController,
        indicatorPadding: EdgeInsets.all(2.sp),
        indicatorColor: ColorHelper.primaryColor,
        unselectedLabelColor: Colors.grey,
        labelColor: ColorHelper.primaryColor,
        tabs: [
          CommonComponents().customTab('Request List', Icons.add),
          CommonComponents().customTab('My Ride', Icons.list),
        ],
      ),
    );
  }

  Widget _buildRequestListView() {
    return Obx(
      () => _freightTripController.tripList.isNotEmpty
          ? ListView.separated(
              itemBuilder: (context, index) {
                return Card(
                  color: ColorHelper.blackColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 35.h,
                                  width: 35.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.white)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: _freightTripController
                                                .tripList[index].userImage !=
                                            null
                                        ? Image.network(
                                            _freightTripController
                                                .tripList[index].userImage!,
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
                                SpaceHelper.horizontalSpace10,
                                CommonComponents().printText(
                                    fontSize: 15,
                                    textData: _freightTripController
                                        .tripList[index].userName!,
                                    fontWeight: FontWeight.bold),
                              ],
                            ),
                            CommonComponents().printText(
                                fontSize: 15,
                                textData: _freightTripController
                                    .tripList[index].userPrice!,
                                fontWeight: FontWeight.bold),
                          ],
                        ),
                        SpaceHelper.verticalSpace15,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.radio_button_checked,
                                color: ColorHelper.primaryColor),
                            SpaceHelper.horizontalSpace10,
                            CommonComponents().printText(
                                fontSize: 12,
                                textData:
                                    '${_freightTripController.tripList[index].from!}',
                                fontWeight: FontWeight.normal)
                          ],
                        ),
                        SpaceHelper.verticalSpace5,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.radio_button_checked,
                                color: ColorHelper.blueColor),
                            SpaceHelper.horizontalSpace10,
                            CommonComponents().printText(
                                fontSize: 12,
                                textData:
                                    '${_freightTripController.tripList[index].to!}',
                                fontWeight: FontWeight.normal)
                          ],
                        ),
                        SpaceHelper.verticalSpace15,
                        _buildOfferYourFareView(index: index),
                        SpaceHelper.verticalSpace10,
                        _buildActionView(index: index)
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SpaceHelper.verticalSpace5;
              },
              itemCount: _freightTripController.tripList.length)
          : Center(
              child: CommonComponents().printText(
                  fontSize: 18,
                  textData: 'No Request List Found',
                  fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget _buildActionView({required int index}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            _freightTripController.selectedTripIndex.value = index;
            _freightTripController.declineRide();
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
            _freightTripController.selectedTripIndex.value = index;
            _freightTripController.acceptRide();
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

  Widget _buildOfferYourFareView({required int index}) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _showOfferFareBottomSheet(index),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 12.0.h),
              decoration: BoxDecoration(
                color: ColorHelper.grey850,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                String displayText = _freightTripController
                        .driverOfferYourFareController[index].text.isEmpty
                    ? 'Offer your fare'
                    : 'Offer: ${_freightTripController.driverOfferYourFareController[index].text}';
                return Row(
                  children: [
                    Icon(Icons.payment, color: Colors.grey),
                    SizedBox(width: 10.w),
                    Text(
                      displayText,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTexfiledView(
      TextEditingController controller, String text, Icon prefixIcon) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: text,
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  AppBar _buildAppBarView() {
    return AppBar(
      backgroundColor: ColorHelper.blackColor,
      iconTheme: IconThemeData(color: ColorHelper.whiteColor),
      centerTitle: true,
      title: CommonComponents().printText(
        fontSize: 15,
        textData: "Freight Requests",
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _showOfferFareBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0.w,
            right: 16.0.w,
            top: 16.0.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonComponents().printText(
                    fontSize: 16,
                    textData: 'Enter your fare offer',
                    fontWeight: FontWeight.w600),
                SizedBox(height: 10.h),
                _buildTexfiledView(
                  _freightTripController.driverOfferYourFareController[index],
                  'Enter fare',
                  Icon(Icons.payment, color: Colors.grey),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                    _freightTripController.selectedTripIndex.value = index;
                    _freightTripController.sendDriverFareOffer();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHelper.blueColor,
                  ),
                  child: CommonComponents().printText(
                      fontSize: 16,
                      textData: 'Offer',
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMyRideDropButtonView({required int index}) {
    return InkWell(
      onTap: () {
        showConfirmationDialog(
            title: 'Drop',
            onPressConfirm: () async {
              _freightTripController.onPressDrop(index: index);
            },
            onPressCancel: () => Get.back(),
            controller: _freightTripController);
      },
      child: Container(
        padding: EdgeInsets.all(7.sp),
        decoration: BoxDecoration(
          color: ColorHelper.primaryColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: CommonComponents().printText(
              fontSize: 14, textData: 'Drop', fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildMyRidePickupButtonView({required int index}) {
    return InkWell(
      onTap: () {
        showConfirmationDialog(
            title: 'Pickup',
            onPressConfirm: () async {
              _freightTripController.onPressPickup(index: index);
            },
            onPressCancel: () => Get.back(),
            controller: _freightTripController);
      },
      child: Container(
        padding: EdgeInsets.all(7.sp),
        decoration: BoxDecoration(
          color: ColorHelper.primaryColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: CommonComponents().printText(
              fontSize: 14, textData: 'Pick Up', fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildMyRideCancelRideButtonView({required int index}) {
    return InkWell(
      onTap: () {
        showConfirmationDialog(
            title: 'Cancel Ride',
            onPressConfirm: () {
              _freightTripController.onPressCancel(index: index);
            },
            onPressCancel: () => Get.back(),
            controller: _freightTripController);
      },
      child: Container(
        padding: EdgeInsets.all(7.sp),
        decoration: BoxDecoration(
          color: ColorHelper.red,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: CommonComponents().printText(
              fontSize: 14,
              textData: 'Cancel Ride',
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
