
import 'sshvpn_flutter_platform_interface.dart';

class SshvpnFlutter {
  Future<String?> getPlatformVersion() {
    return SshvpnFlutterPlatform.instance.getPlatformVersion();
  }
}
