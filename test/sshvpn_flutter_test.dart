import 'package:flutter_test/flutter_test.dart';
import 'package:sshvpn_flutter/sshvpn_flutter.dart';
import 'package:sshvpn_flutter/sshvpn_flutter_platform_interface.dart';
import 'package:sshvpn_flutter/sshvpn_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSshvpnFlutterPlatform
    with MockPlatformInterfaceMixin
    implements SshvpnFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SshvpnFlutterPlatform initialPlatform = SshvpnFlutterPlatform.instance;

  test('$MethodChannelSshvpnFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSshvpnFlutter>());
  });

  test('getPlatformVersion', () async {
    SshvpnFlutter sshvpnFlutterPlugin = SshvpnFlutter();
    MockSshvpnFlutterPlatform fakePlatform = MockSshvpnFlutterPlatform();
    SshvpnFlutterPlatform.instance = fakePlatform;

    expect(await sshvpnFlutterPlugin.getPlatformVersion(), '42');
  });
}
