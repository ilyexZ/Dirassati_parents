import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/presentation/pages/auth_wrapper.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
class MainWidget extends StatelessWidget {
  final bool seenOnboarding;
  const MainWidget({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Dirassati',
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
      ),
    );
  }
}
