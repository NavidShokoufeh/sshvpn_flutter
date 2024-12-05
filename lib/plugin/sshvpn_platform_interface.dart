import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sshvpn_flutter/models/ssh_server.dart';

import 'sshvpn_method_channel.dart';

abstract class SshvpnFlutterPlatform extends PlatformInterface {
  SshvpnFlutterPlatform() : super(token: _token);

  static const String _token = '';
  static SshvpnFlutterPlatform _instance = MethodChannelSshvpnFlutter();
  static SshvpnFlutterPlatform get instance => _instance;

  static set instance(SshvpnFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> connect();

  Future<bool?> disconnect();

  Future<bool?> setup({required SSHServer server});

  Future<String?> lastStatus();
}
