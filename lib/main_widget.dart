import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/presentation/pages/auth_wrapper.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:dirassati/core/services/notification_service.dart' as notification_service;

class MainWidget extends ConsumerStatefulWidget {
  final bool seenOnboarding;
  
  const MainWidget({super.key, required this.seenOnboarding});

  @override
  ConsumerState<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends ConsumerState<MainWidget> {
  bool _isInitialized = false;
  bool _initializationFailed = false;

  @override
  void initState() {
    super.initState();
    // Initialize notification service after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotificationService();
    });
  }

  Future<void> _initializeNotificationService() async {
    try {
      final notificationService = ref.read(notification_service.notificationServiceProvider);
      await notificationService.initialize();
      print('✅ Notification service initialized successfully');
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('❌ Failed to initialize notification service: $e');
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _initializationFailed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dirassati',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        fontFamily: "Poppins",
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        applyElevationOverlayColor: false,
      ),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: _isInitialized 
        ? (widget.seenOnboarding ? const AuthWrapper() : const OnboardingPage())
        : const _LoadingScreen(),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Initializing app...',
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ),
    );
  }
}