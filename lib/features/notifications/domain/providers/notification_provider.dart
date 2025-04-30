// lib/features/notifications/domain/providers/notification_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dirassati/core/services/signalr_service.dart';

final signalRServiceProvider = Provider((ref) => SignalRService());
final notificationsProvider =
    StateNotifierProvider<NotificationNotifier, List<dynamic>>((ref) {
  final svc = ref.watch(signalRServiceProvider);
  return NotificationNotifier(svc);
});

class NotificationNotifier extends StateNotifier<List<dynamic>> {
  NotificationNotifier(SignalRService _signalRService) : super([]) {
    _signalRService.onNotificationReceived(
      'ReceiveAbsenceNotification',
      (args) => state = [...state, args?.first],
    );
  }
}
