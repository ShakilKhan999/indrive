import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void backgroundMain() {
  // Initialize the background service
  final service = FlutterBackgroundService();

  service.invoke('starting');
}

class BackgroundService {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    // Configure notifications
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'background_service',
      'Background Service',
      description: 'This channel is used for background service notification',
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Configure the background service
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false, // Changed to false so it doesn't start automatically
        isForegroundMode: true,
        notificationChannelId: 'background_service',
        initialNotificationTitle: 'Task Scheduled',
        initialNotificationContent: 'Your task will execute in 1 minute',
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [AndroidForegroundType.dataSync],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false, // Changed to false
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  // This is your method that will be called after 1 minute
  static void yourOneTimeMethod() {
    // Add your code here
    log('Task executed after 1 minute!');
    // Example: Make API calls, update database, etc.
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // Instead of periodic timer, use a one-time delayed execution
    Future.delayed(const Duration(seconds: 5), () async {
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Task Executing",
          content: "Running your scheduled task",
        );
      }

      // Call your method
      yourOneTimeMethod();

      // Update notification if needed
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Task Completed",
          content: "Your scheduled task has been executed",
        );
      }

      // Stop the service after execution
      await Future.delayed(const Duration(
          seconds: 2)); // Small delay to ensure notification is seen
      service.stopSelf();
    });
  }
}
