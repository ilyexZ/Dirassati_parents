// profile_settings.dart
import 'package:flutter/material.dart';
import 'package:dirassati/features/profile/presentation/widgets/custom_list_tile.dart';

class ProfileSettings extends StatelessWidget {
  final List<Map<String, dynamic>> settings;

  const ProfileSettings({
    super.key,
    required this.settings,
  }) ;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // "Settings" header
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
          child: const Text(
            "Settings",
            style: TextStyle(
              color: Colors.indigo,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // List of settings
        ...settings.asMap().entries.map((entry) {
          final index = entry.key;
          final setting = entry.value;

          return Column(
            children: [
              CustomListTile(
                iconColor: setting['iconColor'],
                title: setting['title'],
                leadingIcon: setting['icon'],
                trailingIcon: setting['trailingIcon'] != false
                    ? Icons.arrow_forward_ios
                    : null,
                onTap: setting['onTap'],
              ),
              if (index != settings.length - 1)
                const Divider(height: 0.1),
            ],
          );
        }).toList(),
      ],
    );
  }
}
