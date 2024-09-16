import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/screens/courier_user/controller/courier_trip_controller.dart';
import 'package:callandgo/screens/courier_user/views/courier_trip_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/helpers/style_helper.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../components/confirmation_dialog.dart';
import '../../../helpers/method_helper.dart';
import 'courier_bid_list.dart';
import 'courier_select_location.dart';

class CourierRequestScreen extends StatefulWidget {
  CourierRequestScreen({super.key});

  @override
  State<CourierRequestScreen> createState() => _CourierRequestScreenState();
}

class _CourierRequestScreenState extends State<CourierRequestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CourierTripController courierTripController =
      Get.put(CourierTripController());

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
    return Scaffold(
        backgroundColor: ColorHelper.bgColor,
        appBar: SimpleAppbar(titleText: 'Courier'),
        body: Column(
          children: [
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                _buildCreateRequestView(context),
                _buildRequestListView(),
                _buildMyRideView(),
              ],
            )),
            _buildTabBar(),
          ],
        ));
  }

  Widget _buildMyRideView() {
    return Obx(
      () => ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.to(() => CourierTripDetails(
                    courierTripModel:
                        courierTripController.myTripListForUser[index]));
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
                              child: courierTripController
                                          .myTripListForUser[index]
                                          .driverImage !=
                                      null
                                  ? Image.network(
                                      courierTripController
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
                                textData: courierTripController
                                    .myTripListForUser[index].driverName!,
                                fontWeight: FontWeight.bold),
                          ),
                          courierTripController.myTripListForUser[index]
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
                              Icon(Icons.money, color: ColorHelper.whiteColor),
                              SpaceHelper.horizontalSpace5,
                              CommonComponents().printText(
                                  fontSize: 18,
                                  textData:
                                      '${courierTripController.myTripListForUser[index].finalPrice!}',
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
                                  '${courierTripController.myTripListForUser[index].tripCurrentStatus!.toUpperCase()}',
                              fontWeight: FontWeight.bold,
                              color: MethodHelper().statusColor(
                                  status: courierTripController
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
                                  '${courierTripController.myTripListForUser[index].from!}',
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
                                  '${courierTripController.myTripListForUser[index].to!}',
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                      SpaceHelper.verticalSpace10,
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SpaceHelper.verticalSpace10;
          },
          itemCount: courierTripController.myTripListForUser.length),
    );
  }

  Widget _buildMyRideCancelRideButtonView({required int index}) {
    return InkWell(
      onTap: () {
        showConfirmationDialog(
            title: 'Cancel Ride',
            onPressConfirm: () {
              courierTripController.onPressCancelForUser(index: index);
            },
            onPressCancel: () => Get.back(),
            controller: courierTripController);
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

  Widget _buildRequestListView() {
    return Obx(
      () => ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                courierTripController.selectedTripIndexForUser.value = index;
                Get.to(() => CourierBidList(),
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
                              Icon(Icons.money, color: ColorHelper.whiteColor),
                              SpaceHelper.horizontalSpace5,
                              CommonComponents().printText(
                                  fontSize: 18,
                                  textData:
                                      '${courierTripController.tripListForUser[index].userPrice!}',
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                          CommonComponents().printText(
                              fontSize: 18,
                              textData:
                                  'Bids: ${courierTripController.tripListForUser[index].bids!.length}',
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
                                  '${courierTripController.tripListForUser[index].from!}',
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
                                  '${courierTripController.tripListForUser[index].to!}',
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                      SpaceHelper.verticalSpace10,
                      CommonComponents().commonButton(
                        text: 'Cancel Ride',
                        onPressed: () {
                          courierTripController.cancelRideForUser(
                              docId: courierTripController
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
          itemCount: courierTripController.tripListForUser.length),
    );
  }

  Widget _buildCreateRequestView(BuildContext context) {
    return _buildCourierDeliveryDeatilsView();
  }

  Widget _buildCourierDeliveryDeatilsView() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOptionsView(),
                  SpaceHelper.verticalSpace15,
                  _buildTextFiledView('Pickup location',
                      courierTripController.pickUpController.value, true),
                  SpaceHelper.verticalSpace15,
                  _buildTextFiledView('Destination location',
                      courierTripController.destinationController.value, false),
                  SpaceHelper.verticalSpace15,
                  _buildOptionButton(Icons.door_front_door, 'Door to door'),
                  SpaceHelper.verticalSpace15,
                  _buildOderdeatilsView(),
                  SpaceHelper.verticalSpace10,
                  _buildTexfiledView(
                    courierTripController.fareCourierController.value,
                    'Offer your fare',
                    prefixIcon: Icon(
                      Icons.payment,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SpaceHelper.verticalSpace10,
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildTextFiledView(
      String hintText, TextEditingController controller, bool? isFrom) {
    return TextField(
      style: TextStyle(
        fontSize: 16.sp,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.none,
      ),
      onTap: () {
        if (isFrom!) {
          courierTripController.changingPickup.value = isFrom;
          Get.to(() => CourierSelectLocation(),
              transition: Transition.rightToLeft);
        } else if (!isFrom) {
          courierTripController.changingPickup.value = isFrom;
          Get.to(() => CourierSelectLocation(),
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
    );
  }

  Widget _buildBottomButton() {
    return CommonComponents().commonButton(
        onPressed: () {
          courierTripController.onPressCreateRequest();
        },
        text: 'Find a courier');
  }

  Widget _buildTitleView() {
    return CommonComponents().printText(
        fontSize: 20,
        textData: 'Courier delivery',
        fontWeight: FontWeight.bold);
  }

  Widget _buildOptionsView() {
    return Obx(() => Row(
          children: [
            _buildTransportOption(
                'Car', !courierTripController.isMotorcycleSelected.value),
            SpaceHelper.horizontalSpace15,
            _buildTransportOption(
                'Motorcycle', courierTripController.isMotorcycleSelected.value),
          ],
        ));
  }

  Widget _buildMapView(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: ColorHelper.whiteColor,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(23.80, 90.41),
          zoom: 15.0,
        ),
      ),
    );
  }

  Widget _buildTopBackButtonView() {
    return Positioned(
      top: 30.h,
      left: 15.w,
      child: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTexfiledView(TextEditingController controller, String text,
      {Icon? prefixIcon, int? maxLines}) {
    return TextField(
      maxLines: maxLines,
      // expands: true,
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: text,
        hintTextDirection: TextDirection.ltr,
        hintStyle: TextStyle(
            color: Colors.grey, fontSize: 14.sp, fontWeight: FontWeight.w600),
        prefixIcon: prefixIcon,
        filled: true,
        helperMaxLines: 2,
        hintMaxLines: 4,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildTransportOption(String title, bool selected) {
    return Expanded(
      child: InkWell(
        onTap: () {
          courierTripController.onPressTransportOption(title);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: courierTripController.transportOptionList.contains(title)
                ? ColorHelper.primaryColor
                : Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: courierTripController.transportOptionList.contains(title)
                    ? Colors.white
                    : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOderdeatilsView() {
    return GestureDetector(
      onTap: () {
        if (courierTripController.isOptionButtonEnabled.value) {
          _showEnabledBottomSheet(Get.context!);
        } else {
          _showDisabledBottomSheet(Get.context!);
        }
      },
      child: Container(
        width: double.infinity,
        height: 40.h,
        decoration: BoxDecoration(
          color: ColorHelper.grey850,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(
                Icons.details,
                color: Colors.grey,
              ),
            ),
            SpaceHelper.horizontalSpace10,
            CommonComponents().printText(
                fontSize: 14,
                textData: 'Order Deatils',
                color: Colors.grey,
                fontWeight: FontWeight.w600)
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(IconData icon, String label) {
    return Obx(() => GestureDetector(
          onTap: () {
            courierTripController.isOptionButtonEnabled.value =
                !courierTripController.isOptionButtonEnabled.value;
          },
          child: Container(
            width: 140.w,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              color: courierTripController.isOptionButtonEnabled.value
                  ? ColorHelper.primaryColor
                  : ColorHelper.grey850,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: Icon(icon, color: Colors.grey),
                ),
                SpaceHelper.horizontalSpace5,
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showEnabledBottomSheet(context) {
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
              children: [
                _buildPickUpInfoView(context),
                _buildDeliveryInfoView(context),
                _buildBottomDescription(),
                SpaceHelper.verticalSpace10,
                CommonComponents().commonButton(text: 'Save', onPressed: () {})
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickUpInfoView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopTextView(),
        SpaceHelper.verticalSpace10,
        CommonComponents().printText(
            fontSize: 16,
            textData: 'Where to pick up',
            fontWeight: FontWeight.w600),
        SpaceHelper.verticalSpace5,
        _buildTexfiledView(
            courierTripController.pickUpStreetInfoController.value,
            'Street,building',
            prefixIcon: Icon(
              Icons.streetview_outlined,
              color: Colors.grey,
            )),
        SpaceHelper.verticalSpace10,
        _buildTexfiledView(
            courierTripController.pickUpFloorInfoController.value,
            'Floor,apartment,entryphone',
            prefixIcon: Icon(
              Icons.apartment,
              color: Colors.grey,
            )),
        SpaceHelper.verticalSpace10,
        _buildPhoneTextFiled(
            context,
            courierTripController.pickUpSenderPhoneInfoController.value,
            'Sender phone number'),
      ],
    );
  }

  Widget _buildDeliveryInfoView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceHelper.verticalSpace10,
        CommonComponents().printText(
            fontSize: 16,
            textData: 'Where to deliver',
            fontWeight: FontWeight.w600),
        SpaceHelper.verticalSpace5,
        _buildTexfiledView(
            courierTripController.deliveryStreetInfoController.value,
            'Street,building',
            prefixIcon: Icon(
              Icons.streetview_outlined,
              color: Colors.grey,
            )),
        SpaceHelper.verticalSpace10,
        _buildTexfiledView(
            courierTripController.deliveryFloorInfoController.value,
            'Floor,apartment,entryphone',
            prefixIcon: Icon(
              Icons.apartment,
              color: Colors.grey,
            )),
        SpaceHelper.verticalSpace10,
        _buildPhoneTextFiled(
            context,
            courierTripController.recipientPhoneController.value,
            'Recipient phone number'),
      ],
    );
  }

  Widget _buildBottomDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceHelper.verticalSpace10,
        CommonComponents().printText(
            fontSize: 16,
            textData: 'What to deliver',
            fontWeight: FontWeight.w600),
        SpaceHelper.verticalSpace5,
        _buildTexfiledView(
          maxLines: 3,
          courierTripController.descriptionDeliverController.value,
          'Add description',
        ),
      ],
    );
  }

  void _showDisabledBottomSheet(context) {
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
              children: [
                _buildTopTextView(),
                SpaceHelper.verticalSpace10,
                _buildSenderRecipientPhoneNumberView(context),
                _buildBottomDescription(),
                SpaceHelper.verticalSpace10,
                CommonComponents().commonButton(text: 'Save', onPressed: () {})
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopTextView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonComponents().printText(
            fontSize: 16,
            textData: 'Oder details',
            fontWeight: FontWeight.w600),
        Icon(
          Icons.cancel_rounded,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget _buildSenderRecipientPhoneNumberView(BuildContext context) {
    return Column(
      children: [
        _buildPhoneTextFiled(
            context,
            courierTripController.pickUpSenderPhoneInfoController.value,
            'Sender phone number'),
        SpaceHelper.verticalSpace5,
        _buildPhoneTextFiled(
            context,
            courierTripController.recipientPhoneController.value,
            'Recipient phone number'),
      ],
    );
  }

  Widget _buildPhoneTextFiled(BuildContext context,
      TextEditingController controller, String labelText) {
    return IntlPhoneField(
      controller: controller,
      cursorColor: Colors.grey,
      style: StyleHelper.regular14,
      dropdownTextStyle: const TextStyle(color: Colors.grey),
      dropdownIcon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.grey,
      ),
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey),
          fillColor: ColorHelper.grey850,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorHelper.grey850,
              width: 2.0,
            ),
          ),
          suffixIcon: Icon(
            Icons.contact_page,
            color: Colors.grey,
          )),
      initialCountryCode: 'BD',
      onCountryChanged: (value) {},
      onChanged: (phone) {},
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
}
