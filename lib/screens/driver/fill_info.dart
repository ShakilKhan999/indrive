
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';

class DriverInfoPage extends StatelessWidget {
  const DriverInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0.9),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            title: Title(
              color: Colors.white,
              child: CommonComponents().printText(fontSize: 20, textData: "Registration", fontWeight: FontWeight.bold),),
          actions: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: InkWell(
                onTap: (){
                  Get.back();
                        },
                child: CommonComponents().printText(fontSize: 18, textData: "Close", fontWeight: FontWeight.normal)),
              ),
          ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _buildSelectionView(context),
                SpaceHelper.verticalSpace10,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: CommonComponents().commonButton(text: "Done", onPressed: (){}, disabled: true),
                )
              ],
            ),
          ),
        ));
  }
  
  Widget _buildSelectionView(BuildContext context){
    return Card(
      color: Colors.white,
      elevation: 0.5,
      child: SizedBox(
        height: 300.h,
        width:MediaQuery.of(context).size.width-30.w,
        child: Column(
          children: [
            textIconRow(text: "Basic Info"),
            const Divider(),
            textIconRow(text: "Driver Licence"),
            const Divider(),
            textIconRow(text: "ID Confirmation"),
            const Divider(),
            textIconRow(text: "National Identity Card or Birth Certificate"),
            const Divider(),
            textIconRow(text: "Vehicle Info"),
            const Divider(),
            textIconRow(text: "Agent Referral Code"),
          ],
        ),
      ),
    );
  }
  
  Widget textIconRow({required String text}){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonComponents().printText(color:Colors.black,fontSize: 15, textData: text, fontWeight: FontWeight.bold),
          Icon(Icons.arrow_forward_ios,size: 20.sp,color: ColorHelper.blueColor,)
        ],
      ),
    );
  }

}
