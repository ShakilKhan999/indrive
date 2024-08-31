import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/method_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/city_to_city_user/controller/city_to_city_trip_controller.dart';
import '../../../components/common_components.dart';

class DriverCityToCityRequestList extends StatelessWidget {
  DriverCityToCityRequestList({super.key});

  final CityToCityTripController _cityToCityTripController =
      Get.put(CityToCityTripController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MethodHelper().hideKeyboard();
      },
      child: Scaffold(
        backgroundColor: ColorHelper.bgColor,
        appBar: _buildAppBarView(),
        body: _buildBodyView(),
      ),
    );
  }

  Widget _buildBodyView() {
    return Obx(
      () => ListView.separated(
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
                                child: _cityToCityTripController
                                            .tripList[index].userImage !=
                                        null
                                    ? Image.network(
                                        _cityToCityTripController
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
                                textData: _cityToCityTripController
                                    .tripList[index].userName!,
                                fontWeight: FontWeight.bold),
                          ],
                        ),
                        CommonComponents().printText(
                            fontSize: 15,
                            textData: _cityToCityTripController
                                .tripList[index].userPrice!,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.radio_button_checked,
                            color: ColorHelper.primaryColor),
                        title: CommonComponents().printText(
                            fontSize: 12,
                            textData:
                                '${_cityToCityTripController.tripList[index].cityFrom!}',
                            fontWeight: FontWeight.normal)),
                    ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.radio_button_checked,
                            color: ColorHelper.blueColor),
                        title: CommonComponents().printText(
                            fontSize: 12,
                            textData:
                                '${_cityToCityTripController.tripList[index].cityTo!}',
                            fontWeight: FontWeight.normal)),
                    _buildOfferYourFareView(index: index),
                    SpaceHelper.verticalSpace10,
                    _buildActionView()
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SpaceHelper.verticalSpace5;
          },
          itemCount: _cityToCityTripController.tripList.length),
    );
  }

  Widget _buildActionView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
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
        Container(
          height: 30.h,
          width: 100.w,
          decoration: BoxDecoration(
            color: ColorHelper.primaryColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: CommonComponents().printText(
                fontSize: 14,
                textData: 'Acecpt',
                fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferYourFareView({required int index}) {
    return Row(
      children: [
        Expanded(
          child: _buildTexfiledView(
            _cityToCityTripController.driverOfferYourFareController[index],
            'Offer your fare',
            Icon(
              Icons.payment,
              color: Colors.grey,
            ),
          ),
        ),
        SpaceHelper.horizontalSpace10,
        InkWell(
          onTap: () {
            _cityToCityTripController.selectedTripIndex.value = index;
            _cityToCityTripController.sendDriverFareOffer();
          },
          child: Container(
            height: 47.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: ColorHelper.blueColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: CommonComponents().printText(
                  fontSize: 14,
                  textData: 'Send',
                  fontWeight: FontWeight.normal),
            ),
          ),
        )
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
        textData: "City to City Requests",
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
