import 'package:flutter/material.dart';
import '../../data/models/payment_model.dart';

/// Header widget displaying student information
/// This creates the top section with student avatar, name, and level
class PaymentHeaderWidget extends StatelessWidget {
  final PaymentDetails paymentDetails;

  const PaymentHeaderWidget({
    Key? key,
    required this.paymentDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Student avatar with placeholder handling
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6366F1).withOpacity(0.1),
            ),
            child: paymentDetails.studentImageUrl.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      paymentDetails.studentImageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildAvatarFallback();
                      },
                    ),
                  )
                : _buildAvatarFallback(),
          ),
          
          const SizedBox(width: 16),
          
          // Student name and level information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paymentDetails.studentName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  paymentDetails.studentLevel,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fallback avatar widget when image is not available
  /// Shows student initials in a colored circle
  Widget _buildAvatarFallback() {
    final initials = _getStudentInitials(paymentDetails.studentName);
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF6366F1),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Extract initials from student name for avatar fallback
  /// This handles various name formats gracefully
  String _getStudentInitials(String name) {
    if (name.isEmpty) return 'S';
    
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    } else {
      return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'.toUpperCase();
    }
  }
}
