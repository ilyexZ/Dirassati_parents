import 'package:dirassati/features/payments/domain/providers/payments_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/payments_provider.dart';
import '../widgets/payment_header_widget.dart';
import '../widgets/payment_details_card.dart';
import '../widgets/wire_transfers_list.dart';
import '../widgets/payment_action_button.dart';

/// Payment Details Page - Main screen for displaying student payment information
/// This page follows your existing architectural patterns and integrates seamlessly
/// with your Riverpod state management approach throughout the app
class PaymentDetailsPage extends ConsumerWidget {
  final String studentId;

  const PaymentDetailsPage({
    Key? key,
    required this.studentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the payment info provider for reactive updates
    // This will automatically rebuild when data changes or updates
    final paymentInfoAsync = ref.watch(paymentInfoProvider(studentId));
    
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
      body: paymentInfoAsync.when(
        // Loading state - show centered progress indicator
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
        ),
        
        // Error state - show user-friendly error message with retry option
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'Erreur lors du chargement',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Impossible de charger les informations de paiement :${error}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Refresh the provider to retry loading
                  ref.refresh(paymentInfoProvider(studentId));
                },
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
        ),
        
        // Success state - display the payment information
        data: (paymentInfo) => CustomScrollView(
          slivers: [
            // Student header section with avatar and basic info
            SliverToBoxAdapter(
              child: PaymentHeaderWidget(
                paymentDetails: paymentInfo.paymentDetails,
              ),
            ),
            
            // Payment details card showing amounts and deadline
            SliverToBoxAdapter(
              child: PaymentDetailsCard(
                paymentDetails: paymentInfo.paymentDetails,
                formatCurrency: formatCurrency,
              ),
            ),
            
            // Wire transfers list showing payment history
            SliverToBoxAdapter(
              child: WireTransfersList(
                wireTransfers: paymentInfo.wireTransfers,
                formatCurrency: formatCurrency,
              ),
            ),
            
            // Add some bottom padding before the floating action button
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
      
      // Floating action button for making payments
      // This follows Material Design guidelines and your app's styling
      floatingActionButton: PaymentActionButton(
        studentId: studentId,
        onPaymentSuccess: () {
          // Refresh payment data after successful payment
          ref.refresh(paymentInfoProvider(studentId));
          
          // Show success message to user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Paiement effectué avec succès!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}