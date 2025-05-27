import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/payments_provider.dart';

/// Payment action button widget
/// This is the floating action button that triggers the payment process
class PaymentActionButton extends ConsumerWidget {
  final String studentId;
  final VoidCallback? onPaymentSuccess;

  const PaymentActionButton({
    Key? key,
    required this.studentId,
    this.onPaymentSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submissionState = ref.watch(paymentSubmissionProvider);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: submissionState.isSubmitting 
            ? null 
            : () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: submissionState.isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Effectuer un paiement',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  /// Show payment form dialog
  
}