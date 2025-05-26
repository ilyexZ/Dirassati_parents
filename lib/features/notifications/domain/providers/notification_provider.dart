// lib/features/notifications/domain/providers/notification_provider.dart
import 'package:dirassati/core/services/notification_service.dart';
import 'package:dirassati/core/services/signalr_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

// Your existing providers...
final signalRServiceProvider = Provider((ref) => SignalRService());
final notificationConnectionProvider = StateProvider<bool>((ref) => false);

final notificationsProvider =
    StateNotifierProvider<NotificationNotifier, List<Map<String, String>>>(
        (ref) {
  final signalRService = ref.watch(signalRServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return NotificationNotifier(signalRService, notificationService, ref);
});

class NotificationNotifier extends StateNotifier<List<Map<String, String>>> {
  final SignalRService _signalRService;
  final NotificationService _notificationService;
  final Ref _ref;

  NotificationNotifier(
    this._signalRService,
    this._notificationService,
    this._ref,
  ) : super([]) {
    debugPrint('🏗️ NotificationNotifier initialized');
  }

  void _registerNotificationHandlers() {
    debugPrint('📝 Registering notification handlers...');
    
    // Register handler for absence notifications
    _signalRService.registerClientMethod(
      'ReceiveAbsenceNotification',
      (args) async {
        debugPrint('🔥 ABSENCE NOTIFICATION RECEIVED!');
        debugPrint('📩 Args type: ${args?.runtimeType}');
        debugPrint('📩 Args length: ${args?.length}');
        debugPrint('📩 Args content: $args');
        
        if (args != null && args.isNotEmpty) {
          debugPrint('📩 Processing absence notification...');
          try {
            final notificationData = args[0];
            debugPrint('📊 Notification data type: ${notificationData.runtimeType}');
            debugPrint('📊 Notification data: $notificationData');
            
            Map<String, String> formattedNotification;
            
            if (notificationData is Map<String, dynamic>) {
              formattedNotification = _formatAbsenceNotificationFromHub(notificationData);
            } else if (notificationData is String) {
              try {
                final Map<String, dynamic> jsonData = json.decode(notificationData);
                formattedNotification = _formatAbsenceNotificationFromHub(jsonData);
              } catch (e) {
                debugPrint('❌ Error parsing JSON string: $e');
                return;
              }
            } else {
              debugPrint('❌ Unknown notification data type: ${notificationData.runtimeType}');
              return;
            }
            
            state = [formattedNotification, ...state];
            await _showLocalAbsenceNotificationFromHub(formattedNotification);
            debugPrint('✅ Successfully processed absence notification');
          } catch (e) {
            debugPrint('❌ Error processing absence notification: $e');
          }
        } else {
          debugPrint('❌ Empty notification args received');
        }
      },
    );

    // Register handler for student report notifications
    _signalRService.registerClientMethod(
      'ReceiveNewReport',
      (args) async {
        debugPrint('🔥 STUDENT REPORT NOTIFICATION RECEIVED!');
        debugPrint('📩 Args content: $args');
        
        if (args != null && args.isNotEmpty) {
          try {
            final notificationData = args[0];
            Map<String, String> formattedNotification;
            
            if (notificationData is Map<String, dynamic>) {
              formattedNotification = _formatReportNotification(notificationData);
            } else if (notificationData is String) {
              final Map<String, dynamic> jsonData = json.decode(notificationData);
              formattedNotification = _formatReportNotification(jsonData);
            } else {
              debugPrint('❌ Unknown report data type: ${notificationData.runtimeType}');
              return;
            }
            
            state = [formattedNotification, ...state];
            await _showLocalReportNotification(formattedNotification);
            debugPrint('✅ Successfully processed report notification');
          } catch (e) {
            debugPrint('❌ Error processing report notification: $e');
          }
        }
      },
    );

    // Register handler for bill notifications
    _signalRService.registerClientMethod(
      'ReceivePendingBillNotification',
      (args) async {
        debugPrint('🔥 BILL NOTIFICATION RECEIVED!');
        debugPrint('📩 Args content: $args');
        
        if (args != null && args.isNotEmpty) {
          try {
            final notificationData = args[0];
            if (notificationData is List) {
              // Handle multiple bills
              for (var bill in notificationData) {
                if (bill is Map<String, dynamic>) {
                  final formattedNotification = _formatBillNotification(bill);
                  state = [formattedNotification, ...state];
                  await _showLocalBillNotification(formattedNotification);
                }
              }
            } else if (notificationData is Map<String, dynamic>) {
              // Handle single bill
              final formattedNotification = _formatBillNotification(notificationData);
              state = [formattedNotification, ...state];
              await _showLocalBillNotification(formattedNotification);
            }
            debugPrint('✅ Successfully processed bill notification(s)');
          } catch (e) {
            debugPrint('❌ Error processing bill notification: $e');
          }
        }
      },
    );_signalRService.registerClientMethod(
      'ReceiveNewStudentBill',
      (args) async {
        debugPrint('🔥 NEW BILL NOTIFICATION RECEIVED!');
        debugPrint('📩 Args content: $args');
        
        if (args != null && args.isNotEmpty) {
          try {
            final notificationData = args[0];
            if (notificationData is List) {
              // Handle multiple bills
              for (var bill in notificationData) {
                if (bill is Map<String, dynamic>) {
                  final formattedNotification = _formatNewBillNotification(bill);
                  state = [formattedNotification, ...state];
                  await _showLocalNewBillNotification(formattedNotification);
                }
              }
            } else if (notificationData is Map<String, dynamic>) {
              // Handle single bill
              final formattedNotification = _formatBillNotification(notificationData);
              state = [formattedNotification, ...state];
              await _showLocalBillNotification(formattedNotification);
            }
            debugPrint('✅ Successfully processed bill notification(s)');
          } catch (e) {
            debugPrint('❌ Error processing bill notification: $e');
          }
        }
      },
    );

    // Register handler for broadcast notifications
    _signalRService.registerClientMethod(
      'ReceiveBroadcastNotification',
      (args) async {
        debugPrint('🔥 BROADCAST NOTIFICATION RECEIVED!');
        debugPrint('📩 Args content: $args');
        
        if (args != null && args.isNotEmpty) {
          try {
            final message = args[0]?.toString() ?? 'Broadcast message';
            final formattedNotification = _formatBroadcastNotification(message);
            state = [formattedNotification, ...state];
            await _showLocalGeneralNotification(formattedNotification);
            debugPrint('✅ Successfully processed broadcast notification');
          } catch (e) {
            debugPrint('❌ Error processing broadcast notification: $e');
          }
        }
      },
    );

    debugPrint('✅ All notification handlers registered');
  }

  // Method to connect to SignalR when user logs in
  Future<void> connect(String authToken) async {
    try {
      debugPrint('🔄 Connecting to SignalR with token: ${authToken.substring(0, 20)}...');
      
      // Set auth token first
      _signalRService.setAuthToken(authToken);
      
      // Register handlers BEFORE starting connection
      _registerNotificationHandlers();
      
      // Start connection (this will now automatically register the pending methods)
      await _signalRService.startConnection();
      
      // Update connection status
      _ref.read(notificationConnectionProvider.notifier).state = true;
      
      debugPrint('✅ SignalR connection established and handlers registered');
    } catch (e) {
      debugPrint('❌ SignalR connection failed: $e');
      _ref.read(notificationConnectionProvider.notifier).state = false;
      rethrow;
    }
  }

  // Your existing formatting methods remain the same...
  Map<String, String> _formatAbsenceNotificationFromHub(Map<String, dynamic> data) {
    final formattedDate = data['date'] != null 
        ? _formatDate(DateTime.parse(data['date'])) 
        : _formatDate(DateTime.now());
    
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'absence',
      'title': 'Notification d\'absence',
      'subtitle': 'absence injustifiée',
      'child': data['studentName']?.toString() ?? 'Student Unknown',
      'description': 'Votre enfant ${data['studentName'] ?? ''} a été absent.',
      'date': formattedDate,
      'remark': '',
    };
  }

  Map<String, String> _formatReportNotification(Map<String, dynamic> data) {
    final formattedDate = _formatDate(DateTime.now());
    final teacherName = data['teacher'] != null 
        ? '${data['teacher']['firstName'] ?? ''} ${data['teacher']['lastName'] ?? ''}'.trim()
        : 'Teacher';
    
    return {
      'id': data['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'report',
      'title': 'Nouveau rapport',
      'subtitle': 'rapport étudiant',
      'child': data['studentName']?.toString() ?? 'Votre enfant',
      'description': 'Un nouveau rapport a été publié par $teacherName.',
      'date': formattedDate,
      'remark': data['description']?.toString() ?? '',
    };
  }

  Map<String, String> _formatBillNotification(Map<String, dynamic> data) {
    final formattedDate = _formatDate(DateTime.now());
    final amount = data['amount']?.toString() ?? '0';
    
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'bill',
      'title': data['title']?.toString() ?? 'Nouvelle facture',
      'subtitle': 'facture école',
      'child': 'Montant: $amount',
      'description': data['description']?.toString() ?? 'Une nouvelle facture a été ajoutée.',
      'date': formattedDate,
      'remark': '',
    };
  }

  Map<String, String> _formatBroadcastNotification(String message) {
    final formattedDate = _formatDate(DateTime.now());
    
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'broadcast',
      'title': 'Annonce générale',
      'subtitle': 'message école',
      'child': '',
      'description': message,
      'date': formattedDate,
      'remark': '',
    };
  }

  String _formatDate(DateTime dateTime) {
    try {
      final DateFormat formatter = DateFormat('dd MMMM yyyy - HH:mm', 'fr_FR');
      return formatter.format(dateTime);
    } catch (e) {
      debugPrint('Error formatting date: $e');
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
  Map<String, String> _formatNewBillNotification(Map<String, dynamic> data) {
    final formattedDate = _formatDate(DateTime.now());
    final amount = data['Amount']?.toString() ?? '0';
    
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'bill',
      'title': data['Title']?.toString() ?? 'Nouvelle facture',
      'subtitle': 'facture école',
      'child': 'Montant: $amount',
      'description': data['Description']?.toString() ?? 'Une nouvelle facture a été ajoutée.',
      'date': formattedDate,
      'remark': '',
    };
  }

  // Your existing notification methods remain the same...
  Future<void> _showLocalAbsenceNotificationFromHub(Map<String, String> data) async {
    try {
      await _notificationService.showAbsenceNotification(
        title: data['title'] ?? 'Absence',
        body: data['description'] ?? 'Nouvelle absence',
        payload: data['id'],
      );
    } catch (e) {
      debugPrint('❌ Error showing local absence notification: $e');
    }
  }

  Future<void> _showLocalReportNotification(Map<String, String> data) async {
    try {
      await _notificationService.showGeneralNotification(
        title: data['title'] ?? 'Nouveau rapport',
        body: data['description'] ?? 'Un nouveau rapport a été publié',
        payload: data['id'],
        channelId: 'report_channel_id',
        channelName: 'Report Notifications',
        channelDescription: 'Notifications for student reports',
      );
    } catch (e) {
      debugPrint('❌ Error showing local report notification: $e');
    }
  }

  Future<void> _showLocalBillNotification(Map<String, String> data) async {
    try {
      await _notificationService.showGeneralNotification(
        title: data['title'] ?? 'Nouvelle facture',
        body: data['description'] ?? 'Une nouvelle facture a été ajoutée',
        payload: data['id'],
        channelId: 'bill_channel_id',
        channelName: 'Bill Notifications',
        channelDescription: 'Notifications for school bills',
      );
    } catch (e) {
      debugPrint('❌ Error showing local bill notification: $e');
    }
  }
  Future<void> _showLocalNewBillNotification(Map<String, String> data) async {
    try {
      await _notificationService.showGeneralNotification(
        title: data['Title'] ?? 'Nouvelle facture',
        body: data['Description'] ?? 'Une nouvelle facture a été ajoutée',
        payload: data['BillId'],
        channelId: 'bill_channel_id',
        channelName: 'Bill Notifications',
        channelDescription: 'Notifications for school bills',
      );
    } catch (e) {
      debugPrint('❌ Error showing local bill notification: $e');
    }
  }

  Future<void> _showLocalGeneralNotification(Map<String, String> data) async {
    try {
      await _notificationService.showGeneralNotification(
        title: data['title'] ?? 'Annonce',
        body: data['description'] ?? 'Nouvelle annonce',
        payload: data['id'],
      );
    } catch (e) {
      debugPrint('❌ Error showing local general notification: $e');
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

  // Method to test connection by adding a fake notification
  void addTestNotification() {
    final testNotification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'test',
      'title': 'Test Notification',
      'subtitle': 'This is a test',
      'child': 'Test Student',
      'description': 'This is a test notification to verify the system is working.',
      'date': _formatDate(DateTime.now()),
      'remark': 'Test remark',
    };
    state = [testNotification, ...state];
    debugPrint('🧪 Test notification added');
  }

  // Get connection status
  bool get isConnected => _ref.read(notificationConnectionProvider);

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}