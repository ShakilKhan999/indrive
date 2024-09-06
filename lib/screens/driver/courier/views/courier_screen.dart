import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/helpers/style_helper.dart';
import 'package:indrive/screens/driver/courier/controller/courier_controller.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CourierScreen extends StatelessWidget {
  CourierScreen({super.key});
  final CourierController _courierController = Get.put(CourierController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMapView(context),
          _buildTopBackButtonView(),
          _buildCourierDeliveryDeatilsView(),
        ],
      ),
    );
  }

  Widget _buildCourierDeliveryDeatilsView() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleView(),
            SpaceHelper.verticalSpace10,
            _buildOptionsView(),
            SpaceHelper.verticalSpace15,
            _buildSetAddressView(),
            _buildTexfiledView(
                _courierController.toCourierController.value, 'To',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                )),
            SpaceHelper.verticalSpace15,
            _buildOptionButton(Icons.door_front_door, 'Door to door'),
            SpaceHelper.verticalSpace15,
            _buildOderdeatilsView(),
            SpaceHelper.verticalSpace10,
            _buildTexfiledView(_courierController.fareCourierController.value,
                'Offer your fare',
                prefixIcon: Icon(
                  Icons.payment,
                  color: Colors.grey,
                )),
            SpaceHelper.verticalSpace15,
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return CommonComponents()
        .commonButton(onPressed: () {}, text: 'Find a courier');
  }

  Widget _buildTitleView() {
    return CommonComponents().printText(
        fontSize: 20,
        textData: 'Courier delivery',
        fontWeight: FontWeight.bold);
  }

  Widget _buildSetAddressView() {
    return ListTile(
      leading:
          Icon(Icons.radio_button_checked, color: ColorHelper.primaryColor),
      title: Text('STL Rd', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildOptionsView() {
    return Obx(() => Row(
          children: [
            _buildTransportOption(
                'Car', !_courierController.isMotorcycleSelected.value),
            SpaceHelper.horizontalSpace15,
            _buildTransportOption(
                'Motorcycle', _courierController.isMotorcycleSelected.value),
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
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? ColorHelper.primaryColor : Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOderdeatilsView() {
    return GestureDetector(
      onTap: () {
        if (_courierController.isOptionButtonEnabled.value) {
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
            _courierController.isOptionButtonEnabled.value =
                !_courierController.isOptionButtonEnabled.value;
          },
          child: Container(
            width: 130.w,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              color: _courierController.isOptionButtonEnabled.value
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
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
        _buildTexfiledView(_courierController.pickUpStreetInfoController.value,
            'Street,building',
            prefixIcon: Icon(
              Icons.streetview_outlined,
              color: Colors.grey,
            )),
        SpaceHelper.verticalSpace10,
        _buildTexfiledView(_courierController.pickUpFloorInfoController.value,
            'Floor,apartment,entryphone',
            prefixIcon: Icon(
              Icons.apartment,
              color: Colors.grey,
            )),
        SpaceHelper.verticalSpace10,
        _buildPhoneTextFiled(
            context,
            _courierController.pickUpSenderPhoneInfoController.value,
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
            _courierController.deliveryStreetInfoController.value,
            'Street,building',
            prefixIcon: Icon(
              Icons.streetview_outlined,
              color: Colors.grey,
            )),
        SpaceHelper.verticalSpace10,
        _buildTexfiledView(_courierController.deliveryFloorInfoController.value,
            'Floor,apartment,entryphone',
            prefixIcon: Icon(
              Icons.apartment,
              color: Colors.grey,
            )),
        SpaceHelper.verticalSpace10,
        _buildPhoneTextFiled(
            context,
            _courierController.deliverySenderPhoneInfoController.value,
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
          _courierController.descriptionDeliverController.value,
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
            _courierController.pickUpSenderPhoneInfoController.value,
            'Sender phone number'),
        SpaceHelper.verticalSpace5,
        _buildPhoneTextFiled(
            context,
            _courierController.deliverySenderPhoneInfoController.value,
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
}
