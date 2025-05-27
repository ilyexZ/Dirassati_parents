// ./lib/features/payments/data/repositories/payments_repository.dart

import '../datasources/payments_remote_data_source.dart';
import '../models/payment_model.dart';

class PaymentsRepository {
  final PaymentsRemoteDataSource _remoteDataSource;

  PaymentsRepository(this._remoteDataSource);

  /// Fetch payment bills for a student
  /// Returns a list of PaymentDetails objects
  Future<List<PaymentDetails>> getPaymentBills(String studentId) async {
    return await _remoteDataSource.fetchPaymentBills(studentId);
  }

  /// Submit a new payment for a student
  /// Returns true if successful, throws exception if failed
  Future<bool> submitPayment({
    required String studentId,
    required String billId,
    required String senderRip,
    required double amount,
    required String expeditionDate,
  }) async {
    return await _remoteDataSource.submitPayment(
      studentId: studentId,
      billId: billId,
      senderRip: senderRip,
      amount: amount,
      expeditionDate: expeditionDate,
    );
  }
}