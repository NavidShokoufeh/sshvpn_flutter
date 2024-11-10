import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sshvpn_flutter_method_channel.dart';

abstract class SshvpnFlutterPlatform extends PlatformInterface {
  /// Constructs a SshvpnFlutterPlatform.
  SshvpnFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SshvpnFlutterPlatform _instance = MethodChannelSshvpnFlutter();

  /// The default instance of [SshvpnFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelSshvpnFlutter].
  static SshvpnFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SshvpnFlutterPlatform] when
  /// they register themselves.
  static set instance(SshvpnFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
