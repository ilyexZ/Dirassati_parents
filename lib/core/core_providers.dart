// core/providers/core_providers.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'services/url_launcher_service.dart';

final dioProvider = Provider((ref) => Dio());
final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final urlLauncherProvider = Provider((ref) => UrlLauncherService());
