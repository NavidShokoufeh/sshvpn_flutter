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

  Future<bool?> connect() {
    return SshvpnFlutterPlatform.instance.connect();
  }

  Future<bool?> disconnect() {
    return SshvpnFlutterPlatform.instance.disconnect();
  }

  Future<bool?> setup({required SSHServer server}) {
    return SshvpnFlutterPlatform.instance.setup(server: server);
  }

  Future<String?> lastStatus() {
    return SshvpnFlutterPlatform.instance.lastStatus();
  }

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
