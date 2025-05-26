// lib/features/auth/presentation/pages/auth_wrapper.dart
import 'package:dirassati/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dirassati/features/notifications/domain/providers/notification_provider.dart';
import 'package:dirassati/core/services/auth_notification_integration.dart';
import '../../domain/providers/auth_provider.dart';
import 'home_page.dart';
import 'login_page.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    final notificationStatus = ref.watch(notificationConnectionProvider);

    // Listen for auth state changes
    ref.listen<UserModel?>(authStateProvider, (previous, current) {
      if (current != null && !notificationStatus) {
        // If user just logged in but notifications aren't connected, try to reconnect
        Future.delayed(const Duration(seconds: 2), () {
          if (current.token.isNotEmpty) {
            ref.read(authNotificationIntegrationProvider)
                .reconnectNotifications(current.token);
          }
        });
      }
    });

    if (user != null) {
      // User is authenticated, go to HomePage
      return const HomePage();
    } else {
      // No user, show the LoginPage
      return const LoginPage();
    }
  }
}

// Optional: Notification Status Widget to show in your main app
class NotificationStatusWidget extends ConsumerWidget {
  const NotificationStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(notificationConnectionProvider);
    final authState = ref.watch(authStateProvider);

    if (authState == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isConnected ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isConnected ? Icons.notifications_active : Icons.notifications_off,
            size: 16,
            color: isConnected ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            isConnected ? 'Notifications actives' : 'Notifications déconnectées',
            style: TextStyle(
              fontSize: 12,
              color: isConnected ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!isConnected) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                ref.read(authStateProvider.notifier).reconnectNotifications();
              },
              child: const Icon(
                Icons.refresh,
                size: 14,
                color: Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }
}