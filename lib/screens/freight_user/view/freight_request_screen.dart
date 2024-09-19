import 'package:callandgo/screens/freight_user/view/freight_trip_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/method_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import '../../../components/confirmation_dialog.dart';
import '../../../components/simple_appbar.dart';
import '../controller/freight_trip_controller.dart';
import 'freight_bid_list.dart';
import 'freight_select_location.dart';

class FreightRequestScreen extends StatefulWidget {
  FreightRequestScreen({Key? key}) : super(key: key);

  @override
  _FreightRequestScreenState createState() => _FreightRequestScreenState();
}

class _FreightRequestScreenState extends State<FreightRequestScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FreightTripController _freightController =
      Get.put(FreightTripController());

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        appBar: SimpleAppbar(
          titleText: 'Freight',
        ),
        backgroundColor: ColorHelper.bgColor,
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCreateRequestView(),
                  _buildRequestListView(),
                  _buildMyRideView(),
                ],
              ),
            ),
            _buildTabBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMyRideView() {
    return Obx(
      () => ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _freightController.onPressItem(
                    trip: _freightController.myTripListForUser[index]);
                Get.to(() => FreightTripDetails(
                    freightTripModel:
                        _freightController.myTripListForUser[index], index: index,));
              },
              child: Card(
                color: ColorHelper.blackColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: _freightController.myTripListForUser[index]
                                          .driverImage !=
                                      null
                                  ? Image.network(
                                      _freightController
                                          .myTripListForUser[index]
                                          .driverImage!,
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
                          Expanded(
                            child: CommonComponents().printText(
                                fontSize: 15,
                                textData: _freightController
                                    .myTripListForUser[index].driverName!,
                                fontWeight: FontWeight.bold),
                          ),
                          _freightController.myTripListForUser[index]
                                      .tripCurrentStatus ==
                                  'accepted'
                              ? _buildMyRideCancelRideButtonView(index: index)
                              : SizedBox()
                        ],
                      ),

                      SpaceHelper.verticalSpace10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.date_range_sharp,
                                  color: ColorHelper.whiteColor),
                              SpaceHelper.horizontalSpace5,
                              CommonComponents().printText(
                                  fontSize: 18,
                                  textData: _freightController.extractDate(
                                      date: _freightController
                                          .myTripListForUser[index].date!),
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.money, color: ColorHelper.whiteColor),
                              SpaceHelper.horizontalSpace5,
                              CommonComponents().printText(
                                  fontSize: 18,
                                  textData:
                                      '${_freightController.myTripListForUser[index].finalPrice!}',
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                        ],
                      ),
                      SpaceHelper.verticalSpace10,
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
                                  '${_freightController.myTripListForUser[index].tripCurrentStatus!.toUpperCase()}',
                              fontWeight: FontWeight.bold,
                              color: MethodHelper().statusColor(
                                  status: _freightController
                                      .myTripListForUser[index]
                                      .tripCurrentStatus!)),
                        ],
                      ),
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
                              textData:
                                  '${_freightController.myTripListForUser[index].from!}',
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
                                  '${_freightController.myTripListForUser[index].to!}',
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                      SpaceHelper.verticalSpace10,
                      // ListTile(

                      //     contentPadding: EdgeInsets.zero,
                      //     leading: Icon(Icons.radio_button_checked,
                      //         color: ColorHelper.primaryColor),
                      //     title: CommonComponents().printText(
                      //         fontSize: 12,
                      //         textData:
                      //             '${_freightController.myTripListForUser[index].from!}',
                      //         fontWeight: FontWeight.normal)),
                      // ListTile(
                      //     contentPadding: EdgeInsets.zero,
                      //     leading: Icon(Icons.radio_button_checked,
                      //         color: ColorHelper.blueColor),
                      //     title: CommonComponents().printText(
                      //         fontSize: 12,
                      //         textData:
                      //             '${_freightController.myTripListForUser[index].to!}',
                      //         fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SpaceHelper.verticalSpace10;
          },
          itemCount: _freightController.myTripListForUser.length),
    );
  }

  Widget _buildMyRideCancelRideButtonView({required int index}) {
    return InkWell(
      onTap: () {
        showConfirmationDialog(
            title: 'Cancel Ride',
            onPressConfirm: () {
              _freightController.onPressCancelForUser(index: index);
            },
            onPressCancel: () => Get.back(),
            controller: _freightController);
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
          CommonComponents().customTab('Create Request', Icons.add),
          CommonComponents().customTab('Request List', Icons.list),
          CommonComponents().customTab('My Ride', Icons.list),
        ],
      ),
    );
  }

  Widget _buildCreateRequestView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpaceHelper.verticalSpace10,
                  _buildTopImgView(),
                  _buildTextFiledView('Pickup location',
                      _freightController.pickUpController.value, true),
                  _buildTextFiledView('Destination',
                      _freightController.destinationController.value, false),
                  _buildSelectionButtons(),
                  _buildDropdownFieldView('Select Size'),
                  SpaceHelper.verticalSpace10,
                  _buildCargoPhoto(),
                  SpaceHelper.verticalSpace10,
                  _buildTextFiledView('Offer your fare',
                      _freightController.offerFareController.value, null),
                  SpaceHelper.verticalSpace10,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          child: _buildBottomButtom(),
        )
      ],
    );
  }

  Widget _buildBottomButtom() {
    return Obx(
      () => CommonComponents().commonButton(
          text: 'Create Request',
          onPressed: () {
            _freightController.onPressCreateRequest();
          },
          isLoading: _freightController.isFreightTripCreationLoading.value,
          disabled: _freightController.isFreightTripCreationLoading.value),
    );
  }

  Widget _buildRequestListView() {
    return Obx(
      () => ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _freightController.selectedTripIndexForUser.value = index;
                Get.to(() => FreightBidList(),
                    transition: Transition.rightToLeft);
              },
              child: Card(
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
                              Icon(Icons.date_range_sharp,
                                  color: ColorHelper.whiteColor),
                              SpaceHelper.horizontalSpace5,
                              CommonComponents().printText(
                                  fontSize: 18,
                                  textData: _freightController.extractDate(
                                      date: _freightController
                                          .tripListForUser[index].date!),
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.money, color: ColorHelper.whiteColor),
                              SpaceHelper.horizontalSpace5,
                              CommonComponents().printText(
                                  fontSize: 18,
                                  textData:
                                      '${_freightController.tripListForUser[index].userPrice!}',
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                          CommonComponents().printText(
                              fontSize: 18,
                              textData:
                                  'Bids: ${_freightController.tripListForUser[index].bids!.length}',
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
                          Expanded(
                            child: CommonComponents().printText(
                              fontSize: 12,
                              textData:
                                  '${_freightController.tripListForUser[index].from!}',
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
                                  '${_freightController.tripListForUser[index].to!}',
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),

                      // ListTile(
                      //     contentPadding: EdgeInsets.zero,
                      //     leading: Icon(Icons.radio_button_checked,
                      //         color: ColorHelper.primaryColor),
                      //     title: CommonComponents().printText(
                      //         fontSize: 12,
                      //         textData:
                      //             '${_freightController.tripListForUser[index].from!}',
                      //         fontWeight: FontWeight.normal)),
                      // ListTile(
                      //     contentPadding: EdgeInsets.zero,
                      //     leading: Icon(Icons.radio_button_checked,
                      //         color: ColorHelper.blueColor),
                      //     title: CommonComponents().printText(
                      //         fontSize: 12,
                      //         textData:
                      //             '${_freightController.tripListForUser[index].to!}',
                      //         fontWeight: FontWeight.normal)),
                      SpaceHelper.verticalSpace15,
                      CommonComponents().commonButton(
                        text: 'Cancel Ride',
                        onPressed: () {
                          _freightController.cancelRideForUser(
                              docId: _freightController
                                  .tripListForUser[index].id!);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SpaceHelper.verticalSpace10;
          },
          itemCount: _freightController.tripListForUser.length),
    );
  }

  Widget _buildSelectionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildButton('10-20 min', 0),
          SpaceHelper.horizontalSpace5,
          _buildButton('Up to 1 hour', 1),
          SpaceHelper.horizontalSpace5,
          _buildButton('Schedule delivery', 2),
        ],
      ),
    );
  }

  Widget _buildButton(String text, int index) {
    return Obx(
      () => Expanded(
        child: ElevatedButton(
            onPressed: () {
              _freightController.selectButton(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _freightController.selectedButtonIndex.value == index
                      ? ColorHelper.primaryColor // Color when selected
                      : Colors.grey, // Default color
            ),
            child: CommonComponents().printText(
                fontSize: 10, textData: text, fontWeight: FontWeight.w400)),
      ),
    );
  }

  Widget _buildTopImgView() => Center(
        child: Image.asset(
          'assets/images/freight-delivery.png',
          color: ColorHelper.primaryColor,
          height: 100.h,
          width: 100.w,
        ),
      );

  Widget _buildTextFiledView(
      String hintText, TextEditingController controller, bool? isFrom) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 10.h, 16.sp, 0.sp),
      child: TextField(
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.white,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.none,
        ),
        onTap: () {
          if (isFrom!) {
            _freightController.changingPickup.value = isFrom;
            Get.to(() => FreightSelectLocation(),
                transition: Transition.rightToLeft);
          } else if (!isFrom) {
            _freightController.changingPickup.value = isFrom;
            Get.to(() => FreightSelectLocation(),
                transition: Transition.rightToLeft);
          }
        },
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: ColorHelper.grey850,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Icon(
            Icons.arrow_forward_ios,
            color: ColorHelper.greyColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownFieldView(String hintText) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 10.h, 16.sp, 0.sp),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorHelper.grey850,
        ),
        child: Obx(() => DropdownButtonFormField<String>(
              value: _freightController.selectedSize.value,
              isDense: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  color: ColorHelper.greyColor,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              ),
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorHelper.greyColor,
                fontWeight: FontWeight.w400,
              ),
              icon: Icon(
                Icons.arrow_forward_ios,
                color: ColorHelper.greyColor,
              ),
              dropdownColor: ColorHelper.whiteColor,
              items: _freightController.sizes
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: _freightController.setSelectedSize,
            )),
      ),
    );
  }

  Widget _buildCargoPhoto() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonComponents().printText(
              fontSize: 16,
              color: ColorHelper.greyColor,
              textData: 'Picture of your cargo',
              fontWeight: FontWeight.w400),
          SpaceHelper.verticalSpace10,
          GestureDetector(
            onTap: () => _freightController.addPhoto(
              _freightController.photoPath.value != ''
                  ? _freightController.photoPath.value
                  : '',
            ),
            child: Container(
              height: 100.h,
              width: 100.w,
              decoration: BoxDecoration(
                  color: ColorHelper.greyIconColor,
                  borderRadius: BorderRadius.circular(8.r)),
              child: Icon(
                Icons.add,
                color: Colors.black26,
              ),
            ),
          )
        ],
      ),
    );
  }
}
