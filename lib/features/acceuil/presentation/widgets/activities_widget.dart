import 'package:dirassati/features/acceuil/presentation/pages/notes_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ActivitesWidget extends StatelessWidget {
  const ActivitesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Activités",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.systemIndigo),
          ),
          const SizedBox(height: 8),
          // Example activities
          _buildActivityRow(Icons.calendar_month_outlined, "Emploi du temps"),
          Divider(),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotesPage()),
                );
              },
              child: _buildActivityRow(PhosphorIconsBold.fileText, "Notes")),
          Divider(),
          _buildActivityRow(Icons.check_circle_outline, "Présence"),
        ],
      ),
    );
  }

  Widget _buildActivityRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9), // Background color
                shape: BoxShape.circle, // Makes it circular
              ),
              child: Icon(
                icon,
                size: 20,
                color: Color(0xFF4D44B5),
              )),
          const SizedBox(width: 30),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
