// lib/core/services/signalr_service.dart
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import '../shared_constants.dart';

class SignalRService {
  HubConnection? _connection;
  late final String _hubUrl;
  String? _authToken;
  
  // Store registered methods to register them after connection is established
  final Map<String, Function(List?)> _pendingRegistrations = {};

  SignalRService() {
    _hubUrl = 'https://${BackendProvider.backendProviderIp}/parentNotificationHub';
  }
Future<String> resolveRedirectedUrl(String originalUrl) async {
  final response = await http.get(
    Uri.parse(originalUrl),
    headers: {
      // Optional: Include token if backend requires it for redirect
      'Authorization': 'Bearer $_authToken',
    },
  );

  // If 307 or 302, follow redirect manually
  if (response.statusCode == 307 || response.statusCode == 302) {
    final location = response.headers['location'];
    if (location != null) {
      return location;
    } else {
      throw Exception("Redirected but no location header found.");
    }
  }

  // If no redirect, just return the original
  return originalUrl;
}
  bool get isConnected => _connection?.state == HubConnectionState.Connected;

  // Set the auth token when the user logs in
  void setAuthToken(String token) {
    _authToken = token;
  }


  // Register client method - this now stores the registration for later use
  Future<void> registerClientMethod(String methodName, Function(List?) callback) async {
    try {
      debugPrint('📝 Registering client method: $methodName');
      
      // Store the registration
      _pendingRegistrations[methodName] = callback;
      
      // If connection is already established, register immediately
      if (_connection != null && isConnected) {
        _connection!.on(methodName, callback);
        debugPrint('✅ Client method $methodName registered successfully (immediate)');
      } else {
        debugPrint('📝 Client method $methodName stored for later registration');
      }
    } catch (e) {
      debugPrint('❌ Error registering client method $methodName: $e');
      rethrow;
    }
  }

  // Register all pending methods after connection is established
  void _registerAllPendingMethods() {
    debugPrint('🔄 Registering ${_pendingRegistrations.length} pending client methods...');
    
    for (var entry in _pendingRegistrations.entries) {
      try {
        _connection!.on(entry.key, entry.value);
        debugPrint('✅ Registered pending method: ${entry.key}');
      } catch (e) {
        debugPrint('❌ Error registering pending method ${entry.key}: $e');
      }
    }
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

      debugPrint('🔄 Creating SignalR connection...');

      // Create the connection with proper authentication
      _connection = HubConnectionBuilder()
          .withUrl(Uri.encodeFull(_hubUrl),
              options: HttpConnectionOptions(
                transport: HttpTransportType.WebSockets,
                accessTokenFactory: () => Future.value(_authToken),
              ))
          .withAutomaticReconnect(retryDelays: [2000, 5000, 10000, 30000])
          .configureLogging(Logger.root)
          
          .build();

      // Add connection state handlers
      // _connection!.onclose((Exception? error) {
      //   debugPrint('SignalR connection closed: $error');
      // });

      // _connection!.onreconnecting((error) {
      //   debugPrint('SignalR reconnecting: $error');
      // });

      // _connection!.onreconnected((connectionId) {
      //   debugPrint('SignalR reconnected with ID: $connectionId');
      //   // Re-register all methods after reconnection
      //   _registerAllPendingMethods();
      // });

      // Start the connection
      debugPrint('🔄 Starting SignalR connection...');
      await _connection!.start();
      debugPrint('✅ SignalR connection started successfully');

      // Register all pending client methods after connection is established
      _registerAllPendingMethods();
      
    } catch (e) {
      debugPrint('❌ Error starting SignalR connection: $e');
      rethrow;
    }
  }

  // Updated method name for consistency
  void onNotificationReceived(String methodName, Function(List?) callback) {
    registerClientMethod(methodName, callback);
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
    _pendingRegistrations.clear();
  }
}