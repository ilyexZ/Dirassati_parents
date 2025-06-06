import 'package:community_material_icon/community_material_icon.dart';
import 'package:dirassati/features/absences/presentation/pages/absences_page.dart';
import 'package:dirassati/features/acceuil/data/models/student_model.dart';
import 'package:dirassati/features/acceuil/presentation/pages/notes_page.dart';
import 'package:dirassati/features/payments/presentation/pages/payment_details_page.dart';
import 'package:dirassati/features/time_table/presentation/pages/time_table_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ActivitesWidget extends StatelessWidget {
  final Student student;
  const ActivitesWidget({super.key,required this.student});

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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimeTablePage()),
              );
            },
            child: _buildActivityRow(
                Icons.calendar_month_outlined, "Emploi du temps"),
          ),
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
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AbsencesPage()),
                );
              },
              child: _buildActivityRow(Icons.check_circle_outline, "Abscences")),
          Divider(),
          GestureDetector(
              onTap: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  PaymentDetailsPage(studentId : student.studentId)),
                );
              },
              child: _buildActivityRow(Icons.check_circle_outline, "Paiments")),
          
          
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
