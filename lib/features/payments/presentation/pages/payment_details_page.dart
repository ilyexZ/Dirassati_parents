import 'package:dirassati/features/payments/domain/providers/payments_provider.dart';
import 'package:dirassati/features/payments/presentation/widgets/payment_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/payment_bill_card.dart';

/// Payment Details Page - Updated to use the new payment initiation flow
class PaymentDetailsPage extends ConsumerWidget {
  final String studentId;

  const PaymentDetailsPage({
    Key? key,
    required this.studentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentBillsAsync = ref.watch(paymentBillsProvider(studentId));
    final formatCurrency = ref.watch(currencyFormatterProvider);
    final submissionState = ref.watch(paymentSubmissionProvider);

    // Listen to submission state changes
    ref.listen<PaymentSubmissionState>(paymentSubmissionProvider,
        (previous, next) {
      if (previous?.status != next.status) {
        switch (next.status) {
          case PaymentSubmissionStatus.success:
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Payment initiated successfully! Redirecting to payment page...'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );

            // Refresh payment bills after successful initiation
            Future.delayed(const Duration(seconds: 2), () {
              ref.refresh(paymentBillsProvider(studentId));
            });
            break;

          case PaymentSubmissionStatus.error:
            // Error is already handled in the PaymentActionButton
            break;

          default:
            break;
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Paiements',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(paymentRefreshControllerProvider.notifier)
              .refreshWithState(studentId);
        },
        child: paymentBillsAsync.when(
          
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
          ),
          error: (error, stack) {
            final isNotFound = error.toString().contains('404');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isNotFound ? Icons.info_outline : Icons.error_outline,
                    size: 64,
                    color: isNotFound ? Colors.grey : Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isNotFound
                        ? 'Aucun paiement trouvé'
                        : 'Erreur lors du chargement',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aucun paiement trouvé pour cet étudiant.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        ref.refresh(paymentBillsProvider(studentId)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          },
          data: (paymentBills) {
            if (paymentBills.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune facture',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aucune facture de paiement trouvée.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            final hasPending = paymentBills.any(
              (b) => b.paymentStatus.toLowerCase() == 'pending',
            );

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Factures de paiement',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${paymentBills.length} facture(s) trouvée(s)',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final bill = paymentBills[index];
                      return PaymentBillCard(
                        paymentDetails: bill,
                        formatCurrency: formatCurrency,
                        onPayPressed: () {
                          // Individual bill payment can be handled here if needed
                          // For now, we use the main payment button at the bottom
                        },
                      );
                    },
                    childCount: paymentBills.length,
                  ),
                ),
                if (hasPending)
                  SliverToBoxAdapter(
                    child: PaymentActionButton(
                      studentId: studentId,
                      onPaymentSuccess: () {
                        // Optional: Handle successful payment initiation
                        print('✅ Payment initiated for student: $studentId');

                        // Reset the submission state after a delay
                        Future.delayed(const Duration(seconds: 5), () {
                          ref
                              .read(paymentSubmissionProvider.notifier)
                              .resetState();
                        });
                      },
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tous les paiements sont à jour',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
