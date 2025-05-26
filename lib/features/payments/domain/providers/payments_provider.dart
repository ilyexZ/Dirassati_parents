import 'package:dirassati/core/core_providers.dart';
import 'package:dirassati/core/auth_info_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/payments_remote_data_source.dart';
import '../../data/repositories/payments_repository.dart';
import '../../data/models/payment_model.dart';

/// Provider for the remote data source
/// This follows the exact same pattern as your students and absences providers
/// Using the same dependency injection approach for consistency
final paymentsRemoteDataSourceProvider = Provider<PaymentsRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return PaymentsRemoteDataSource(dio: dio, storage: storage);
});

/// Provider for the repository
/// This wraps the remote data source and provides business logic methods
/// Following your established architecture pattern
final paymentsRepositoryProvider = Provider<PaymentsRepository>((ref) {
  final remoteDataSource = ref.watch(paymentsRemoteDataSourceProvider);
  return PaymentsRepository(remoteDataSource);
});

/// Main provider to fetch complete payment information for a specific student
/// This uses FutureProvider.family just like your notes and absences providers
/// The family parameter allows passing the student ID as an argument
final paymentInfoProvider = FutureProvider.family<PaymentInfo, String>((ref, studentId) async {
  final storage = ref.watch(secureStorageProvider);
  final repository = ref.watch(paymentsRepositoryProvider);
  
  // Check for debug token
  final token = await storage.read(key: 'auth_token');
  if (token == PaymentsRemoteDataSource.debugToken) {
    // Return static debug data directly
    return _getStaticDebugPaymentInfo(studentId);
  }
  
  // Normal API call flow
  return repository.getPaymentInfo(studentId);
});

/// Static debug data generator
PaymentInfo _getStaticDebugPaymentInfo(String studentId) {
  return PaymentInfo(
    paymentDetails: PaymentDetails(
      studentName: "Debug Student",
      studentLevel: "Debug Class",
      studentImageUrl: "https://via.placeholder.com/150",
      amountToPay: 100000.0,
      amountDeposited: 50000.0,
      paymentDeadline: "2025-12-31",
      studentId: studentId,
    ),
    wireTransfers: [
      WireTransfer(
        senderRip: "DEBUG_RIP_123456",
        receiverRip: "SCHOOL_RIP_789012",
        expeditionDate: "01 Janvier 2025 - 10:00 Am",
        amount: 50000.0,
        transferId: "debug_transfer_1",
      )
    ],
  );
}


/// Provider to fetch only payment details (without wire transfers)
/// This is useful for displaying just the payment summary information
/// without loading the full transfer history when not needed
final paymentDetailsProvider = FutureProvider.family<PaymentDetails, String>((ref, studentId) async {
  final storage = ref.watch(secureStorageProvider);
  final repository = ref.watch(paymentsRepositoryProvider);

  if (await storage.read(key: 'auth_token') == PaymentsRemoteDataSource.debugToken) {
    return _getStaticDebugPaymentInfo(studentId).paymentDetails;
  }
  return repository.getPaymentDetails(studentId);
});

/// Provider to fetch only wire transfer history for a student
/// This separates concerns and allows you to load transfers independently
/// following the single responsibility principle
final wireTransfersProvider = FutureProvider.family<List<WireTransfer>, String>((ref, studentId) async {
  final storage = ref.watch(secureStorageProvider);
  final repository = ref.watch(paymentsRepositoryProvider);

  if (await storage.read(key: 'auth_token') == PaymentsRemoteDataSource.debugToken) {
    return _getStaticDebugPaymentInfo(studentId).wireTransfers;
  }
  return repository.getWireTransfers(studentId);
});

/// State provider for tracking the currently selected student
/// This helps manage which student's payment info is being displayed
/// You can update this when user navigates from the students list
final selectedStudentIdProvider = StateProvider<String?>((ref) => null);

/// Provider that combines selected student with payment info
/// This gives you reactive payment data for the currently selected student
/// Returns null if no student is selected
final currentStudentPaymentProvider = Provider<AsyncValue<PaymentInfo>?>((ref) {
  final selectedStudentId = ref.watch(selectedStudentIdProvider);
  if (selectedStudentId == null) return null;
  
  return ref.watch(paymentInfoProvider(selectedStudentId));
});

/// State notifier for managing payment submission state
/// This handles the state during payment processing (loading, success, error)
final paymentSubmissionProvider = StateNotifierProvider<PaymentSubmissionNotifier, PaymentSubmissionState>((ref) {
  final repository = ref.read(paymentsRepositoryProvider);
  return PaymentSubmissionNotifier(repository);
});

/// States for payment submission process
/// This enum helps track the different states during payment processing
enum PaymentSubmissionStatus { idle, loading, success, error }

class PaymentSubmissionState {
  final PaymentSubmissionStatus status;
  final String? errorMessage;
  final bool isSubmitting;

  PaymentSubmissionState({
    required this.status,
    this.errorMessage,
    required this.isSubmitting,
  });

  PaymentSubmissionState.idle() : 
    status = PaymentSubmissionStatus.idle,
    errorMessage = null,
    isSubmitting = false;

  PaymentSubmissionState.loading() : 
    status = PaymentSubmissionStatus.loading,
    errorMessage = null,
    isSubmitting = true;

  PaymentSubmissionState.success() : 
    status = PaymentSubmissionStatus.success,
    errorMessage = null,
    isSubmitting = false;

  PaymentSubmissionState.error(String message) : 
    status = PaymentSubmissionStatus.error,
    errorMessage = message,
    isSubmitting = false;
}

/// State notifier for handling payment submissions
/// This manages the async process of submitting payments
/// and provides reactive state updates to the UI
class PaymentSubmissionNotifier extends StateNotifier<PaymentSubmissionState> {
  final PaymentsRepository _repository;

  PaymentSubmissionNotifier(this._repository) : super(PaymentSubmissionState.idle());

  /// Submit a new payment with the provided details
  /// This method handles all the async logic and state management
  /// for the payment submission process
  Future<void> submitPayment({
    required String studentId,
    required String senderRip,
    required double amount,
    required String expeditionDate,
  }) async {
    // Set loading state to show progress indicator
    state = PaymentSubmissionState.loading();

    try {
      // Attempt to submit the payment through the repository
      final success = await _repository.submitPayment(
        studentId: studentId,
        senderRip: senderRip,
        amount: amount,
        expeditionDate: expeditionDate,
      );

      if (success) {
        // Payment was successful
        state = PaymentSubmissionState.success();
      } else {
        // Payment failed for business logic reasons
        state = PaymentSubmissionState.error("Payment submission failed");
      }
    } catch (e) {
      // Handle any exceptions during payment processing
      state = PaymentSubmissionState.error(e.toString());
    }
  }

  /// Reset the submission state back to idle
  /// Call this when navigating away or starting a new payment
  void resetState() {
    state = PaymentSubmissionState.idle();
  }
}

/// Provider for formatting currency amounts
/// This helps maintain consistent currency formatting across the app
/// following your existing theming patterns
final currencyFormatterProvider = Provider<String Function(double)>((ref) {
  return (double amount) {
    // Format amount with space as thousand separator and "DA" suffix
    // This matches the format shown in your screenshot
    final formatted = amount.toStringAsFixed(0);
    final parts = <String>[];
    
    // Add thousand separators (spaces) - this follows Algerian number formatting
    for (int i = formatted.length; i > 0; i -= 3) {
      final start = i - 3 < 0 ? 0 : i - 3;
      parts.insert(0, formatted.substring(start, i));
    }
    
    return '${parts.join(' ')} DA';
  };
});

/// Provider for date formatting
/// This ensures consistent date formatting throughout the payment features
/// matching the format shown in your wire transfer dates
final paymentDateFormatterProvider = Provider<String Function(DateTime)>((ref) {
  return (DateTime date) {
    // Format: "25 Janvier 2025 - 9:12 Am"
    final months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'Pm' : 'Am';
    
    return '$day $month $year - $hour:$minute $period';
  };
});