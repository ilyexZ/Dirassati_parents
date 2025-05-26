import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dirassati/core/services/notification_service.dart' as notification_service;
import 'package:dirassati/features/auth/presentation/pages/login_page.dart';
import 'package:dirassati/features/notifications/presentation/pages/notifications_page.dart';
import 'package:dirassati/features/notifications/domain/providers/notification_provider.dart' as notification_provider;
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
  final notificationService = container.read(notification_service.notificationServiceProvider);
  await notificationService.initialize();
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await initializeDateFormatting('fr_FR', null);
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final bool seenOnboarding;
  
  const MyApp({Key? key, required this.seenOnboarding}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize notification service after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifications();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    try {
      // The notification service is already initialized in main()
      // This is just for any additional setup if needed
      debugPrint('Notification service already initialized in main()');
    } catch (e) {
      debugPrint('Error with notification setup: $e');
    }
  }

  // Call this method when user logs in successfully
  Future<void> onUserLoggedIn(String authToken) async {
    try {
      // Connect to SignalR hub for real-time notifications
      final notificationNotifier = ref.read(notification_provider.notificationsProvider.notifier);
      await notificationNotifier.connect(authToken);
      
      debugPrint('Successfully connected to real-time notifications');
    } catch (e) {
      debugPrint('Error connecting to real-time notifications: $e');
      // Handle connection error (maybe show a snackbar to user)
    }
  }

  // Call this method when user logs out
  Future<void> onUserLoggedOut() async {
    try {
      // Disconnect from SignalR hub
      final notificationNotifier = ref.read(notification_provider.notificationsProvider.notifier);
      await notificationNotifier.disconnect();
      
      // Clear all notifications
      notificationNotifier.clearNotifications();
      
      debugPrint('Successfully disconnected from real-time notifications');
    } catch (e) {
      debugPrint('Error disconnecting from real-time notifications: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        // App is in foreground
        debugPrint('App resumed - notifications may be handled differently');
        break;
      case AppLifecycleState.paused:
        // App is in background
        debugPrint('App paused - notifications will show as system notifications');
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        onUserLoggedOut();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch notifications for debugging
    final notifications = ref.watch(notification_provider.notificationsProvider);
    
    // You can use this to show notification count badges, etc.
    debugPrint('Current notification count: ${notifications.length}');
    
    return MaterialApp(
      title: 'Dirassati',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: widget.seenOnboarding ? const LoginPage() : MainWidget(seenOnboarding: widget.seenOnboarding),
      routes: {
        '/login': (context) => const LoginPage(),
        '/notifications': (context) => const NotificationsPage(),
      },
    );
  }
}