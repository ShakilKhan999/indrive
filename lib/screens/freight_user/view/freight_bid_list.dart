import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import '../../../components/common_components.dart';
import '../../../models/freight_trip_model.dart';
import '../controller/freight_trip_controller.dart';

class FreightBidList extends StatelessWidget {
  FreightBidList({super.key});

  final FreightTripController _freightTripController = Get.find();

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
    List<Bids> bids = _freightTripController
        .tripListForUser[_freightTripController.selectedTripIndexForUser.value]
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
                            Expanded(
                              child: CommonComponents().printText(
                                  fontSize: 15,
                                  textData: bids[index].driverName!,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      SpaceHelper.horizontalSpace10,
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
            _freightTripController.selectedBidIndex.value = index;
            _freightTripController.declineBidForUser();
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
            _freightTripController.selectedBidIndex.value = index;
            _freightTripController.acceptRideForUser();
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
