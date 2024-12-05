import 'package:flutter/services.dart';
import 'package:sshvpn_flutter/models/ssh_server.dart';
import 'package:sshvpn_flutter/models/status.dart';
import 'package:sshvpn_flutter/plugin/sshvpn_platform_interface.dart';

typedef OnConnected = Function();
typedef OnConnecting = void Function();
typedef OnDisconnected = void Function();
typedef OnError = Function();

class SshvpnFlutter {
  MethodChannel channel = const MethodChannel("responseReceiver");

  /// Starts connection between client and provided [SSHServer]
  /// Before try to connect , make sure you have called [setup] metthod
  Future<bool?> connect() {
    return SshvpnFlutterPlatform.instance.connect();
  }

  /// Disconnects current running ssh connection
  Future<bool?> disconnect() {
    return SshvpnFlutterPlatform.instance.disconnect();
  }

  /// Sets provided [SSHServer] and registers your application as vpn in user's phone settings
  Future<bool?> setup({required SSHServer server}) {
    return SshvpnFlutterPlatform.instance.setup(server: server);
  }

  /// Returns last connection status
  Future<String?> lastStatus() {
    return SshvpnFlutterPlatform.instance.lastStatus();
  }

  /// As the status changed , it gets called
  Future onStatusChanged({
    OnConnected? onConnectedResult,
    OnConnecting? onConnectingResult,
    OnDisconnected? onDisconnectedResult,
    OnError? onError,
  }) async {
    Future methodCallReceiver(MethodCall call) async {
      var arg = call.arguments;

      if (call.method == 'connectResponse') {
        if (arg["status"] == SSHConnectionStatusKeys.CONNECTED) {
          onConnectedResult!();
        } else if (arg["status"] == SSHConnectionStatusKeys.CONNECTING) {
          onConnectingResult!();
        } else if (arg["status"] == SSHConnectionStatusKeys.DISCONNECTED) {
          onDisconnectedResult!();
          bool? error = arg["error"];
          if (error != null && error) onError!();
        }
      }
    }

    channel.setMethodCallHandler(methodCallReceiver);
  }
}
