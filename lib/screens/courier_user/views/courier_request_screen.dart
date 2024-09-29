import 'dart:developer';

import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/main.dart';
import 'package:callandgo/screens/courier_user/controller/courier_trip_controller.dart';
import 'package:callandgo/screens/courier_user/views/courier_trip_details.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/helpers/style_helper.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../components/confirmation_dialog.dart';
import '../../../components/location_pick_bottom_sheet.dart';
import '../../../helpers/method_helper.dart';
import '../../auth_screen/controller/auth_controller.dart';
import '../../profile/views/profile_screen.dart';
import 'courier_bid_list.dart';

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
                courierTripController.onPressItem(
                    trip: courierTripController.myTripListForUser[index]);
                Get.to(() => CourierTripDetails(
                      courierTripModel:
                          courierTripController.myTripListForUser[index],
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
                                    '${courierTripController.myTripListForUser[index].to!}',
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
                                  courierTripController
                                      .myTripListForUser[index].createdAt!),
                              fontWeight: FontWeight.bold),
                          IconButton(
                              onPressed: () {
                                MethodHelper().makePhoneCall(
                                    courierTripController
                                        .myTripListForUser[index].driverPhone);
                              },
                              icon: Icon(
                                Icons.phone,
                                size: 30,
                                color: ColorHelper.primaryColor,
                              ))
                        ],
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
                                    '${courierTripController.tripListForUser[index].to!}',
                                fontWeight: FontWeight.normal,
                                maxLine: 2),
                          )
                        ],
                      ),
                      SpaceHelper.verticalSpace10,
                      CommonComponents().printText(
                          fontSize: 15,
                          textData: MethodHelper().timeAgo(courierTripController
                              .tripListForUser[index].createdAt!),
                          fontWeight: FontWeight.bold),
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
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOptionsView(),
                    SpaceHelper.verticalSpace15,
                    _buildFromSelectView(),
                    SpaceHelper.verticalSpace15,
                    _buildToSelectView(),
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
          ),
          SpaceHelper.verticalSpace10,
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Obx(
      () => CommonComponents().commonButton(
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
          if (courierTripController.toController.value.text == '') {
            showToast(
              toastText: "Pickup location is required",
              toastColor: ColorHelper.red,
            );
          } else if (courierTripController.fromController.value.text == '') {
            showToast(
              toastText: "Destination is required",
              toastColor: ColorHelper.red,
            );
          } else if ((courierTripController.isOptionButtonEnabled.value ==
                  false) &&
              courierTripController
                      .pickUpSenderPhoneInfoController.value.text ==
                  '') {
            showToast(
              toastText: "Sender phone number is required",
              toastColor: ColorHelper.red,
            );
          } else if ((courierTripController.isOptionButtonEnabled.value ==
                  false) &&
              courierTripController.recipientPhoneController.value.text == '') {
            showToast(
              toastText: "Recipient phone number is required",
              toastColor: ColorHelper.red,
            );
          } else if ((courierTripController.isOptionButtonEnabled.value ==
                  true) &&
              courierTripController.pickUpStreetInfoController.value.text ==
                  '') {
            showToast(
              toastText: "Street,building is required",
              toastColor: ColorHelper.red,
            );
          } else if ((courierTripController.isOptionButtonEnabled.value ==
                  true) &&
              courierTripController.pickUpFloorInfoController.value.text ==
                  '') {
            showToast(
              toastText: "Floor,apartment,entryphone is required",
              toastColor: ColorHelper.red,
            );
          } else if ((courierTripController.isOptionButtonEnabled.value ==
                  true) &&
              courierTripController
                      .pickUpSenderPhoneInfoController.value.text ==
                  '') {
            showToast(
              toastText: "Sender phone number is required",
              toastColor: ColorHelper.red,
            );
          } else if ((courierTripController.isOptionButtonEnabled.value ==
                  true) &&
              courierTripController.deliveryStreetInfoController.value.text ==
                  '') {
            showToast(
              toastText: "Street,building is required",
              toastColor: ColorHelper.red,
            );
          } else if ((courierTripController.isOptionButtonEnabled.value ==
                  true) &&
              courierTripController.deliveryFloorInfoController.value.text ==
                  '') {
            showToast(
              toastText: "Floor,apartment,entryphone is required",
              toastColor: ColorHelper.red,
            );
          } else if ((courierTripController.isOptionButtonEnabled.value ==
                  true) &&
              courierTripController.recipientPhoneController.value.text == '') {
            showToast(
              toastText: "Recipient phone number is required",
              toastColor: ColorHelper.red,
            );
          } else if (courierTripController
                  .descriptionDeliverController.value.text ==
              '') {
            showToast(
              toastText: "Description is required",
              toastColor: ColorHelper.red,
            );
          } else if (courierTripController.fareCourierController.value.text ==
              '') {
            showToast(
              toastText: "Offer your fare is required",
              toastColor: ColorHelper.red,
            );
          } else {
            courierTripController.onPressCreateRequest();
          }
        },
        text: 'Find a courier',
        isLoading: courierTripController.isCourierTripCreationLoading.value,
        disabled: courierTripController.isCourierTripCreationLoading.value,
      ),
    );
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
        MethodHelper().hideKeyboard();
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
                CommonComponents().commonButton(
                    text: 'Save',
                    onPressed: () {
                      Get.back();
                    })
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
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.cancel_rounded,
            color: Colors.grey,
          ),
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
      onCountryChanged: (value) {
        log('Country: $value');
      },
      onChanged: (phone) {
        if (labelText == 'Sender phone number') {
          courierTripController.senderPhoneNumber.value =
              '${phone.countryCode}${phone.number}';
          log('sender phone: ${courierTripController.senderPhoneNumber.value}');
        } else {
          courierTripController.recipientPhoneNumber.value =
              '${phone.countryCode}${phone.number}';
          log('recipient phone: ${courierTripController.recipientPhoneNumber.value}');
        }
      },
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

  Widget _buildFromSelectView() {
    return GestureDetector(
      onTap: () {
        buildDestinationBottomSheet(
            controller: courierTripController, isFrom: true, from: 'courier');
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
                  textData:
                      'From: ' + courierTripController.fromPlaceName.value,
                  fontWeight: FontWeight.normal),
            ],
          )),
    );
  }

  Widget _buildToSelectView() {
    return GestureDetector(
      onTap: () {
        buildDestinationBottomSheet(
            controller: courierTripController, isFrom: false, from: 'courier');
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
                  textData: 'To: ' + courierTripController.toPlaceName.value,
                  fontWeight: FontWeight.normal),
            ],
          )),
    );
  }
}
