export '../../domain/providers/payments_provider.dart';

// You can also add any presentation-specific providers here if needed
// For example, UI state providers, form providers, etc.

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing payment form state
/// This can be used across different payment forms to maintain consistency
final paymentFormStateProvider = StateProvider.autoDispose<PaymentFormState>((ref) {
  return PaymentFormState.initial();
});

class PaymentFormState {
  final String ripNumber;
  final String amount;
  final bool isValid;
  final String? errorMessage;

  PaymentFormState({
    required this.ripNumber,
    required this.amount,
    required this.isValid,
    this.errorMessage,
  });

  PaymentFormState.initial()
      : ripNumber = '',
        amount = '',
        isValid = false,
        errorMessage = null;

  PaymentFormState copyWith({
    String? ripNumber,
    String? amount,
    bool? isValid,
    String? errorMessage,
  }) {
    return PaymentFormState(
      ripNumber: ripNumber ?? this.ripNumber,
      amount: amount ?? this.amount,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage,
    );
  }
}

/// Provider for managing payment navigation state
/// This helps track which student's payment details are being viewed
final paymentNavigationProvider = StateProvider<PaymentNavigationState>((ref) {
  return PaymentNavigationState.initial();
});

class PaymentNavigationState {
  final String? currentStudentId;
  final String? previousRoute;
  final Map<String, dynamic>? navigationArgs;

  PaymentNavigationState({
    this.currentStudentId,
    this.previousRoute,
    this.navigationArgs,
  });

  PaymentNavigationState.initial()
      : currentStudentId = null,
        previousRoute = null,
        navigationArgs = null;

  PaymentNavigationState copyWith({
    String? currentStudentId,
    String? previousRoute,
    Map<String, dynamic>? navigationArgs,
  }) {
    return PaymentNavigationState(
      currentStudentId: currentStudentId ?? this.currentStudentId,
      previousRoute: previousRoute ?? this.previousRoute,
      navigationArgs: navigationArgs ?? this.navigationArgs,
    );
  }
}