import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dirassati/core/shared_constants.dart';
import 'package:dirassati/main_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import './core/services/shared_prefernces_service.dart';

late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences and check onboarding status
  final sharedPrefsService = SharedPreferencesService();
  final seenOnboarding = await sharedPrefsService.getSeenOnboarding() && false;

  // Initialize backend
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

  // Initialize local notifications
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create a ProviderContainer
  final container = ProviderContainer();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await initializeDateFormatting('fr_FR', null);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  
  const MyApp({Key? key, required this.seenOnboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MainWidget(seenOnboarding: seenOnboarding),
    );
  }
}