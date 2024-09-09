import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/models/driver_vehicle_status.dart';
import 'package:callandgo/models/user_model.dart';
import 'package:callandgo/screens/profile/repository/profile_repository.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    getUserProfile();
    super.onInit();
  }

  var userData = UserModel().obs;
  var cityRiderStatus = DriverVehicleStatus().obs;
  var courierStatus = DriverVehicleStatus().obs;
  var freightStatus = DriverVehicleStatus().obs;
  var cityToCityStatus = DriverVehicleStatus().obs;
  var isUserDataLoaded = false.obs;

  Future<void> getUserProfile() async {
    try {
      isUserDataLoaded.value = false;
      final documentSnapshot = await ProfileRepository()
          .getUserProfileData(userId: FirebaseAuth.instance.currentUser!.uid);
      if (documentSnapshot != null && documentSnapshot.exists) {
        userData.value =
            UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        getDriverStatus(type: 'cityRider');
        getDriverStatus(type: 'courier');
        getDriverStatus(type: 'freight');
        getDriverStatus(type: 'cityToCity');
        isUserDataLoaded.value = true;
      } else {
        print('User document does not exist');
        isUserDataLoaded.value = true;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      isUserDataLoaded.value = true;
    }
  }

  getDriverStatus({required String type}) {
    if (type == 'cityRider') {
      if (userData.value.isDriver == true) {
        if (userData.value.driverStatus!.toLowerCase() == 'pending') {
          cityRiderStatus.value = DriverVehicleStatus(
              status: 'Verification pending', color: ColorHelper.blueColor);
        }
        if (userData.value.driverStatus!.toLowerCase() == 'approved') {
          cityRiderStatus.value = DriverVehicleStatus(
              status: 'Registration completed', color: ColorHelper.blueColor);
        }
        if (userData.value.driverStatus!.toLowerCase() == 'rejected') {
          cityRiderStatus.value = DriverVehicleStatus(
              status: 'Verification failed', color: ColorHelper.red);
        }
      } else {
        cityRiderStatus.value = DriverVehicleStatus(
            status: 'Not Registered', color: ColorHelper.greyColor);
      }
    } else if (type == 'courier') {
      if (userData.value.isCourier == true) {
        if (userData.value.courierStatus!.toLowerCase() == 'pending') {
          courierStatus.value = DriverVehicleStatus(
              status: 'Verification pending', color: ColorHelper.blueColor);
        }
        if (userData.value.courierStatus!.toLowerCase() == 'approved') {
          courierStatus.value = DriverVehicleStatus(
              status: 'Registration completed', color: ColorHelper.blueColor);
        }
        if (userData.value.courierStatus!.toLowerCase() == 'rejected') {
          courierStatus.value = DriverVehicleStatus(
              status: 'Verification failed', color: ColorHelper.red);
        }
      } else {
        courierStatus.value = DriverVehicleStatus(
            status: 'Not Registered', color: ColorHelper.greyColor);
      }
    } else if (type == 'freight') {
      if (userData.value.isFreight == true) {
        if (userData.value.freightStatus!.toLowerCase() == 'pending') {
          freightStatus.value = DriverVehicleStatus(
              status: 'Verification pending', color: ColorHelper.blueColor);
        }
        if (userData.value.freightStatus!.toLowerCase() == 'approved') {
          freightStatus.value = DriverVehicleStatus(
              status: 'Registration completed', color: ColorHelper.blueColor);
        }
        if (userData.value.freightStatus!.toLowerCase() == 'rejected') {
          freightStatus.value = DriverVehicleStatus(
              status: 'Verification failed', color: ColorHelper.red);
        }
      } else {
        freightStatus.value = DriverVehicleStatus(
            status: 'Not Registered', color: ColorHelper.greyColor);
      }
    } else if (type == 'cityToCity') {
      if (userData.value.isCityToCity == true) {
        if (userData.value.cityToCityStatus!.toLowerCase() == 'pending') {
          cityToCityStatus.value = DriverVehicleStatus(
              status: 'Verification pending', color: ColorHelper.blueColor);
        }
        if (userData.value.cityToCityStatus!.toLowerCase() == 'approved') {
          cityToCityStatus.value = DriverVehicleStatus(
              status: 'Registration completed', color: ColorHelper.blueColor);
        }
        if (userData.value.cityToCityStatus!.toLowerCase() == 'rejected') {
          cityToCityStatus.value = DriverVehicleStatus(
              status: 'Verification failed', color: ColorHelper.red);
        }
      } else {
        cityToCityStatus.value = DriverVehicleStatus(
            status: 'Not Registered', color: ColorHelper.greyColor);
      }
    }
  }

  bool hasUserData() {
    return userData.value.uid != null &&
        userData.value.uid!.isNotEmpty &&
        userData.value.name != null &&
        userData.value.name!.isNotEmpty;
  }
}
