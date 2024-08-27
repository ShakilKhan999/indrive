import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_drawer.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/city_to_city_user/controller/city_to_city_request_controller.dart';

class CityToCityRequest extends StatelessWidget {
  CityToCityRequest({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final CityToCityRequestController _cityToCityRequestController =
      Get.put(CityToCityRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(),
      appBar: _buildAppBarView(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SpaceHelper.verticalSpace10,
                  _buildTextFiledView(
                    'From',
                    _cityToCityRequestController.fromController.value,
                  ),
                  _buildTextFiledView(
                    'To',
                    _cityToCityRequestController.toController.value,
                  ),
                  SpaceHelper.verticalSpace10,
                  _buildSelectableOptionsRow(),
                  SpaceHelper.verticalSpace10,
                  Obx(() => _buildSelectedOptionContainer(
                      _cityToCityRequestController.selectedOptionIndex.value,
                      context)),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: _buildBottomButtonView(),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBarView() {
    return AppBar(
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
      actions: [
        Container(
          width: 40,
        )
      ],
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
    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: CommonComponents()
          .commonButton(text: 'Find a Rider', onPressed: () {}),
    );
  }

  Widget _buildTextFiledView(
      String hintText, TextEditingController controller) {
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

  Widget _buildSelectableOptionsRow() {
    return Obx(() => Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 0, 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildSelectableOption('Ride', 'assets/images/car.png', 0),
              SpaceHelper.horizontalSpace15,
              _buildSelectableOption(
                  'Courier', 'assets/images/delivery-courier.png', 1),
            ],
          ),
        ));
  }

  Widget _buildSelectableOption(String label, String icon, int index) {
    bool isSelected =
        _cityToCityRequestController.selectedOptionIndex.value == index;
    return GestureDetector(
      onTap: () {
        _cityToCityRequestController.selectedOptionIndex.value = index;
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
                color: isSelected ? Colors.blue : Colors.grey,
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
            DateTime? selectedDate = await showDatePicker(
              context: Get.context!,
              initialDate: _cityToCityRequestController.selectedDate.value ??
                  DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (selectedDate != null &&
                selectedDate !=
                    _cityToCityRequestController.selectedDate.value) {
              _cityToCityRequestController.updateDate(selectedDate);
              print("Selected date: ${selectedDate.toLocal()}");
            }
          },
          child: Container(
            height: 40.h,
            width: MediaQuery.of(context).size.width - 30.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ColorHelper.lightGreyColor,
            ),
            child: Obx(() => Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Icon(Icons.date_range),
                        SpaceHelper.horizontalSpace10,
                        Text(
                          _cityToCityRequestController.selectedDate.value !=
                                  null
                              ? 'Selected Date: ${_cityToCityRequestController.selectedDate.value!.toLocal().toString().split(' ')[0]}'
                              : 'Select a date',
                          style: TextStyle(
                            color: ColorHelper.greyColor,
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
            borderRadius: BorderRadius.circular(12),
            color: ColorHelper.lightGreyColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(Icons.people),
                SpaceHelper.horizontalSpace10,
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Number of Passengers',
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: ColorHelper.greyColor,
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    onChanged: (value) {
                      int? numberOfPassengers = int.tryParse(value);
                      _cityToCityRequestController.numberOfPassengers.value =
                          numberOfPassengers ?? 0;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildTextFiledView('Offer your fear',
            _cityToCityRequestController.riderFareController.value)
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
              initialDate: _cityToCityRequestController.selectedDate.value ??
                  DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (selectedDate != null &&
                selectedDate !=
                    _cityToCityRequestController.selectedDate.value) {
              _cityToCityRequestController.updateDate(selectedDate);
              print("Selected date: ${selectedDate.toLocal()}");
            }
          },
          child: Container(
            height: 40.h,
            width: MediaQuery.of(context).size.width - 30.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ColorHelper.lightGreyColor,
            ),
            child: Obx(() => Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Icon(Icons.date_range),
                        SpaceHelper.horizontalSpace10,
                        Text(
                          _cityToCityRequestController.selectedDate.value !=
                                  null
                              ? 'Selected Date: ${_cityToCityRequestController.selectedDate.value!.toLocal().toString().split(' ')[0]}'
                              : 'Select a date',
                          style: TextStyle(
                            color: Colors.black,
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
            _cityToCityRequestController.parcelFareController.value),
        _buildTextFiledView('Describe your parcel',
            _cityToCityRequestController.parcelDescriptionController.value)
      ],
    );
  }
}
