// profile_info.dart
import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Adjust these styles as needed
    const labelStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: Colors.black54,  
    );
    const valueStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
           const Text(
            "Informations",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff4D44B5),
            ),
          ),
          const SizedBox(height: 4),

          // Info rows
          _buildInfoRow("Adresse", "742 evergreen terrace ,springfield",
              labelStyle, valueStyle),
          const SizedBox(height: 4),
          _buildInfoRow("Date de naissance", "25 janvier 2000",
              labelStyle, valueStyle),
          const SizedBox(height: 4),
          _buildInfoRow("Lieu de naissance", "Springfield , USA",
              labelStyle, valueStyle),
          const SizedBox(height: 4),
          _buildInfoRow("Numero de refence", "2024-001144Az12",
              labelStyle, valueStyle),
          const SizedBox(height: 4),
          _buildInfoRow("Emploi", "architecte",
              labelStyle, valueStyle),
        ],
      ),
    );
  }

  // A helper method for creating a label-value pair in two lines
  Widget _buildInfoRow(
    String label,
    String value,
    TextStyle labelStyle,
    TextStyle valueStyle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}
