import 'package:dirassati/core/auth_info_provider.dart';
import 'package:dirassati/core/services/colorLog.dart';
import 'package:dirassati/features/acceuil/domain/providers/students_provider.dart';
import 'package:dirassati/features/auth/domain/providers/auth_provider.dart';
import 'package:dirassati/features/profile/presentation/pages/change_password_page.dart';
import 'package:dirassati/features/profile/presentation/providers/profile_providers.dart';
import 'package:dirassati/features/profile/presentation/widgets/profile_header.dart';
import 'package:dirassati/features/profile/presentation/widgets/profile_info.dart';
import 'package:dirassati/features/profile/presentation/widgets/profile_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: profileAsyncValue.when(
        data: (profile) => SingleChildScrollView(
          child: Column(
            children: [
              // Pass the dynamic profile to the header and info widgets.
              ProfileHeader(profile: profile),
              ProfileInfo(profile: profile),
              // You can keep settings static or later link them to further endpoints.
              ProfileSettings(
                settings: [
                  {
                    'title': "Changer mot de passe",
                    'icon': PhosphorIcons.lockSimple(),
                    'onTap': () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage()),
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
                  {
                    'title': "Aide",
                    'icon': PhosphorIcons.question(),
                    'onTap': () {}
                  },
                  {
                    'title': "Se déconnecter",
                    'icon': PhosphorIcons.signOut(),
                    'onTap': () async {
                      await ref.read(authStateProvider.notifier).logout();
                      // Invalidate providers to clear cached data
                      ref.invalidate(authInfoProvider);
                      ref.invalidate(parentIdProvider);
                      ref.invalidate(profileProvider);
                      ref.invalidate(studentsProvider); // Add this line
                      clog('g',"Logged out successfully");
                    },
                    'iconColor': const Color(0xFFDC2626),
                    'trailingIcon': false,
                  },
                ],
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
      backgroundColor: Colors.white,
    );
  }
}
