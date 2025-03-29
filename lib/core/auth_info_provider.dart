// core/providers/auth_info_provider.dart
import 'package:dirassati/core/services/colorLog.dart';
import 'package:dirassati/features/acceuil/data/datasources/students_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../core/core_providers.dart';

final authInfoProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final storage = ref.read(secureStorageProvider);
  final token = await storage.read(key: 'auth_token');
  if (token==StudentsRemoteDataSource.debugToken) return {'parentId':"debugparentID"};
  if (token == null) throw Exception("No token found");
  final decoded =JwtDecoder.decode(token);
  clog('g','[DEBUG] Decoded token type: ${decoded.runtimeType}');
  clog('g','[DEBUG] Decoded content: $decoded');
  return decoded;
});

 final parentIdProvider = FutureProvider<String>((ref) async {
   final authInfo = await ref.watch(authInfoProvider.future);
   return authInfo['parentId'] ?? '';
 });