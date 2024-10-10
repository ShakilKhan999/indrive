import 'dart:async';

import 'package:callandgo/helpers/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/models/trip_model.dart';
import 'package:callandgo/screens/home/controller/home_controller.dart';

class BidItem extends StatefulWidget {
  final Bid bid;
  final DateTime startTime;
  final VoidCallback onLoadingComplete;

  BidItem({
    required this.bid,
    required this.startTime,
    required this.onLoadingComplete,
  });

  @override
  _BidItemState createState() => _BidItemState();
}

class _BidItemState extends State<BidItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController for 10 seconds duration
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    // Define the animation to reverse the loading
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    // Add listener to the AnimationController
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // When the animation is complete, call the provided callback
        widget.onLoadingComplete();
      }
    });

    // Start the reverse loading from the given startTime
    _startReverseLoading();
  }

  void _startReverseLoading() {
    final DateTime currentTime = DateTime.now();
    final Duration difference = currentTime.difference(widget.startTime);

    if (difference.inSeconds < 10) {
      _controller.forward(from: difference.inSeconds / 10);

      _timer = Timer(
        Duration(seconds: 10 - difference.inSeconds),
        () {
          _controller.reverse(from: 1.0);
        },
      );
    } else {
      _controller.reverse(from: 1.0);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 300.w,
          child: Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Center(
              child: Column(
                children: [
                  SpaceHelper.verticalSpace10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRx1HTyQi9fvuheXOH2an4_ChcBe-PFTVaekg&s"),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              CommonComponents().printText(
                                  fontSize: 13,
                                  textData: widget.bid.driverName.toString(),
                                  fontWeight: FontWeight.bold),
                              SpaceHelper.horizontalSpace10,
                              CommonComponents().printText(
                                  fontSize: 13,
                                  textData:
                                      "Offered: ${widget.bid.offerPrice.toString()}\$",
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                          SpaceHelper.verticalSpace5,
                          Row(
                            children: [
                              CommonComponents().printText(
                                  fontSize: 13,
                                  textData: 'Your offer price: ',
                                  fontWeight: FontWeight.bold),
                              CommonComponents().printText(
                                  fontSize: 13,
                                  textData:
                                      "${widget.bid.offerPrice.toString()}\$",
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                          // SpaceHelper.verticalSpace10,
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                      child: CommonComponents().commonButton(
                        fontSize: 13,
                        paddingVertical: 7,
                        paddingHorizontal: 15,
                        text: "Accept",
                        onPressed: () async {
                          homeController.acceptBid(
                              driverId: widget.bid.driverId!,
                              rent: widget.bid.offerPrice!.toInt());
                        },
                        color: ColorHelper.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _animation.value,
                  backgroundColor: Colors.transparent,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ColorHelper.primaryColor),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
