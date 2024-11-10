import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sshvpn_flutter_platform_interface.dart';

/// An implementation of [SshvpnFlutterPlatform] that uses method channels.
class MethodChannelSshvpnFlutter extends SshvpnFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sshvpn_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
