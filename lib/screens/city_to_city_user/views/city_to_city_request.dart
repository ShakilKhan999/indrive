import 'package:callandgo/screens/city_to_city_user/views/cityTocityTripDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/method_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/city_to_city_user/controller/city_to_city_trip_controller.dart';
import 'package:callandgo/screens/city_to_city_user/views/bid_list.dart';
import 'package:callandgo/screens/city_to_city_user/views/city_to_city_select_location.dart';

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
                Get.to(() => CityToCityTripDetailsScreen(
                      cityToCityTripModel:
                          _cityToCityTripController.myTripListForUser[index],
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
                              CommonComponents().printText(
                                  fontSize: 15,
                                  textData: _cityToCityTripController
                                      .myTripListForUser[index].driverName!,
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
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
                          Icon(Icons.radio_button_checked,
                              color: ColorHelper.primaryColor),
                          SpaceHelper.horizontalSpace10,
                          Expanded(
                            child: CommonComponents().printText(
                              fontSize: 12,
                              textData:
                                  '${_cityToCityTripController.myTripListForUser[index].cityFrom!}',
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
                                  '${_cityToCityTripController.myTripListForUser[index].cityTo!}',
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
                      //             '${_cityToCityTripController.myTripListForUser[index].cityFrom!}',
                      //         fontWeight: FontWeight.normal)),
                      // ListTile(
                      //     contentPadding: EdgeInsets.zero,
                      //     leading: Icon(Icons.radio_button_checked,
                      //         color: ColorHelper.blueColor),
                      //     title: CommonComponents().printText(
                      //         fontSize: 12,
                      //         textData:
                      //             '${_cityToCityTripController.myTripListForUser[index].cityTo!}',
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
                                  '${_cityToCityTripController.tripListForUser[index].cityTo!}',
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
                      //             '${_cityToCityTripController.tripListForUser[index].cityFrom!}',
                      //         fontWeight: FontWeight.normal)),
                      // ListTile(
                      //     contentPadding: EdgeInsets.zero,
                      //     leading: Icon(Icons.radio_button_checked,
                      //         color: ColorHelper.blueColor),
                      //     title: CommonComponents().printText(
                      //         fontSize: 12,
                      //         textData:
                      //             '${_cityToCityTripController.tripListForUser[index].cityTo!}',
                      //         fontWeight: FontWeight.normal)),
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
            child: Column(
              children: [
                SpaceHelper.verticalSpace10,
                _buildTextFiledView('From',
                    _cityToCityTripController.fromController.value, true),
                _buildTextFiledView(
                    'To', _cityToCityTripController.toController.value, false),
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
            _cityToCityTripController.onPressFindRider();
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
        onTap: () {
          if (isFrom!) {
            _cityToCityTripController.changingPickup.value = isFrom;
            Get.to(() => CityToCitySelectLocation(),
                transition: Transition.rightToLeft);
          } else if (!isFrom) {
            _cityToCityTripController.changingPickup.value = isFrom;
            Get.to(() => CityToCitySelectLocation(),
                transition: Transition.rightToLeft);
          }
        },
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
