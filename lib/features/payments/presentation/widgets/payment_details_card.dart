import 'package:flutter/material.dart';
import '../../data/models/payment_model.dart';

/// Payment details card showing amounts and deadline
/// This displays the core payment information in a clean, organized way
class PaymentDetailsCard extends StatelessWidget {
  final PaymentDetails paymentDetails;
  final String Function(double) formatCurrency;

  const PaymentDetailsCard({
    Key? key,
    required this.paymentDetails,
    required this.formatCurrency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          const Text(
            'Détails de paiement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Payment amounts row
          Row(
            children: [
              // Amount to pay section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Montant à payer',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatCurrency(paymentDetails.amountToPay),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Amount deposited section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Montant déposé',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatCurrency(paymentDetails.amountDeposited),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Payment deadline
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Délai de paiement',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                paymentDetails.paymentDeadline,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _getDeadlineColor(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get color for deadline text based on urgency
  /// This provides visual feedback about payment urgency
  Color _getDeadlineColor() {
    try {
      final deadline = DateTime.parse(paymentDetails.paymentDeadline);
      final now = DateTime.now();
      final daysUntilDeadline = deadline.difference(now).inDays;
      
      if (daysUntilDeadline < 0) {
        return Colors.red; // Overdue
      } else if (daysUntilDeadline < 7) {
        return Colors.orange; // Due soon
      } else {
        return Colors.black87; // Normal
      }
    } catch (e) {
      return Colors.black87; // Default color if date parsing fails
    }
  }
}
