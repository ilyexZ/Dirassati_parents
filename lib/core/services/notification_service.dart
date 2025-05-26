// lib/core/services/notification_service.dart
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  static int _notificationId = 0;

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        debugPrint('Notification tapped: ${response.payload}');
        _handleNotificationTap(response);
      },
    );

    // Request notification permissions for Android 13+
    //await _requestPermissions();
  }

  // Future<void> _requestPermissions() async {
  //   final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
  //       _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>();

  //   if (androidImplementation != null) {
  //     await androidImplementation.requestPermission();
  //   }
  // }

  Future<void> showAbsenceNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'absence_channel_id',
        'Absence Notifications',
        channelDescription: 'Notifications for student absences',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        when: null,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation(body),
        category: AndroidNotificationCategory.message,
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
        _getNextNotificationId(),
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      debugPrint('Absence notification shown: $title');
    } catch (e) {
      debugPrint('Error showing absence notification: $e');
    }
  }

  Future<void> showConvocationNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'convocation_channel_id',
        'Convocation Notifications',
        channelDescription: 'Notifications for convocations',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        when: null,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation(body),
        category: AndroidNotificationCategory.reminder,
        color: const Color.fromARGB(255, 255, 0, 0), // Red color for urgent convocations
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
        _getNextNotificationId(),
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      debugPrint('Convocation notification shown: $title');
    } catch (e) {
      debugPrint('Error showing convocation notification: $e');
    }
  }

  Future<void> showGeneralNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = 'general_channel_id',
    String channelName = 'General Notifications',
    String channelDescription = 'General app notifications',
    Importance importance = Importance.defaultImportance,
    Priority priority = Priority.defaultPriority,
  }) async {
    try {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: importance,
        priority: priority,
        showWhen: true,
        when: null,
        icon: '@mipmap/ic_launcher',
        styleInformation: BigTextStyleInformation(body),
      );

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
        _getNextNotificationId(),
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      debugPrint('General notification shown: $title');
    } catch (e) {
      debugPrint('Error showing general notification: $e');
    }
  }

  // Method to cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    debugPrint('All notifications cancelled');
  }

  // Method to cancel a specific notification
  Future<void> cancelNotification(int notificationId) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
    debugPrint('Notification $notificationId cancelled');
  }

  // Get active notifications (Android only)
  Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      final List<ActiveNotification> activeNotifications =
          await _flutterLocalNotificationsPlugin.getActiveNotifications();
      return activeNotifications;
    } catch (e) {
      debugPrint('Error getting active notifications: $e');
      return [];
    }
  }

  void _handleNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped with payload: ${response.payload}');
    
    // Here you can navigate to specific pages based on the payload
    // For example:
    // if (response.payload?.contains('absence') == true) {
    //   // Navigate to notifications page with absence tab
    // } else if (response.payload?.contains('convocation') == true) {
    //   // Navigate to notifications page with convocation tab
    // }
    
    // You might want to use a navigation service or similar here
    // to handle navigation from this service layer
  }

  static int _getNextNotificationId() {
    return ++_notificationId;
  }
}

// Provider for notification service
final notificationServiceProvider = Provider((ref) => NotificationService());