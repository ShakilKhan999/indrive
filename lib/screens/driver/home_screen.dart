import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorHelper.lightGreyColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpaceHelper.verticalSpace35,
             _buildTopCardView(),
              SpaceHelper.verticalSpace35,
             _buildSelectionView()
      
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopCardView(){
    return  Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorHelper.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonComponents().printText(fontSize: 18, textData: 'Get income with us', fontWeight: FontWeight.bold),
                SpaceHelper.horizontalSpace5,
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SpaceHelper.horizontalSpace5,
                    CommonComponents().printText(fontSize: 15, textData: 'Flexible hours', fontWeight: FontWeight.normal),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SpaceHelper.horizontalSpace5,
                    CommonComponents().printText(fontSize: 15, textData: 'Your prices', fontWeight: FontWeight.normal),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SpaceHelper.horizontalSpace5,
                    CommonComponents().printText(fontSize: 15, textData: 'Low service payments',fontWeight: FontWeight.normal),

                  ],
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/your_image.png', // Replace with your asset
            width: 80,
            height: 80,
          ),
        ],
      ),
    );
  }
  Widget _buildSelectionView(){
    return  Container(
      child: ListTile(
        leading: SizedBox(
            height: 40.h,width: 50.h,
            child: Image.asset("assets/images/car.png")),
        title:  CommonComponents().printText(fontSize: 18, textData: "Car", fontWeight: FontWeight.bold),
        trailing: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 25.sp,),
      ),
    );
  }
}
