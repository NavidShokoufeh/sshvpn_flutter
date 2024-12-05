import 'package:flutter/material.dart';
import 'package:sshvpn_flutter/sshvpn_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final sshVpnFlutterPlugin = SshvpnFlutter();
  var connectionStatus = "disconnected";

  TextEditingController hostNameController = TextEditingController();
  TextEditingController sslPortController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController udpgwController = TextEditingController();
  TextEditingController udpgwPortController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
    onStatusChanged();
  }

  init() async {
    connectionStatus = await sshVpnFlutterPlugin.lastStatus() ?? 'disconnected';
    setState(() {});
  }

  setupVpn() async {
    SSHServer server = SSHServer(
      host: hostNameController.text,
      port: int.parse(
          sslPortController.text.isEmpty ? '443' : sslPortController.text),
      username: userNameController.text,
      password: passController.text,
      udpgw: udpgwController.text,
      udpgwPort: int.parse(
          udpgwPortController.text.isEmpty ? '7300' : udpgwPortController.text),
      iosConfiguration: SSHIOSConfiguration(
        enableMSCHAP2: true,
        enableCHAP: false,
        enablePAP: false,
        enableTLS: false,
      ),
    );
    await sshVpnFlutterPlugin.setup(server: server);
  }

  onStatusChanged() {
    sshVpnFlutterPlugin.onStatusChanged(
      onConnectedResult: () {
        setState(() {
          connectionStatus = "connected";
        });
      },
      onConnectingResult: () {
        setState(() {
          connectionStatus = "connecting";
        });
      },
      onDisconnectedResult: () {
        setState(() {
          connectionStatus = "disconnected";
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter SSH vpn example app'),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("connectionStatus : $connectionStatus"),
                ],
              ),
              TextField(
                controller: hostNameController,
                decoration: const InputDecoration(hintText: "host name"),
              ),
              TextField(
                controller: sslPortController,
                decoration: const InputDecoration(hintText: "ssl port"),
              ),
              TextField(
                controller: userNameController,
                decoration: const InputDecoration(hintText: "user name"),
              ),
              TextField(
                controller: passController,
                decoration: const InputDecoration(hintText: "password"),
              ),
              TextField(
                controller: udpgwController,
                decoration: const InputDecoration(hintText: "udpgw"),
              ),
              TextField(
                controller: udpgwPortController,
                decoration: const InputDecoration(hintText: "udpgw port"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await setupVpn();
                        try {
                          await sshVpnFlutterPlugin.connect();
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      child: const Text("Connect")),
                  ElevatedButton(
                      onPressed: () async {
                        await sshVpnFlutterPlugin.disconnect();
                      },
                      child: const Text("Disconnect"))
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
