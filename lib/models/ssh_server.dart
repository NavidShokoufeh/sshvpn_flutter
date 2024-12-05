import 'package:sshvpn_flutter/models/ssh_ios_configuration.dart';

class SSHServer {
  final String host;
  final int port;
  final String username;
  final String password;
  final String udpgw;
  final int udpgwPort;
  final SSHIOSConfiguration iosConfiguration;

  SSHServer({
    required this.host,
    this.port = 443,
    required this.username,
    required this.password,
    required this.iosConfiguration,
    required this.udpgw,
    this.udpgwPort = 7300,
  });
}
