import 'package:dirassati/core/shared_constants.dart';
import 'package:dirassati/main_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './core/services/shared_prefernces_service.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  await BackendProvider.init(); 

// Android initialization
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS initialization (if needed)
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final sharedPrefsService = SharedPreferencesService();
  final seenOnboarding = await sharedPrefsService.getSeenOnboarding()&&false;

  runApp( MainWidget(seenOnboarding: seenOnboarding));
}

