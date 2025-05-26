import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/payments_provider.dart';

/// Payment form dialog for submitting new payments
/// This provides a user-friendly form for entering payment details
class PaymentFormDialog extends ConsumerStatefulWidget {
  final String studentId;
  final VoidCallback? onSuccess;

  const PaymentFormDialog({
    Key? key,
    required this.studentId,
    this.onSuccess,
  }) : super(key: key);

  @override
  ConsumerState<PaymentFormDialog> createState() => _PaymentFormDialogState();
}

class _PaymentFormDialogState extends ConsumerState<PaymentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _ripController = TextEditingController();
  final _amountController = TextEditingController();
  
  @override
  void dispose() {
    _ripController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submissionState = ref.watch(paymentSubmissionProvider);
    
    // Listen for state changes to handle success/error
    ref.listen(paymentSubmissionProvider, (previous, next) {
      if (next.status == PaymentSubmissionStatus.success) {
        Navigator.of(context).pop();
        widget.onSuccess?.call();
      } else if (next.status == PaymentSubmissionStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Erreur lors du paiement'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return AlertDialog(
      title: const Text(
        'Nouveau paiement',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // RIP number input
            TextFormField(
              controller: _ripController,
              decoration: const InputDecoration(
                labelText: 'RIP de l\'expéditeur',
                hintText: 'Entrez votre numéro RIP',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le numéro RIP est requis';
                }
                if (value.length < 10) {
                  return 'Numéro RIP invalide';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Amount input
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Montant (DA)',
                hintText: 'Entrez le montant',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le montant est requis';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Montant invalide';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: submissionState.isSubmitting 
              ? null 
              : () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: submissionState.isSubmitting 
              ? null 
              : _submitPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
          ),
          child: submissionState.isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Confirmer'),
        ),
      ],
    );
  }

  /// Submit payment with validation
  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final rip = _ripController.text;
      final now = DateTime.now();
      
      ref.read(paymentSubmissionProvider.notifier).submitPayment(
        studentId: widget.studentId,
        senderRip: rip,
        amount: amount,
        expeditionDate: ref.read(paymentDateFormatterProvider)(now),
      );
    }
  }
}