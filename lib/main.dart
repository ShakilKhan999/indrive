import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/screens/auth_screen/views/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:callandgo/utils/app_config.dart';
import 'package:callandgo/utils/navigation_service.dart';
import 'service/background_service.dart';
import 'utils/firebase_option.dart';

FToast fToast = FToast();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await BackgroundService.initializeService();
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
          colorScheme:
              ColorScheme.fromSeed(seedColor: ColorHelper.primaryColor),
          useMaterial3: true,
        ),
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
