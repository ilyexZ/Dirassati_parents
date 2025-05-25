// lib/features/notifications/domain/providers/notification_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dirassati/core/services/signalr_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final signalRServiceProvider = Provider((ref) => SignalRService());
final notificationsProvider =
    StateNotifierProvider<NotificationNotifier, List<Map<String, dynamic>>>((ref) {
  final svc = ref.watch(signalRServiceProvider);
  return NotificationNotifier(svc);
});

class NotificationNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final SignalRService _signalRService;
  
  NotificationNotifier(this._signalRService) : super([]) {
    _registerNotificationHandlers();
  }

  void _registerNotificationHandlers() {
    _signalRService.onNotificationReceived(
      'ReceiveAbsenceNotification', // Must match hub method name
      (args) {
        if (args != null && args.isNotEmpty) {
          final notification = args[0] as Map<String, dynamic>;
          final formattedDate = _formatDate(notification['date']);
          
          final formattedNotification = {
            'title': 'Mr. LastName', // You might get this from the notification or user data
            'subtitle': 'absence injustifiée',
            'child': notification['studentName'] ?? 'Unknown Student',
            'description': 'Votre enfant a été absent sans justificatif.',
            'date': formattedDate,
          };
          
          state = [...state, formattedNotification];
        }
      },
    );
  }
  
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('dd MMMM yyyy - hh:mm a');
      return formatter.format(date);
    } catch (e) {
      debugPrint('Error formatting date: $e');
      return dateString;
    }
  }
  
  // Method to connect to SignalR when user logs in
  Future<void> connect(String authToken) async {
    _signalRService.setAuthToken(authToken);
    await _signalRService.startConnection();
  }
  
  // Method to disconnect from SignalR
  Future<void> disconnect() async {
    await _signalRService.stopConnection();
  }
}