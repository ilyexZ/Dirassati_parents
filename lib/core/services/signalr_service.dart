// lib/core/services/signalr_service.dart
import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import '../shared_constants.dart';

class SignalRService {
  HubConnection? _connection;
  late final String _hubUrl;
  String? _authToken;

  SignalRService() {
    _hubUrl =
        'http://${BackendProvider.backendProviderIp}/parentNotificationHub';
  }

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

      // Create the connection with proper authentication
      _connection = HubConnectionBuilder()
          .withUrl(_hubUrl,
              options: HttpConnectionOptions(
                transport: HttpTransportType.WebSockets, // ✅ Correct param
                accessTokenFactory: () => Future.value(_authToken),
              ))
          .withAutomaticReconnect(retryDelays: [2000, 5000, 10000, 30000])
          .configureLogging(Logger.root)
          .build();

      // Add connection state handlers
      // _connection!.onclose((error) {
      //   debugPrint('SignalR connection closed: $error');
      // });

      // _connection!.onreconnecting((error) {
      //   debugPrint('SignalR reconnecting: $error');
      // });

      // _connection!.onreconnected((connectionId) {
      //   debugPrint('SignalR reconnected with ID: $connectionId');
      // });

      // Start the connection
      await _connection!.start();
      debugPrint('SignalR connection started successfully');
    } catch (e) {
      debugPrint('Error starting SignalR connection: $e');
      rethrow;
    }
  }

  // Register a callback for a specific hub method
  void onNotificationReceived(
      String methodName, Function(List<dynamic>?) callback) {
    if (_connection != null) {
      _connection!.on(methodName, callback);
      debugPrint('Registered handler for method: $methodName');
    } else {
      debugPrint('Cannot register handler: connection is null');
    }
  }

  // Stop the connection
  Future<void> stopConnection() async {
    if (_connection != null) {
      await _connection!.stop();
      debugPrint('SignalR connection stopped');
      _connection = null;
    }
  }

  // Dispose method to clean up resources
  void dispose() {
    stopConnection();
  }
}
