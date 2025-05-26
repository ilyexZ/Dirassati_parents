import 'package:dirassati/features/acceuil/data/models/student_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformationsGeneralesWidget extends StatelessWidget {
  final Student student;
  const InformationsGeneralesWidget({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informations générales",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemIndigo
            ),
          ),
          const SizedBox(height: 8),
          _buildRow("Année", student.grade ?? "#empty#"),
          Divider(),
          _buildRow("Classe", student.classe ?? "##empty##"),
          Divider(),
          _buildRow("N° Ref", student.studentId),
          Divider(),
          _buildRow("Filière",student.grade ?? "#empty#" ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:MainAxisAlignment.start ,
        mainAxisSize: MainAxisSize.max,
         // Ensures text aligns properly when wrapping
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
              
              //softWrap: true,
            ),
            
          ),
          const SizedBox(width: 30),
          Expanded(
            flex: 4, // Give more space to the value
            child: SelectableText(
              textAlign: TextAlign.start,
              value,
              style: const TextStyle(fontSize: 14,color: Color(0xFF393939),fontWeight: FontWeight.w400),
              //softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
