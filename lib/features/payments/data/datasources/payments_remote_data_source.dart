// ./lib/features/payments/data/datasources/payments_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:dirassati/core/services/colorLog.dart';
import 'package:dirassati/core/shared_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/payment_model.dart';

class PaymentsRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;

  // Debug token for testing - this should match what you use for login
  static const String debugToken = "debug_dummy_token";

  String get backendUrl => BackendProvider.backendProviderIp;

  PaymentsRemoteDataSource({
    required this.dio,
    required this.storage,
  });

  /// Fetch payment bills for a specific student
  Future<List<PaymentDetails>> fetchPaymentBills(String studentId) async {
    final token = await storage.read(key: 'auth_token');

    print('🔍 PaymentsRemoteDataSource: Token = $token');
    print('🔍 PaymentsRemoteDataSource: Debug token = $debugToken');
    print('🔍 PaymentsRemoteDataSource: Are they equal? ${token == debugToken}');

    // Debug mode check - this should NOT happen here if we're handling it in the provider
    if (token == debugToken) {
      print('⚠️ PaymentsRemoteDataSource: Debug mode detected - this should be handled in provider!');
      throw Exception('Debug mode should be handled in provider layer');
    }

    if (token == null) {
      throw Exception("No authentication token found");
    }

    try {
      print('🌐 PaymentsRemoteDataSource: Making API call to https://$backendUrl/api/Payments/student/$studentId/bills');
      clog("g", "$token");
      
      final response = await dio.get(
        'https://$backendUrl/api/Payments/student/$studentId/bills',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'ngrok-skip-browser-warning': 'true', // Add this header for ngrok
          },
        ),
      );

      print('📡 PaymentsRemoteDataSource: Response status: ${response.statusCode}');
      print('📡 PaymentsRemoteDataSource: Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('✅ PaymentsRemoteDataSource: Success - parsing response');
        
        // The API returns an array of payment details
        final List<dynamic> billsJson = response.data as List<dynamic>;
        
        return billsJson.map((billJson) => PaymentDetails.fromJson(billJson as Map<String, dynamic>)).toList();
      } else {
        print('❌ PaymentsRemoteDataSource: Error response: ${response.data}');
        throw Exception('Failed to fetch payment bills: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ PaymentsRemoteDataSource: DioException - ${e.message}');

      // Add this to print the response body from server
      if (e.response != null) {
        print('📩 Error response status: ${e.response?.statusCode}');
        print('📩 Error response body: ${e.response?.data}');
      }

      throw Exception('Network error: ${e.message}');
    }
  }

  /// Submit a new payment/wire transfer
  Future<bool> submitPayment({
    required String studentId,
    required String billId,
    required String senderRip,
    required double amount,
    required String expeditionDate,
  }) async {
    final token = await storage.read(key: 'auth_token');

    if (token == debugToken) {
      // In debug mode, simulate successful payment
      print('🐛 PaymentsRemoteDataSource: Simulating payment submission in debug mode');
      await Future.delayed(const Duration(seconds: 2));
      return true;
    }

    if (token == null) {
      throw Exception("No authentication token found");
    }

    try {
      print('🌐 PaymentsRemoteDataSource: Submitting payment for bill $billId');
      
      final response = await dio.post(
        'https://$backendUrl/api/payments/submit',
        data: {
          'studentId': studentId,
          'billId': billId,
          'senderRip': senderRip,
          'amount': amount,
          'expeditionDate': expeditionDate,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      );

      print('📡 PaymentsRemoteDataSource: Payment submission response: ${response.statusCode}');
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('❌ PaymentsRemoteDataSource: Payment submission failed - ${e.message}');
      throw Exception('Payment submission failed: ${e.message}');
    }
  }
}