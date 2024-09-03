import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/simple_appbar.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/city_to_city_user/controller/city_to_city_trip_controller.dart';
import '../../../components/common_components.dart';
import '../../../models/city_to_city_trip_model.dart';

class BidList extends StatelessWidget {
  BidList({super.key});

  final CityToCityTripController _cityToCityTripController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.bgColor,
      appBar: SimpleAppbar(titleText: 'Bid List'),
      body: Obx(
        () => _buildBodyView(),
      ),
    );
  }

  Widget _buildBodyView() {
    List<Bids> bids = _cityToCityTripController
        .tripListForUser[
            _cityToCityTripController.selectedTripIndexForUser.value]
        .bids!;
    return ListView.separated(
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
                              child: bids[index].driverImage != null
                                  ? Image.network(
                                      bids[index].driverImage!,
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
                              textData: bids[index].driverName!,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      CommonComponents().printText(
                          fontSize: 15,
                          textData: bids[index].driverPrice!,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                  SpaceHelper.verticalSpace10,
                  CommonComponents().printText(
                      fontSize: 15,
                      textData: 'Vehicle Type : ${bids[index].driverVehicle}',
                      fontWeight: FontWeight.normal),
                  SpaceHelper.verticalSpace10,
                  _buildActionView(index: index),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SpaceHelper.verticalSpace10,
        itemCount: bids.length);
  }

  Widget _buildActionView({required int index}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            _cityToCityTripController.selectedBidIndex.value = index;
            _cityToCityTripController.declineBidForUser();
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
            _cityToCityTripController.selectedBidIndex.value = index;
            _cityToCityTripController.acceptRideForUser();
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
}
