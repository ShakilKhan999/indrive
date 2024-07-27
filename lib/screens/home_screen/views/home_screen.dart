import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indrive/screens/auth_screen/controller/auth_controller.dart';
import 'package:indrive/screens/auth_screen/views/register_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              _authController.googleSignOut();
              Get.offAll(() => RegisterScreen());
            },
            child: const Text('sign out')),
      ),
    );
  }
}
