import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:indrive/screens/auth_screen/views/register_screen.dart';
import 'package:indrive/screens/city_to_city_user/views/city_to_city_request.dart';
import 'package:indrive/screens/city_to_city_user/views/driver_city_to_city_request_list.dart';
import 'package:indrive/screens/driver/courier/views/courier_screen.dart';
import 'package:indrive/screens/driver/freight/views/freight_screen.dart';
import 'package:indrive/screens/home/views/passenger_home.dart';

import 'package:indrive/utils/app_config.dart';
import 'package:indrive/utils/navigation_service.dart';
import 'utils/firebase_option.dart';

FToast fToast = FToast();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        title: AppConfig.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: PassengerHomeScreen(),
        // home: DriverCategoriesScreen(),
        home: RegisterScreen(),
        builder: (context, child) {
          return Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) {
                  return child!;
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
