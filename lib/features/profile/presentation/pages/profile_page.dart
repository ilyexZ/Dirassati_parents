// profile_page.dart
import 'package:dirassati/features/profile/presentation/widgets/profile_header.dart';
import 'package:dirassati/features/profile/presentation/widgets/profile_info.dart';
import 'package:dirassati/features/profile/presentation/widgets/profile_settings.dart'; // <-- Import the new file
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dirassati/features/auth/domain/providers/auth_provider.dart';
import 'package:dirassati/features/profile/presentation/pages/change_password_page.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> settings = [
      {
        'title': "Changer mot de passe",
        'icon': PhosphorIcons.lockSimple(),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
          );
        }
      },
      {
        'title': "Changer numero de téléphone",
        'icon': PhosphorIcons.phone(),
        'onTap': () {}
      },
      {
        'title': "Changer adresse email",
        'icon': PhosphorIcons.envelopeSimple(),
        'onTap': () {},
      },
      {'title': "Aide", 'icon': PhosphorIcons.question(), 'onTap': () {}},
      {
        'title': "Se déconnecter",
        'icon': PhosphorIcons.signOut(),
        'onTap': () {
          ref.read(authStateProvider.notifier).logout();
        },
        'iconColor': const Color(0xFFDC2626),
        'trailingIcon': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Header with avatar and name
          const ProfileHeader(),

          // Info widget
          const ProfileInfo(),

          // The new ProfileSettings widget
          ProfileSettings(settings: settings),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
