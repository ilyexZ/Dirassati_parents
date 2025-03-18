import 'package:dirassati/main_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './core/services/shared_prefernces_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final sharedPrefsService = SharedPreferencesService();
  final seenOnboarding = await sharedPrefsService.getSeenOnboarding()&&false;

  runApp( MainWidget(seenOnboarding: seenOnboarding));
}

