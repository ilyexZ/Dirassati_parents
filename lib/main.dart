import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import './core/services/shared_prefernces_service.dart';
import 'features/auth/presentation/pages/auth_wrapper.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final sharedPrefsService = SharedPreferencesService();
  final seenOnboarding = false;//await sharedPrefsService.getSeenOnboarding();

  runApp(ProviderScope(child: MainApp(seenOnboarding: seenOnboarding)));
}

class MainApp extends StatelessWidget {
  final bool seenOnboarding;
  const MainApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      // Show onboarding page if it hasn't been seen; otherwise, show AuthWrapper.
      home: seenOnboarding ? const AuthWrapper() : const OnboardingPage(),
    );
  }
}
