import 'package:dirassati/core/core_providers.dart';
import 'package:dirassati/features/payments/data/datasources/payments_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/payments_repository.dart';
import '../../data/models/payment_model.dart';

/// Provider for the remote data source
final paymentsRemoteDataSourceProvider = Provider<PaymentsRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return PaymentsRemoteDataSource(dio: dio, storage: storage);
});

/// Provider for the repository
final paymentsRepositoryProvider = Provider<PaymentsRepository>((ref) {
  final remoteDataSource = ref.watch(paymentsRemoteDataSourceProvider);
  return PaymentsRepository(remoteDataSource);
});

/// Main provider to fetch payment bills for a specific student
final paymentBillsProvider = FutureProvider.family<List<PaymentDetails>, String>((ref, studentId) async {
  final repository = ref.watch(paymentsRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  
  // Check for debug token first
  final token = await storage.read(key: 'auth_token');
  print('🔍 Debug: Token retrieved: $token');
  
  if (token == PaymentsRemoteDataSource.debugToken) {
    print('🐛 Debug: Using static debug data for student: $studentId');
    // Return static debug data directly
    return [
      PaymentDetails(
        billId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        title: "Frais de scolarité - Semestre 1",
        description: "Paiement des frais de scolarité pour le premier semestre",
        amount: 25000,
        paymentStatus: "Pending",
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      PaymentDetails(
        billId: "4fb85f64-5717-4562-b3fc-2c963f66afa7",
        title: "Frais d'inscription",
        description: "Frais d'inscription annuelle",
        amount: 15000,
        paymentStatus: "Paid",
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];
  }
  
  print('🌐 Debug: Using normal API call for student: $studentId');
  // Normal API call flow
  return repository.getPaymentBills(studentId);
});

/// State provider for tracking the currently selected student
final selectedStudentIdProvider = StateProvider<String?>((ref) => null);

/// Provider that combines selected student with payment bills
final currentStudentPaymentBillsProvider = Provider<AsyncValue<List<PaymentDetails>>?>((ref) {
  final selectedStudentId = ref.watch(selectedStudentIdProvider);
  if (selectedStudentId == null) return null;
  return ref.watch(paymentBillsProvider(selectedStudentId));
});

/// States for payment submission process
enum PaymentSubmissionStatus { idle, loading, success, error }

class PaymentSubmissionState {
  final PaymentSubmissionStatus status;
  final String? errorMessage;
  final bool isSubmitting;
  final String? checkoutUrl;
  final String? checkoutId;

  PaymentSubmissionState({
    required this.status,
    this.errorMessage,
    required this.isSubmitting,
    this.checkoutUrl,
    this.checkoutId,
  });

  PaymentSubmissionState.idle() : 
    status = PaymentSubmissionStatus.idle,
    errorMessage = null,
    isSubmitting = false,
    checkoutUrl = null,
    checkoutId = null;

  PaymentSubmissionState.loading() : 
    status = PaymentSubmissionStatus.loading,
    errorMessage = null,
    isSubmitting = true,
    checkoutUrl = null,
    checkoutId = null;

  PaymentSubmissionState.success({String? checkoutUrl, String? checkoutId}) : 
    status = PaymentSubmissionStatus.success,
    errorMessage = null,
    isSubmitting = false,
    checkoutUrl = checkoutUrl,
    checkoutId = checkoutId;

  PaymentSubmissionState.error(String message) : 
    status = PaymentSubmissionStatus.error,
    errorMessage = message,
    isSubmitting = false,
    checkoutUrl = null,
    checkoutId = null;
}

/// State notifier for handling payment submissions
class PaymentSubmissionNotifier extends StateNotifier<PaymentSubmissionState> {
  final PaymentsRepository _repository;
  
  PaymentSubmissionNotifier(this._repository) : super(PaymentSubmissionState.idle());

  /// Set loading state
  void setLoading() {
    state = PaymentSubmissionState.loading();
  }

  /// Set success state with checkout details
  void setSuccess({String? checkoutUrl, String? checkoutId}) {
    state = PaymentSubmissionState.success(
      checkoutUrl: checkoutUrl,
      checkoutId: checkoutId,
    );
  }

  /// Set error state
  void setError(String message) {
    state = PaymentSubmissionState.error(message);
  }

  /// Submit a new payment with the provided details (legacy method)
  Future<void> submitPayment({
    required String studentId,
    required String billId,
    required String senderRip,
    required double amount,
    required String expeditionDate,
  }) async {
    state = PaymentSubmissionState.loading();
    
    try {
      final success = await _repository.submitPayment(
        studentId: studentId,
        billId: billId,
        senderRip: senderRip,
        amount: amount,
        expeditionDate: expeditionDate,
      );
      
      if (success) {
        state = PaymentSubmissionState.success();
      } else {
        state = PaymentSubmissionState.error("Payment submission failed");
      }
    } catch (e) {
      state = PaymentSubmissionState.error(e.toString());
    }
  }

  /// Reset the submission state back to idle
  void resetState() {
    state = PaymentSubmissionState.idle();
  }
}

/// State notifier provider for payment submissions
final paymentSubmissionProvider = StateNotifierProvider<PaymentSubmissionNotifier, PaymentSubmissionState>((ref) {
  final repository = ref.read(paymentsRepositoryProvider);
  return PaymentSubmissionNotifier(repository);
});

/// Provider for formatting currency amounts
final currencyFormatterProvider = Provider<String Function(double)>((ref) {
  return (double amount) {
    final formatted = amount.toStringAsFixed(0);
    final parts = <String>[];
    
    for (int i = formatted.length; i > 0; i -= 3) {
      final start = i - 3 < 0 ? 0 : i - 3;
      parts.insert(0, formatted.substring(start, i));
    }
    return '${parts.join(' ')} DA';
  };
});

/// Provider for date formatting
final paymentDateFormatterProvider = Provider<String Function(DateTime)>((ref) {
  return (DateTime date) {
    final months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'Pm' : 'Am';
    
    return '$day $month $year - $hour:$minute $period';
  };
});
/// Provider for refreshing payment data
final paymentRefreshProvider = Provider<PaymentRefreshController>((ref) {
  return PaymentRefreshController(ref);
});

/// Controller class for handling payment refresh operations
class PaymentRefreshController {
  final Ref _ref;
  
  PaymentRefreshController(this._ref);

  /// Refresh payment bills for a specific student
  Future<void> refreshPaymentBills(String studentId) async {
    print('🔄 Refreshing payment bills for student: $studentId');
    
    // Invalidate the specific student's payment bills
    _ref.invalidate(paymentBillsProvider(studentId));
    
    // Wait a moment for the provider to refresh
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Refresh payment bills for the currently selected student
  Future<void> refreshCurrentStudentPaymentBills() async {
    final selectedStudentId = _ref.read(selectedStudentIdProvider);
    
    if (selectedStudentId != null) {
      print('🔄 Refreshing payment bills for currently selected student: $selectedStudentId');
      await refreshPaymentBills(selectedStudentId);
    } else {
      print('⚠️ No student selected for refresh');
    }
  }

  /// Refresh all payment-related data
  Future<void> refreshAllPaymentData() async {
    print('🔄 Refreshing all payment data');
    
    // Reset payment submission state
    _ref.read(paymentSubmissionProvider.notifier).resetState();
    
    // Refresh currently selected student's data
    await refreshCurrentStudentPaymentBills();
  }

  /// Force refresh payment bills (ignores cache completely)
  Future<void> forceRefreshPaymentBills(String studentId) async {
    print('🔄 Force refreshing payment bills for student: $studentId');
    
    // Invalidate and refresh
    _ref.invalidate(paymentBillsProvider(studentId));
    
    // Also refresh the repository and data source
    _ref.invalidate(paymentsRepositoryProvider);
    _ref.invalidate(paymentsRemoteDataSourceProvider);
    
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

/// State provider for tracking refresh status
final paymentRefreshStateProvider = StateProvider<PaymentRefreshState>((ref) {
  return PaymentRefreshState.idle();
});

/// Refresh state management
class PaymentRefreshState {
  final bool isRefreshing;
  final DateTime? lastRefreshTime;
  final String? error;

  PaymentRefreshState({
    required this.isRefreshing,
    this.lastRefreshTime,
    this.error,
  });

  PaymentRefreshState.idle()
      : isRefreshing = false,
        lastRefreshTime = null,
        error = null;

  PaymentRefreshState.refreshing()
      : isRefreshing = true,
        lastRefreshTime = null,
        error = null;

  PaymentRefreshState.completed()
      : isRefreshing = false,
        lastRefreshTime = DateTime.now(),
        error = null;

  PaymentRefreshState.error(String errorMessage)
      : isRefreshing = false,
        lastRefreshTime = null,
        error = errorMessage;
}

/// Enhanced refresh controller with state management
final paymentRefreshControllerProvider = StateNotifierProvider<PaymentRefreshStateNotifier, PaymentRefreshState>((ref) {
  return PaymentRefreshStateNotifier(ref);
});

class PaymentRefreshStateNotifier extends StateNotifier<PaymentRefreshState> {
  final Ref _ref;
  
  PaymentRefreshStateNotifier(this._ref) : super(PaymentRefreshState.idle());

  /// Refresh with state management
  Future<void> refreshWithState(String studentId) async {
    if (state.isRefreshing) {
      print('⚠️ Refresh already in progress, skipping...');
      return;
    }

    state = PaymentRefreshState.refreshing();
    
    try {
      print('🔄 Starting refresh for student: $studentId');
      
      // Invalidate the payment bills provider
      _ref.invalidate(paymentBillsProvider(studentId));
      
      // Wait for refresh to complete
      await Future.delayed(const Duration(milliseconds: 500));
      
      state = PaymentRefreshState.completed();
      print('✅ Refresh completed successfully');
      
    } catch (e) {
      print('❌ Refresh failed: $e');
      state = PaymentRefreshState.error(e.toString());
    }
  }

  /// Reset refresh state
  void resetState() {
    state = PaymentRefreshState.idle();
  }
}