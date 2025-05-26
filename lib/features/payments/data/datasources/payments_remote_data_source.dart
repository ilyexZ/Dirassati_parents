import 'package:dio/dio.dart';
import 'package:dirassati/core/shared_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/payment_model.dart';

class PaymentsRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;
  
  // Debug token for testing - following your pattern from students data source
  static const String debugToken = "debug_payment_token";
   String get backendUrl => BackendProvider.backendProviderIp;

  PaymentsRemoteDataSource({
    required this.dio,
    required this.storage,
  });

  /// Fetch payment information for a specific student
  /// This follows the same pattern as your other remote data sources
  Future<PaymentInfo> fetchPaymentInfo(String studentId) async {
    final token = await storage.read(key: 'auth_token');
    
    // Debug mode check - following your existing pattern
    if (token == debugToken) {
      return _getDebugPaymentInfo(studentId);
    }

    if (token == null) {
      throw Exception("No authentication token found");
    }

    try {
      final response = await dio.get(
        'http://$backendUrl/api/Payments/student/$studentId/bills',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return PaymentInfo.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch payment info: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Submit a new payment/wire transfer
  /// This would be called when user clicks "Effectuer un paiement"
  Future<bool> submitPayment({
    required String studentId,
    required String senderRip,
    required double amount,
    required String expeditionDate,
  }) async {
    final token = await storage.read(key: 'auth_token');
    
    if (token == debugToken) {
      // In debug mode, simulate successful payment
      await Future.delayed(const Duration(seconds: 2));
      return true;
    }

    if (token == null) {
      throw Exception("No authentication token found");
    }

    try {
      final response = await dio.post(
        '/api/payments/submit',
        data: {
          'studentId': studentId,
          'senderRip': senderRip,
          'amount': amount,
          'expeditionDate': expeditionDate,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Payment submission failed: ${e.message}');
    }
  }

  /// Debug data method - simulates API response for testing
  /// This follows the same pattern as your school info debug data
  PaymentInfo _getDebugPaymentInfo(String studentId) {
    return PaymentInfo(
      paymentDetails: PaymentDetails(
        studentName: "Imad mohammed",
        studentLevel: "3 ème année moyenne - m2",
        studentImageUrl: "https://via.placeholder.com/60", // Placeholder image
        amountToPay: 220000.0,
        amountDeposited: 200000.0,
        paymentDeadline: "06-06-2025",
        studentId: studentId,
      ),
      wireTransfers: [
        WireTransfer(
          senderRip: "121212121212121221",
          receiverRip: "121212121212121221",
          expeditionDate: "25 Janvier 2025 - 9:12 Am",
          amount: 120000.0,
          transferId: "transfer_1",
        ),
        // You can add more sample transfers here
      ],
    );
  }
}