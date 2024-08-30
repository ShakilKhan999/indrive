import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/driver/freight/controller/freight_controller.dart';

class FreightScreen extends StatelessWidget {
  FreightScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FreightController _freightController = Get.put(FreightController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarView(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
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
                _freightController.offerFareController.value, false),
            Image.asset(
              'assets/images/moto_courier.png',
              color: ColorHelper.primaryColor,
              height: 100.h,
              width: 100.w,
            ),
          ],
        ),
      ),
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
      () => ElevatedButton(
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
              textData: "Freight",
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFiledView(
      String hintText, TextEditingController controller, bool? isFrom) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 10.h, 16.sp, 0.sp),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorHelper.lightGreyColor,
        ),
        child: TextField(
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.none,
          ),
          onTap: () {},
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 16.sp,
              color: ColorHelper.greyColor,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
            suffixIcon: Icon(
              Icons.arrow_forward_ios,
              color: ColorHelper.greyColor,
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
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
          borderRadius: BorderRadius.circular(12),
          color: ColorHelper.lightGreyColor,
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
