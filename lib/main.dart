import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dirassati/core/services/notification_service.dart';
import 'package:dirassati/features/auth/presentation/pages/login_page.dart';
import 'package:dirassati/features/notifications/presentation/pages/notifications_page.dart';
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
  
  // Initialize notification service
  final notificationService = container.read(notificationServiceProvider);
  await notificationService.initialize();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await initializeDateFormatting('fr_FR', null);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MainWidget(seenOnboarding: seenOnboarding),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dirassati',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/notifications': (context) => const NotificationsPage(),
      },
    );
  }
}