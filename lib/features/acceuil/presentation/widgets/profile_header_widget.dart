import 'package:dirassati/features/acceuil/data/models/student_model.dart';
import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Student student;
  const ProfileHeaderWidget({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF7B88F0).withOpacity(0.2),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(
              "Nom:",
              "${student.firstName} ${student.lastName}",
            ),
            _buildRow("Adresse:", "#ADDRESS#"),
            _buildRow("Date de naissance:", "#BIRTHDATe#"),
            _buildRow("Lieu de naissance:", "#BIRTHPLACE#"),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {TextStyle? labelStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: labelStyle ??
                  const TextStyle(fontSize: 14, color: Color(0xFF777777)),
              softWrap: true,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 1,
            child: Text(
              value,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 14),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
