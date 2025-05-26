// lib/core/services/auth_notification_integration.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dirassati/features/notifications/domain/providers/notification_provider.dart';

class AuthNotificationIntegration {
  final Ref _ref;
  
  AuthNotificationIntegration(this._ref);

  /// Call this method immediately after successful login
  Future<void> onUserLoggedIn(String authToken) async {
    try {
      debugPrint('🔐 User logged in, initializing notifications...');
      
      // Get the notification notifier
      final notificationNotifier = _ref.read(notificationsProvider.notifier);
      
      // Connect to SignalR with the auth token
      await notificationNotifier.connect(authToken);
      
      debugPrint('✅ Notification system initialized for logged-in user');
    } catch (e) {
      debugPrint('❌ Failed to initialize notifications after login: $e');
      // Don't rethrow - notification failure shouldn't prevent login
    }
  }

  /// Call this method when user logs out
  Future<void> onUserLoggedOut() async {
    try {
      debugPrint('🔓 User logged out, cleaning up notifications...');
      
      // Get the notification notifier
      final notificationNotifier = _ref.read(notificationsProvider.notifier);
      
      // Disconnect from SignalR
      await notificationNotifier.disconnect();
      
      // Clear any stored notifications
      notificationNotifier.clearNotifications();
      
      debugPrint('✅ Notification system cleaned up for logged-out user');
    } catch (e) {
      debugPrint('❌ Failed to cleanup notifications after logout: $e');
    }
  }

  /// Check if notifications are properly connected
  bool get isNotificationSystemReady {
    final notificationNotifier = _ref.read(notificationsProvider.notifier);
    return notificationNotifier.isConnected;
  }

  /// Force reconnect notifications (useful for retry scenarios)
  Future<void> reconnectNotifications(String authToken) async {
    try {
      debugPrint('🔄 Reconnecting notification system...');
      
      final notificationNotifier = _ref.read(notificationsProvider.notifier);
      
      // Disconnect first
      await notificationNotifier.disconnect();
      
      // Wait a bit before reconnecting
      await Future.delayed(const Duration(seconds: 1));
      
      // Reconnect
      await notificationNotifier.connect(authToken);
      
      debugPrint('✅ Notification system reconnected successfully');
    } catch (e) {
      debugPrint('❌ Failed to reconnect notification system: $e');
      rethrow;
    }
  }
}

// Provider for the auth notification integration
final authNotificationIntegrationProvider = Provider<AuthNotificationIntegration>((ref) {
  return AuthNotificationIntegration(ref);
});
/*
// lib/core/services/auth_notification_integration.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dirassati/features/notifications/domain/providers/notification_provider.dart';

class AuthNotificationIntegration {
  final Ref _ref;
  
  AuthNotificationIntegration(this._ref);

  /// Call this method immediately after successful login
  Future<void> onUserLoggedIn(String authToken) async {
    try {
      debugPrint('🔐 User logged in, initializing notifications...');
      
      // Get the notification notifier
      final notificationNotifier = _ref.read(notificationsProvider.notifier);
      
      // Connect to SignalR with the auth token
      await notificationNotifier.connect(authToken);
      
      debugPrint('✅ Notification system initialized for logged-in user');
    } catch (e) {
      debugPrint('❌ Failed to initialize notifications after login: $e');
      // Don't rethrow - notification failure shouldn't prevent login
    }
  }

  /// Call this method when user logs out
  Future<void> onUserLoggedOut() async {
    try {
      debugPrint('🔓 User logged out, cleaning up notifications...');
      
      // Get the notification notifier
      final notificationNotifier = _ref.read(notificationsProvider.notifier);
      
      // Disconnect from SignalR
      await notificationNotifier.disconnect();
      
      // Clear any stored notifications
      notificationNotifier.clearNotifications();
      
      debugPrint('✅ Notification system cleaned up for logged-out user');
    } catch (e) {
      debugPrint('❌ Failed to cleanup notifications after logout: $e');
    }
  }

  /// Check if notifications are properly connected
  bool get isNotificationSystemReady {
    final notificationNotifier = _ref.read(notificationsProvider.notifier);
    return notificationNotifier.isConnected;
  }

  /// Force reconnect notifications (useful for retry scenarios)
  Future<void> reconnectNotifications(String authToken) async {
    try {
      debugPrint('🔄 Reconnecting notification system...');
      
      final notificationNotifier = _ref.read(notificationsProvider.notifier);
      
      // Disconnect first
      await notificationNotifier.disconnect();
      
      // Wait a bit before reconnecting
      await Future.delayed(const Duration(seconds: 1));
      
      // Reconnect
      await notificationNotifier.connect(authToken);
      
      debugPrint('✅ Notification system reconnected successfully');
    } catch (e) {
      debugPrint('❌ Failed to reconnect notification system: $e');
      rethrow;
    }
  }
}

// Provider for the auth notification integration
final authNotificationIntegrationProvider = Provider<AuthNotificationIntegration>((ref) {
  return AuthNotificationIntegration(ref);
}); */