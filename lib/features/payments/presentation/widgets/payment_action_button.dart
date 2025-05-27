import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/payments_provider.dart';
import '../../data/services/payment_api_service.dart';

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

    // Listen to submission state changes to handle success and errors
    ref.listen<PaymentSubmissionState>(paymentSubmissionProvider, (previous, next) {
      if (previous?.status != next.status) {
        switch (next.status) {
          case PaymentSubmissionStatus.success:
            if (next.checkoutUrl != null && next.checkoutUrl!.isNotEmpty) {
              print('✅ Payment initiated successfully, launching URL: ${next.checkoutUrl}');
              _launchCheckoutUrl(context, next.checkoutUrl!);
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Redirecting to payment page...'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              
              // Call success callback if provided
              if (onPaymentSuccess != null) {
                onPaymentSuccess!();
              }
            }
            break;
            
          case PaymentSubmissionStatus.error:
            if (next.errorMessage != null) {
              _showErrorDialog(context, next.errorMessage!);
            }
            break;
            
          default:
            break;
        }
      }
    });

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: submissionState.isSubmitting 
            ? null 
            : () => _initiatePayment(context, ref),
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

  /// Initiate payment process by calling the API
  Future<void> _initiatePayment(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(paymentSubmissionProvider.notifier);
    
    try {
      // Set loading state
      notifier.setLoading();
      
      print('🚀 Initiating payment for student: $studentId');
      
      // Call the payment initiation API
      final response = await PaymentApiService.initiatePayment(studentId);
      
      print('✅ Payment initiation successful');
      print('🔗 Checkout URL: ${response.checkoutUrl}');
      print('🆔 Checkout ID: ${response.checkoutId}');
      
      // Validate the response
      if (response.checkoutUrl.isEmpty) {
        throw Exception('Empty checkout URL received from server');
      }
      
      // Set success state with checkout details
      notifier.setSuccess(
        checkoutUrl: response.checkoutUrl,
        checkoutId: response.checkoutId,
      );
      
    } catch (e) {
      print('❌ Payment initiation failed: $e');
      notifier.setError(e.toString());
    }
  }

  /// Launch the checkout URL in browser or webview
  Future<void> _launchCheckoutUrl(BuildContext context, String checkoutUrl) async {
    try {
      print('🌐 Attempting to launch URL: $checkoutUrl');
      
      // Validate URL format
      if (!checkoutUrl.startsWith('http://') && !checkoutUrl.startsWith('https://')) {
        throw Exception('Invalid URL format: $checkoutUrl');
      }
      
      final Uri url = Uri.parse(checkoutUrl);
      print('📎 Parsed URI: $url');
      
      // Check if the URL can be launched
     
      
      if (true) {
        final bool launched = await launchUrl(
          url,
          mode: LaunchMode.externalApplication, // Opens in external browser
        );
        
        if (launched) {
          print('✅ Successfully launched checkout URL');
        } else {
          print('❌ Failed to launch URL even though canLaunchUrl returned true');
          throw Exception('Failed to launch checkout URL');
        }
      } else {
        print('❌ Cannot launch URL: $checkoutUrl');
        throw Exception('Cannot launch checkout URL');
      }
    } catch (e) {
      print('❌ Failed to launch checkout URL: $e');
      if (context.mounted) {
        _showErrorDialog(
          context, 
          'Unable to open payment page. Please try again.\n\nError: ${e.toString()}'
        );
      }
    }
  }

  /// Show error dialog to user
  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur de paiement'),
          content: SingleChildScrollView(
            child: Text(
              'Une erreur est survenue:\n\n$error',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}