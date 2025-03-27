import 'package:flutter/material.dart';

class GradeItem extends StatelessWidget {
  final String subject;
  final int coef;
  final double grade;

  const GradeItem({
    super.key,
    required this.subject,
    required this.coef,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    // Simple logic to color-code the grade:
    final bool isPassed = grade >= 10;
    final backgroundColor =Color(0xffF5F4FF);
        //isPassed ? Colors.green.shade50 : Colors.red.shade50;
    final textColor = isPassed ? Colors.green.shade700 : Colors.red.shade700;

    return Card(
      elevation: 1,

      
      child: Container(
        
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Subject
            Expanded(
              flex: 7,
              child: Text(
                subject,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            // Coefficient
            Expanded(
              flex: 1,
              child: Text(
                "$coef",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            // Grade
            Expanded(
              flex: 2,
              child: Text(
                "$grade",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
