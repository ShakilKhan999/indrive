import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/driver/courier/controller/courier_controller.dart';

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
                _courierController.toCourierController.value,
                'To',
                Icon(
                  Icons.search,
                  color: Colors.grey,
                )),
            SpaceHelper.verticalSpace15,
            _buildOptionButton(Icons.door_front_door, 'Door to door'),
            _buildTexfiledView(
                _courierController.toCourierController.value,
                'Order Deatils',
                Icon(
                  Icons.details,
                  color: Colors.grey,
                )),
            SpaceHelper.verticalSpace10,
            _buildTexfiledView(
                _courierController.fareCourierController.value,
                'Offer your fare',
                Icon(
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

  Widget _buildOptionButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 16),
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
