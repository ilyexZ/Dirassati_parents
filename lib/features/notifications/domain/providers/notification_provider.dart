// lib/features/notifications/domain/providers/notification_provider.dart
import 'dart:convert';

import 'package:dirassati/core/services/colorLog.dart';
import 'package:dirassati/core/services/notification_service.dart';
import 'package:dirassati/core/services/signalr_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/real_time_absence.dart';

final notificationInitProvider = FutureProvider<void>((ref) async {
  final notificationService = ref.watch(notificationServiceProvider);
  await notificationService.initialize();
});

final signalRServiceProvider = Provider((ref) => SignalRService());

final notificationsProvider =
    StateNotifierProvider<NotificationNotifier, List<Map<String, String>>>(
        (ref) {
  final signalRService = ref.watch(signalRServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return NotificationNotifier(signalRService, notificationService,ref);
});

// Connection status provider to track SignalR connection
final notificationConnectionProvider = StateProvider<bool>((ref) => false);

class NotificationNotifier extends StateNotifier<List<Map<String, String>>> {
  final SignalRService _signalRService;
  final NotificationService _notificationService;
  final Ref _ref;

 NotificationNotifier(
    this._signalRService,
    this._notificationService,
    this._ref,
  ) : super([]) {
    _registerNotificationHandlers();
  }

  void _registerNotificationHandlers() {
    // Register handler for absence notifications
    _signalRService.onNotificationReceived(
      'ReceiveAbsenceNotification', // Must match hub method name
      (args) async {
        debugPrint('📩 RAW ABSENCE NOTIFICATION RECEIVED');
        debugPrint('📩 Args type: ${args?.runtimeType}');
        debugPrint('📩 Args content: $args');

        if (args != null && args.isNotEmpty) {
          debugPrint('📩 Processing absence notification...');
          try {
            // Handle the notification data
            final notificationData = args[0];
            debugPrint('Notification data type: ${notificationData.runtimeType}');
            debugPrint('Notification data: $notificationData');

            RealTimeAbsence? absence;

            // Parse the data based on its type
            if (notificationData is Map<String, dynamic>) {
              absence = RealTimeAbsence.fromJson(notificationData);
            } else if (notificationData is String) {
              // If it's a JSON string, parse it first
              try {
                final Map<String, dynamic> jsonData =
                    json.decode(notificationData);
                absence = RealTimeAbsence.fromJson(jsonData);
              } catch (e) {
                debugPrint('Error parsing JSON string: $e');
                return;
              }
            } else {
              debugPrint('Unknown notification data type: ${notificationData.runtimeType}');
              return;
            }

            if (absence != null) {
              // Format the notification for display
              final formattedNotification = _formatAbsenceNotification(absence);

              // Add to state (insert at beginning for newest first)
              state = [formattedNotification, ...state];

              // Show local notification
              await _showLocalAbsenceNotification(absence);

              debugPrint('✅ Successfully processed absence notification');
            }
          } catch (e) {
            debugPrint('❌ Error processing absence notification: $e');
          }
        } else {
          debugPrint('❌ Empty notification args received');
        }
      },
    );

    // Register handler for convocation notifications
    _signalRService.onNotificationReceived(
      'ReceiveConvocationNotification',
      (args) async {
        debugPrint('📩 RAW CONVOCATION NOTIFICATION RECEIVED');
        debugPrint('📩 Args content: $args');
        
        if (args != null && args.isNotEmpty) {
          try {
            final notificationData = args[0];
            
            // Process convocation data (adjust based on your convocation model)
            Map<String, String> formattedNotification;
            
            if (notificationData is Map<String, dynamic>) {
              formattedNotification = _formatConvocationNotification(notificationData);
            } else if (notificationData is String) {
              final Map<String, dynamic> jsonData = json.decode(notificationData);
              formattedNotification = _formatConvocationNotification(jsonData);
            } else {
              debugPrint('Unknown convocation data type: ${notificationData.runtimeType}');
              return;
            }

            // Add to state
            state = [formattedNotification, ...state];

            // Show local notification
            await _showLocalConvocationNotification(formattedNotification);

            debugPrint('✅ Successfully processed convocation notification');
          } catch (e) {
            debugPrint('❌ Error processing convocation notification: $e');
          }
        }
      },
    );
  }

  Map<String, String> _formatAbsenceNotification(RealTimeAbsence absence) {
    final formattedDate = _formatDate(absence.dateTime);
    final studentName = absence.student != null
        ? '${absence.student!.firstName} ${absence.student!.lastName}'
        : 'Student Unknown';

    return {
      'id': absence.absenceId,
      'type': 'absence',
      'title': 'Notification d\'absence',
      'subtitle': absence.isJustified ? 'absence justifiée' : 'absence injustifiée',
      'child': studentName,
      'description': absence.isJustified
          ? 'Votre enfant a été absent avec justificatif.'
          : 'Votre enfant a été absent sans justificatif.',
      'date': formattedDate,
      'remark': absence.remark ?? '',
    };
  }

  Map<String, String> _formatConvocationNotification(Map<String, dynamic> data) {
    // Adjust this based on your convocation data structure
    final formattedDate = data['dateTime'] != null 
        ? _formatDate(DateTime.parse(data['dateTime'])) 
        : _formatDate(DateTime.now());
    
    return {
      'id': data['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'convocation',
      'title': data['title']?.toString() ?? 'Convocation',
      'subtitle': data['subtitle']?.toString() ?? 'Nouvelle convocation',
      'child': data['studentName']?.toString() ?? 'Votre enfant',
      'description': data['description']?.toString() ?? 'Vous avez reçu une nouvelle convocation.',
      'date': formattedDate,
      'remark': data['remark']?.toString() ?? '',
    };
  }

  String _formatDate(DateTime dateTime) {
    try {
      final DateFormat formatter = DateFormat('dd MMMM yyyy - HH:mm', 'fr_FR');
      return formatter.format(dateTime);
    } catch (e) {
      debugPrint('Error formatting date: $e');
      // Fallback to simple format
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _showLocalAbsenceNotification(RealTimeAbsence absence) async {
    try {
      final studentName = absence.student != null
          ? '${absence.student!.firstName} ${absence.student!.lastName}'
          : 'Votre enfant';

      final title = absence.isJustified ? 'Absence justifiée' : 'Absence injustifiée';
      final body = absence.isJustified
          ? '$studentName a été absent(e) avec justificatif'
          : '$studentName a été absent(e) sans justificatif';

      await _notificationService.showAbsenceNotification(
        title: title,
        body: body,
        payload: absence.absenceId,
      );
    } catch (e) {
      debugPrint('❌ Error showing local absence notification: $e');
    }
  }

  Future<void> _showLocalConvocationNotification(Map<String, String> data) async {
    try {
      await _notificationService.showConvocationNotification(
        title: data['title'] ?? 'Convocation',
        body: data['description'] ?? 'Nouvelle convocation reçue',
        payload: data['id'],
      );
    } catch (e) {
      debugPrint('❌ Error showing local convocation notification: $e');
    }
  }

  // Method to connect to SignalR when user logs in
  Future<void> connect(String authToken) async {
    try {
      debugPrint('🔄 Connecting to SignalR...');
      _signalRService.setAuthToken(authToken);
      await _signalRService.startConnection();
      
      // Update connection status
      _ref.read(notificationConnectionProvider.notifier).state = true;
      
      debugPrint('✅ SignalR connection established successfully');
    } catch (e) {
      debugPrint('❌ SignalR connection failed: $e');
      _ref.read(notificationConnectionProvider.notifier).state = false;
      rethrow;
    }
  }

  // Method to disconnect from SignalR
  Future<void> disconnect() async {
    try {
      await _signalRService.stopConnection();
      _ref.read(notificationConnectionProvider.notifier).state = false;
      debugPrint('✅ Successfully disconnected from SignalR hub');
    } catch (e) {
      debugPrint('❌ Error disconnecting from SignalR hub: $e');
    }
  }

  // Method to clear all notifications
  void clearNotifications() {
    state = [];
    debugPrint('🗑️ All notifications cleared');
  }

  // Method to remove a specific notification
  void removeNotification(String notificationId) {
    state = state
        .where((notification) => notification['id'] != notificationId)
        .toList();
    debugPrint('🗑️ Notification $notificationId removed');
  }

  // Method to mark notification as read (if needed)
  void markAsRead(String notificationId) {
    // Note: Since we're using Map<String, String>, we can't add 'isRead' field
    // You might want to create a separate provider for read status
    debugPrint('📖 Notification $notificationId marked as read');
  }

  // Get connection status
  bool get isConnected => _ref.read(notificationConnectionProvider);

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}