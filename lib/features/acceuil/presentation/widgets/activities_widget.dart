import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ActivitesWidget extends StatelessWidget {
  const ActivitesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Activités",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemIndigo
            ),
          ),
          const SizedBox(height: 8),
          // Example activities
          _buildActivityRow(Icons.calendar_month_outlined, "Emploi du temps"),
          Divider(),
          _buildActivityRow(Icons.book_outlined, "Devoirs"),
          Divider(),
          _buildActivityRow(Icons.check_circle_outline, "Présence"),
        ],
      ),
    );
  }

  Widget _buildActivityRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 30),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
