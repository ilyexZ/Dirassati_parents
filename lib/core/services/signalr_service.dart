// lib/core/services/signalr_service.dart

import 'package:dirassati/core/shared_constants.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

  String get backendUrl => BackendProvider.backendProviderIp;
class SignalRService {
  HubConnection? _connection;
  final String _hubUrl = 'http://{$backendUrl}/parentNotificationHub';
  String? _authToken;
  
  bool get isConnected => _connection?.state == HubConnectionState.Connected;

  // Set the auth token when the user logs in
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Start the connection to the SignalR hub
  Future<void> startConnection() async {
    if (_authToken == null) {
      throw Exception('Authentication token is required');
    }
    
    try {
      // Configure logging
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((LogRecord rec) {
        debugPrint('SignalR: ${rec.level.name}: ${rec.message}');
      });
      
      // Create HTTP connection options
      final httpOptions = HttpConnectionOptions(
        accessTokenFactory: () => Future.value(_authToken),
      );
      
      // Create the connection
      _connection = HubConnectionBuilder()
          .withUrl(_hubUrl, options: httpOptions)
          .withAutomaticReconnect()
          .build();

      // Start the connection
      await _connection!.start();
      debugPrint('SignalR connection started');
    } catch (e) {
      debugPrint('Error starting SignalR connection: $e');
      rethrow;
    }
  }

  // Register a callback for a specific hub method
  void onNotificationReceived(String methodName, Function(List<dynamic>?) callback) {
    _connection?.on(methodName, callback);
  }

  // Stop the connection
  Future<void> stopConnection() async {
    if (_connection != null) {
      await _connection!.stop();
      debugPrint('SignalR connection stopped');
    }
  }
}
