// lib/core/services/signalr_service.dart

import 'package:signalr_netcore/signalr_client.dart';
import 'package:dirassati/core/shared_constants.dart';      // your backend IP, etc.
import 'package:dirassati/core/storage/secure_storage.dart'; // token storage

class SignalRService {
  late final HubConnection _hubConnection;
  final SecureStorage _storage = SecureStorage();

  /// Expose the current connection state
  HubConnectionState get connectionState =>
      _hubConnection.state ?? HubConnectionState.Disconnected;

  /// Expose the state stream for reactive UIs
  Stream<HubConnectionState> get connectionStateStream =>
      _hubConnection.stateStream;

  Future<void> startConnection() async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No token found');

    _hubConnection = HubConnectionBuilder()
      .withUrl(
        'http://${BackendProvider.backendProviderIp}/parentNotificationHub',
        options: HttpConnectionOptions(
          accessTokenFactory: () async => token,
          // transport: HttpTransportType.webSockets, // optional
        ),
      )
      .withAutomaticReconnect()
      .build();

    _hubConnection.onclose(({error}) {
      print('SignalR closed: $error');
    });
    _hubConnection.onreconnecting(({error}) {
      print('Reconnecting: $error');
    });
    _hubConnection.onreconnected(({connectionId}) {
      print('Reconnected, connectionId=$connectionId');
    });

    await _hubConnection.start();
    print('SignalR connected (id=${_hubConnection.connectionId})');
  }

  void onNotificationReceived(
      String methodName, void Function(List<Object?>? args) callback) {
    _hubConnection.on(methodName, callback);
  }

  Future<void> stopConnection() => _hubConnection.stop();
}
