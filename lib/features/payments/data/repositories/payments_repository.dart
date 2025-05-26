import '../datasources/payments_remote_data_source.dart';
import '../models/payment_model.dart';

class PaymentsRepository {
  final PaymentsRemoteDataSource _remoteDataSource;

  PaymentsRepository(this._remoteDataSource);

  /// Fetch complete payment information for a student
  /// This includes both payment details and wire transfer history
  Future<PaymentInfo> getPaymentInfo(String studentId) async {
    return await _remoteDataSource.fetchPaymentInfo(studentId);
  }

  /// Submit a new payment for a student
  /// Returns true if successful, throws exception if failed
  Future<bool> submitPayment({
    required String studentId,
    required String senderRip,
    required double amount,
    required String expeditionDate,
  }) async {
    return await _remoteDataSource.submitPayment(
      studentId: studentId,
      senderRip: senderRip,
      amount: amount,
      expeditionDate: expeditionDate,
    );
  }

  /// Get only payment details (without wire transfers)
  /// Useful for summary views or when you don't need full history
  Future<PaymentDetails> getPaymentDetails(String studentId) async {
    final paymentInfo = await _remoteDataSource.fetchPaymentInfo(studentId);
    return paymentInfo.paymentDetails;
  }

  /// Get only wire transfer history for a student
  /// Useful for displaying just the transfer list
  Future<List<WireTransfer>> getWireTransfers(String studentId) async {
    final paymentInfo = await _remoteDataSource.fetchPaymentInfo(studentId);
    return paymentInfo.wireTransfers;
  }
}