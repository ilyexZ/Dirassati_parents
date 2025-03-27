import 'package:dirassati/features/acceuil/data/models/student_model.dart';
import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Student student;
  const ProfileHeaderWidget({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
        8
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(width: 0.1,color:Color(0xffEDEFFF) ),
        borderRadius: BorderRadius.circular(10.0),
      color: Color(0xffEDEFFF).withAlpha(230),
        boxShadow: [
        BoxShadow(blurRadius: 4,spreadRadius: 1,color: Colors.black.withOpacity(0.1))
      ]),
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
                  const TextStyle(fontSize: 12, color: Color(0xFF777777)),
              softWrap: true,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 1,
            child: Text(
              value,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 12),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
