// profile_info.dart
import 'package:dirassati/features/profile/domain/entity/profile.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final Profile profile;
  const ProfileInfo({super.key,required this.profile}) ;

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          _buildInfoRow("Adresse", "Rue el wiam",
              labelStyle, valueStyle),
          const SizedBox(height: 4),
          _buildInfoRow("Date de naissance", profile.birthDate.toString(),
              labelStyle, valueStyle),
          const SizedBox(height: 4),
          _buildInfoRow("Lieu de naissance", "sidi bel abbas",
              labelStyle, valueStyle),
          const SizedBox(height: 4),
          _buildInfoRow("Numero de refence", profile.parentId,
              labelStyle, valueStyle),
          const SizedBox(height: 4),
          _buildInfoRow("Emploi", profile.occupation,
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
