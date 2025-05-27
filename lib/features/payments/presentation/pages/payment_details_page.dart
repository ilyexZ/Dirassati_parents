// ./lib/features/payments/presentation/pages/payment_details_page.dart

import 'package:dirassati/features/payments/data/models/payment_model.dart';
import 'package:dirassati/features/payments/domain/providers/payments_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/payments_provider.dart';
import '../widgets/payment_bill_card.dart';
import '../widgets/payment_action_button.dart';

/// Payment Details Page - Main screen for displaying student payment bills
class PaymentDetailsPage extends ConsumerWidget {
  final String studentId;

  const PaymentDetailsPage({
    Key? key,
    required this.studentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the payment bills provider for reactive updates
    final paymentBillsAsync = ref.watch(paymentBillsProvider(studentId));

    // Watch currency formatter for consistent number formatting
    final formatCurrency = ref.watch(currencyFormatterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Light background matching your design
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
        centerTitle: false,
      ),
      body: paymentBillsAsync.when(
        // Loading state - show centered progress indicator
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
        ),

        // Error state - show user-friendly error message with retry option
        error: (error, stack) {
          // Check if it's a 404 error
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
                  isNotFound ? 'Aucun paiement trouvé' : 'Erreur lors du chargement',
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
                  onPressed: () => ref.refresh(paymentBillsProvider(studentId)),
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

        // Success state - display the payment bills
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

          return CustomScrollView(
            slivers: [
              // Header section
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

              // Payment bills list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final bill = paymentBills[index];
                    return PaymentBillCard(
                      paymentDetails: bill,
                      formatCurrency: formatCurrency,
                      onPayPressed: () {},//TODO CHARGILI,
                    );
                  },
                  childCount: paymentBills.length,
                ),
              ),

              // Add some bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Show payment form dialog for a specific bill
  
}