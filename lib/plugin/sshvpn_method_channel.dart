import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sshvpn_flutter/models/ssh_server.dart';
import 'package:sshvpn_flutter/plugin/sshvpn_platform_interface.dart';

class MethodChannelSshvpnFlutter extends SshvpnFlutterPlatform {
  @visibleForTesting
  final methodChannelCaller =
      const MethodChannel('com.navidshokoufeh.sshvpn_flutter');

  @override
  Future<bool> connect() async {
    try {
      bool status = await methodChannelCaller.invokeMethod("connect");
      return status;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> disconnect() async {
    try {
      bool status = await methodChannelCaller.invokeMethod("disconnect");
      return status;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> setup({required SSHServer server}) async {
    try {
      bool status = await methodChannelCaller.invokeMethod("setupVpn", {
        "hostName": server.host,
        "sslPort": server.port,
        "userName": server.username,
        "password": server.password,
        "enableCHAP": server.iosConfiguration.enableCHAP,
        "enablePAP": server.iosConfiguration.enablePAP,
        "enableTLS": server.iosConfiguration.enableTLS,
        "enableMSCHAP2": server.iosConfiguration.enableMSCHAP2,
        "udpgw_port": server.udpgwPort,
        "udpgw": server.udpgw,
      });
      return status;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> lastStatus() async {
    String status =
        await methodChannelCaller.invokeMethod("checkLastConnectionStatus");
    return status;
  }

  // static final MethodChannelSshvpnFlutter _instance =
  //     MethodChannelSshvpnFlutter.internal();
  // factory MethodChannelSshvpnFlutter() => _instance;
  // MethodChannelSshvpnFlutter.internal();
}
