import 'package:callandgo/main.dart';
import 'package:callandgo/screens/auth_screen/controller/auth_controller.dart';
import 'package:callandgo/screens/city_to_city_user/views/city_to_city_trip_details.dart';
import 'package:callandgo/screens/profile/views/profile_screen.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/method_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/city_to_city_user/controller/city_to_city_trip_controller.dart';
import 'package:callandgo/screens/city_to_city_user/views/bid_list.dart';

import '../../../components/confirmation_dialog.dart';
import '../../../components/location_pick_bottom_sheet.dart';

class CityToCityRequest extends StatefulWidget {
  CityToCityRequest({super.key});

  @override
  State<CityToCityRequest> createState() => _CityToCityRequestState();
}

class _CityToCityRequestState extends State<CityToCityRequest>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final CityToCityTripController _cityToCityTripController =
      Get.put(CityToCityTripController());

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
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: _buildAppBarView(),
        backgroundColor: ColorHelper.bgColor,
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFindRiderView(),
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
                _cityToCityTripController.onPressItem(
                    trip: _cityToCityTripController.myTripListForUser[index]);
                Get.to(() => CityToCityTripDetailsScreen(
                      cityToCityTripModel:
                          _cityToCityTripController.myTripListForUser[index],
                      index: index,
                    ));
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
                          Expanded(
                            child: Row(
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
                                    child: _cityToCityTripController
                                                .myTripListForUser[index]
                                                .driverImage !=
                                            null
                                        ? Image.network(
                                            _cityToCityTripController
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
                                      textData: _cityToCityTripController
                                          .myTripListForUser[index].driverName!,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          _cityToCityTripController.myTripListForUser[index]
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
                              Icon(Icons.timer_sharp,
                                  color: ColorHelper.whiteColor),
                              SpaceHelper.horizontalSpace5,
                              CommonComponents().printText(
                                  fontSize: 18,
                                  textData:
                                      '${_cityToCityTripController.myTripListForUser[index].tripType!}',
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.date_range_sharp,
                                  color: ColorHelper.whiteColor),
                              SpaceHelper.horizontalSpace5,
                              CommonComponents().printText(
                                  fontSize: 18,
                                  textData:
                                      '${MethodHelper().formatedDate(_cityToCityTripController.myTripListForUser[index].date!)}',
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
                                      '${_cityToCityTripController.myTripListForUser[index].finalPrice!}',
                                  fontWeight: FontWeight.bold),
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
                                  '${_cityToCityTripController.myTripListForUser[index].tripCurrentStatus!.toUpperCase()}',
                              fontWeight: FontWeight.bold,
                              color: MethodHelper().statusColor(
                                  status: _cityToCityTripController
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
                                    '${_cityToCityTripController.myTripListForUser[index].cityFrom!}',
                                fontWeight: FontWeight.normal,
                                maxLine: 2),
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
                                    '${_cityToCityTripController.myTripListForUser[index].cityTo!}',
                                fontWeight: FontWeight.normal,
                                maxLine: 2),
                          )
                        ],
                      ),
                      SpaceHelper.verticalSpace10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonComponents().printText(
                              fontSize: 15,
                              textData: MethodHelper().timeAgo(
                                  _cityToCityTripController
                                      .myTripListForUser[index].createdAt!),
                              fontWeight: FontWeight.bold),
                          IconButton(
                              onPressed: () {
                                MethodHelper().makePhoneCall(
                                    _cityToCityTripController
                                        .myTripListForUser[index].driverPhone);
                              },
                              icon: Icon(
                                Icons.phone,
                                size: 30,
                                color: ColorHelper.primaryColor,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SpaceHelper.verticalSpace10;
          },
          itemCount: _cityToCityTripController.myTripListForUser.length),
    );
  }

  Widget _buildRequestListView() {
    return Obx(
      () => ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _cityToCityTripController.selectedTripIndexForUser.value =
                    index;
                Get.to(() => BidList(), transition: Transition.rightToLeft);
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
                              Icon(Icons.timer_sharp,
                                  color: ColorHelper.whiteColor),
                              SpaceHelper.horizontalSpace5,
                              CommonComponents().printText(
                                  fontSize: 18,
                                  textData:
                                      '${_cityToCityTripController.tripListForUser[index].tripType!}',
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.date_range_sharp,
                                  color: ColorHelper.whiteColor),
                              SpaceHelper.horizontalSpace5,
                              CommonComponents().printText(
                                  fontSize: 18,
                                  textData:
                                      '${MethodHelper().formatedDate(_cityToCityTripController.tripListForUser[index].date!)}',
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
                                      '${_cityToCityTripController.tripListForUser[index].userPrice!}',
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                        ],
                      ),
                      SpaceHelper.verticalSpace15,
                      CommonComponents().printText(
                          fontSize: 18,
                          textData:
                              'Bids: ${_cityToCityTripController.tripListForUser[index].bids!.length}',
                          fontWeight: FontWeight.bold),
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
                                    '${_cityToCityTripController.tripListForUser[index].cityFrom!}',
                                fontWeight: FontWeight.normal,
                                maxLine: 2),
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
                                    '${_cityToCityTripController.tripListForUser[index].cityTo!}',
                                fontWeight: FontWeight.normal,
                                maxLine: 2),
                          )
                        ],
                      ),
                      SpaceHelper.verticalSpace10,
                      CommonComponents().printText(
                          fontSize: 15,
                          textData: MethodHelper().timeAgo(
                              _cityToCityTripController
                                  .tripListForUser[index].createdAt!),
                          fontWeight: FontWeight.bold),
                      SpaceHelper.verticalSpace10,
                      CommonComponents().commonButton(
                        text: 'Cancel Ride',
                        onPressed: () {
                          _cityToCityTripController.cancelRideForUser(
                              docId: _cityToCityTripController
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
          itemCount: _cityToCityTripController.tripListForUser.length),
    );
  }

  Widget _buildMyRideCancelRideButtonView({required int index}) {
    return InkWell(
      onTap: () {
        showConfirmationDialog(
            title: 'Cancel Ride',
            onPressConfirm: () {
              _cityToCityTripController.onPressCancelForUser(index: index);
            },
            onPressCancel: () => Get.back(),
            controller: _cityToCityTripController);
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
          CommonComponents().customTab('Find Rider', Icons.add),
          CommonComponents().customTab('Request List', Icons.list),
          CommonComponents().customTab('My Ride', Icons.check),
        ],
      ),
    );
  }

  Widget _buildFindRiderView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Obx(
              () => Column(
                children: [
                  SpaceHelper.verticalSpace10,
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.sp, 10.h, 16.sp, 0.sp),
                    child: GestureDetector(
                      onTap: () {
                        buildDestinationBottomSheet(
                            controller: _cityToCityTripController,
                            isFrom: true,
                            from: 'city_to_city');
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          height: 45.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorHelper.secondaryBgColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonComponents().printText(
                                  fontSize: 16,
                                  textData: 'From: ' +
                                      _cityToCityTripController
                                          .fromPlaceName.value,
                                  fontWeight: FontWeight.normal),
                            ],
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.sp, 10.h, 16.sp, 0.sp),
                    child: GestureDetector(
                      onTap: () {
                        buildDestinationBottomSheet(
                            controller: _cityToCityTripController,
                            isFrom: false,
                            from: 'city_to_city');
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          height: 45.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorHelper.secondaryBgColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonComponents().printText(
                                  fontSize: 16,
                                  textData: 'To: ' +
                                      _cityToCityTripController
                                          .toPlaceName.value,
                                  fontWeight: FontWeight.normal),
                            ],
                          )),
                    ),
                  ),
                  SpaceHelper.verticalSpace10,
                  _buildSelectableOptionsRow(),
                  SpaceHelper.verticalSpace10,
                  Obx(() => _buildSelectedOptionContainer(
                      _cityToCityTripController.selectedOptionIndex.value,
                      context)),
                  _buildTextFiledView(
                      'Add description',
                      _cityToCityTripController.addDescriptionController.value,
                      null),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
          child: _buildBottomButtonView(),
        ),
      ],
    );
  }

  AppBar _buildAppBarView() {
    return AppBar(
      backgroundColor: ColorHelper.bgColor,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      title: Title(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonComponents().printText(
              fontSize: 15,
              textData: "City to City",
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonView() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.all(5.sp),
        child: CommonComponents().commonButton(
          text: 'Find a Rider',
          onPressed: () {
            fToast.init(Get.context!);
            AuthController authController = Get.find();
            if (!authController.checkProfile()) {
              showToast(
                  toastText: 'Please complete your profile',
                  toastColor: ColorHelper.red);
              Get.to(() => ProfileScreen(), transition: Transition.rightToLeft);
              return;
            }
            if (_cityToCityTripController.fromController.value.text == '') {
              showToast(
                toastText: "From is requried",
                toastColor: ColorHelper.red,
              );
            } else if (_cityToCityTripController.toController.value.text ==
                '') {
              showToast(
                toastText: "To is required",
                toastColor: ColorHelper.red,
              );
            } else if (_cityToCityTripController.selectedDate.value == null) {
              showToast(
                toastText: "Date is required",
                toastColor: ColorHelper.red,
              );
            } else if ((_cityToCityTripController.selectedOptionIndex.value ==
                    0) &&
                _cityToCityTripController.numberOfPassengers.value == 0) {
              showToast(
                toastText: "Number of passengers is required",
                toastColor: ColorHelper.red,
              );
            } else if (_cityToCityTripController
                    .riderFareController.value.text ==
                '') {
              showToast(
                toastText: "Offer your fear is required",
                toastColor: ColorHelper.red,
              );
            } else if ((_cityToCityTripController.selectedOptionIndex.value ==
                    1) &&
                _cityToCityTripController.parcelFareController.value.text ==
                    '') {
              showToast(
                toastText: "Offer your fear is required",
                toastColor: ColorHelper.red,
              );
            } else if (_cityToCityTripController
                    .addDescriptionController.value.text ==
                '') {
              showToast(
                toastText: "Description is required",
                toastColor: ColorHelper.red,
              );
            } else {
              _cityToCityTripController.onPressFindRider();
            }
          },
          disabled:
              _cityToCityTripController.isCityToCityTripCreationLoading.value,
          isLoading:
              _cityToCityTripController.isCityToCityTripCreationLoading.value,
        ),
      ),
    );
  }

  Widget _buildTextFiledView(
      String hintText, TextEditingController controller, bool? isFrom) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 10.h, 16.sp, 0.sp),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: ColorHelper.grey850,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableOptionsRow() {
    return Obx(() => Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 0, 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildSelectableOption('Ride', 'assets/images/car.png', 0),
              SpaceHelper.horizontalSpace15,
              _buildSelectableOption(
                  'Parcel', 'assets/images/delivery-courier.png', 1),
            ],
          ),
        ));
  }

  Widget _buildSelectableOption(String label, String icon, int index) {
    bool isSelected =
        _cityToCityTripController.selectedOptionIndex.value == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          _cityToCityTripController.tripType.value = 'ride';
        } else {
          _cityToCityTripController.tripType.value = 'parcel';
        }
        _cityToCityTripController.selectedOptionIndex.value = index;
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color:
              isSelected ? ColorHelper.primaryColorShade : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Image.asset(
              icon,
              height: 30.h,
              width: 40.w,
            ),
            SizedBox(height: 5.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? ColorHelper.whiteColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedOptionContainer(int index, BuildContext context) {
    switch (index) {
      case 0:
        return _buildRideContainer(context);
      case 1:
        return _buildSharedRideContainer(context);

      default:
        return Container();
    }
  }

  Widget _buildRideContainer(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            MethodHelper().hideKeyboard();
            DateTime? selectedDate = await showDatePicker(
              context: Get.context!,
              initialDate: _cityToCityTripController.selectedDate.value ??
                  DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (selectedDate != null &&
                selectedDate != _cityToCityTripController.selectedDate.value) {
              _cityToCityTripController.updateDate(selectedDate);
              print("Selected date: ${selectedDate.toLocal()}");
            }
          },
          child: Container(
            height: 40.h,
            width: MediaQuery.of(context).size.width - 30.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorHelper.grey850),
            child: Obx(() => Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Icon(
                            Icons.date_range,
                            color: Colors.grey,
                          ),
                        ),
                        SpaceHelper.horizontalSpace10,
                        Text(
                          _cityToCityTripController.selectedDate.value != null
                              ? 'Selected Date: ${_cityToCityTripController.selectedDate.value!.toLocal().toString().split(' ')[0]}'
                              : 'Select a date',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
        SpaceHelper.verticalSpace10,
        Container(
          height: 40.h,
          width: MediaQuery.of(context).size.width - 30.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorHelper.grey850,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(
                  Icons.people,
                  color: Colors.grey,
                ),
                SpaceHelper.horizontalSpace10,
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: ColorHelper.grey850,
                      hintText: 'Number of Passengers',
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    onChanged: (value) {
                      int? numberOfPassengers = int.tryParse(value);
                      _cityToCityTripController.numberOfPassengers.value =
                          numberOfPassengers ?? 0;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildTextFiledView('Offer your fear',
            _cityToCityTripController.riderFareController.value, null)
      ],
    );
  }

  Widget _buildSharedRideContainer(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: Get.context!,
              initialDate: _cityToCityTripController.selectedDate.value ??
                  DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (selectedDate != null &&
                selectedDate != _cityToCityTripController.selectedDate.value) {
              _cityToCityTripController.updateDate(selectedDate);
              print("Selected date: ${selectedDate.toLocal()}");
            }
          },
          child: Container(
            height: 40.h,
            width: MediaQuery.of(context).size.width - 30.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorHelper.grey850,
            ),
            child: Obx(() => Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: Colors.grey,
                        ),
                        SpaceHelper.horizontalSpace10,
                        Text(
                          _cityToCityTripController.selectedDate.value != null
                              ? 'Selected Date: ${_cityToCityTripController.selectedDate.value!.toLocal().toString().split(' ')[0]}'
                              : 'Select a date',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
        _buildTextFiledView('Offer your fear',
            _cityToCityTripController.parcelFareController.value, null),
        // _buildTextFiledView(
        //     'Describe your parcel',
        //     _cityToCityTripController.parcelDescriptionController.value,
        //     null)
      ],
    );
  }
}
