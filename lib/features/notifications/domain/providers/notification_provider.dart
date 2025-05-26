// lib/features/notifications/domain/providers/notification_provider.dart
import 'dart:convert';

import 'package:dirassati/core/services/notification_service.dart';
import 'package:dirassati/core/services/signalr_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/real_time_absence.dart';

final signalRServiceProvider = Provider((ref) => SignalRService());
final notificationServiceProvider = Provider((ref) => NotificationService());

final notificationsProvider =
    StateNotifierProvider<NotificationNotifier, List<Map<String, dynamic>>>((ref) {
  final signalRService = ref.watch(signalRServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return NotificationNotifier(signalRService, notificationService);
});

class NotificationNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final SignalRService _signalRService;
  final NotificationService _notificationService;
  
  NotificationNotifier(this._signalRService, this._notificationService) : super([]) {
    _registerNotificationHandlers();
  }

  void _registerNotificationHandlers() {
    // Register handler for absence notifications
    _signalRService.onNotificationReceived(
      'ReceiveAbsenceNotification', // Must match hub method name
      (args) async {
        debugPrint('Received ReceiveAbsenceNotification with args: $args');
        
        if (args != null && args.isNotEmpty) {
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
                final Map<String, dynamic> jsonData = json.decode(notificationData);
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
              
              // Add to state
              state = [...state, formattedNotification];
              
              // Show local notification
              await _showLocalNotification(absence);
              
              debugPrint('Successfully processed absence notification');
            }
            
          } catch (e) {
            debugPrint('Error processing absence notification: $e');
          }
        } else {
          debugPrint('Received empty or null notification args');
        }
      },
    );

    // You can add more handlers for different types of notifications
    _signalRService.onNotificationReceived(
      'ReceiveConvocationNotification',
      (args) async {
        debugPrint('Received ReceiveConvocationNotification with args: $args');
        // Handle convocation notifications here
        // Similar pattern to absence notifications
      },
    );
  }

  Map<String, dynamic> _formatAbsenceNotification(RealTimeAbsence absence) {
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
      'remark': absence.remark,
      'studentId': absence.studentId,
      'isJustified': absence.isJustified,
      'rawData': absence.toJson(), // Keep original data for reference
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

  Future<void> _showLocalNotification(RealTimeAbsence absence) async {
    try {
      final studentName = absence.student != null 
          ? '${absence.student!.firstName} ${absence.student!.lastName}'
          : 'Votre enfant';
      
      final title = absence.isJustified 
          ? 'Absence justifiée' 
          : 'Absence injustifiée';
      
      final body = absence.isJustified
          ? '$studentName a été absent(e) avec justificatif'
          : '$studentName a été absent(e) sans justificatif';

      await _notificationService.showAbsenceNotification(
        title: title,
        body: body,
        payload: absence.absenceId,
      );
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }
  }

  // Method to connect to SignalR when user logs in
  Future<void> connect(String authToken) async {
    try {
      _signalRService.setAuthToken(authToken);
      await _signalRService.startConnection();
      debugPrint('Successfully connected to SignalR hub');
    } catch (e) {
      debugPrint('Failed to connect to SignalR hub: $e');
      rethrow;
    }
  }

  // Method to disconnect from SignalR
  Future<void> disconnect() async {
    try {
      await _signalRService.stopConnection();
      debugPrint('Successfully disconnected from SignalR hub');
    } catch (e) {
      debugPrint('Error disconnecting from SignalR hub: $e');
    }
  }

  // Method to clear all notifications
  void clearNotifications() {
    state = [];
  }

  // Method to remove a specific notification
  void removeNotification(String notificationId) {
    state = state.where((notification) => notification['id'] != notificationId).toList();
  }

  // Method to mark notification as read (if needed)
  void markAsRead(String notificationId) {
    state = state.map((notification) {
      if (notification['id'] == notificationId) {
        return {...notification, 'isRead': true};
      }
      return notification;
    }).toList();
  }

  @override
  void dispose() {
    _signalRService.dispose();
    super.dispose();
  }
}