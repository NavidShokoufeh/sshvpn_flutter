# SSH Vpn Flutter Plugin (iOS Only)

A Flutter plugin for managing SSH VPN connections on **iOS**. This plugin provides methods to set up, connect, disconnect, and check the status of VPN connections using SSH.

---

## Features

- **Setup VPN**: Configure VPN with hostname, credentials, and protocol settings.
- **Connect to VPN**: Establish a VPN connection.
- **Disconnect VPN**: Terminate an active VPN session.
- **Retrieve Connection Status**: Get the last known status of the VPN connection.

**Note**: This plugin currently supports **iOS only**.

---

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  sshvpn_flutter: ^latest_version
```

Run the command:
```dart
flutter pub get
```

Import the package in your Dart code:
```dart
import 'package:sshvpn_flutter/sshvpn_flutter.dart';
```

# iOS Setup

### <b>1. Add Capabillity</b>
Add <b>Network Extensions</b> capabillity on Runner's Target and enable <b>Packet Tunnel</b>

<img src ='https://github.com/NavidShokoufeh/sshvpn_flutter/blob/main/example/sc/1.png?raw=true'>

### <b>2. Add New Target</b>
Click + button on bottom left, Choose <b>NETWORK EXTENSION</b>. And set <b>Language</b> and <b>Provider  Type</b> to <b>Objective-C</b> and <b>Packet Tunnel</b> as image below.

<img src ='https://github.com/NavidShokoufeh/sshvpn_flutter/blob/main/example/sc/2.png?raw=true'>

### <b>3. Add Capabillity to sshvpn_extension</b>

Repeat the step 1 for new target you created on previous step (sshvpn_extension)

### <b>4. Add Framework Search Path</b>

Select sshvpn_extension and add the following lines to your <b>Build Setting</b> > <b>Framework Search Path</b>:

```
$(SRCROOT)/.symlinks/plugins/sshvpn_flutter/ios/include
```

### <b>5. Copy Paste</b>

Open sshvpn_extension > PacketTunnelProvider.m and copy paste this script <a href="https://raw.githubusercontent.com/NavidShokoufeh/sshvpn_flutter/refs/heads/main/example/ios/sshvpn_extension/PacketTunnelProvider.m">PacketTunnelProvider.m</a>

# Usage

## Setting up the VPN

To configure the VPN connection, use the setup method and pass an SSHServer instance with the required configuration:

```dart
import 'package:sshvpn_flutter/sshvpn_flutter.dart';

final sshVpnFlutterPlugin = SshvpnFlutter();

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
```

## Connecting to VPN

To connect to the VPN:
```dart
await sshVpnFlutterPlugin.connect();
```

## Disconnecting from VPN

To disconnect from the VPN:
```dart
await sshVpnFlutterPlugin.disconnect();
```

## Checking Connection Status

To get the last known VPN connection status:
```dart
String status = await sshVpnFlutterPlugin.lastStatus() ?? 'disconnected'
print('Last VPN status: $status');
```

# Limitations

- **Platform:** This plugin is only supported on iOS. Android support is not currently available.
- **Dependencies:** Ensure your iOS project is properly configured for VPN usage.

## Contributions and Issues

Feel free to contribute to this project by submitting pull requests or reporting issues on the [GitHub repository](https://github.com/NavidShokoufeh/sshvpn_flutter).

This addition emphasizes that the purpose of the plugin is to provide a secure means for web surfing using SSH VPN connections. Adjustments can be made based on your specific requirements.

## Support this Project

If you find this project helpful, consider supporting it by making a donation. Major of Your contribution will spend on charity every month.

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/navidshokoufeh)

[!["زرین پال"](https://cdn.zarinpal.com/badges/trustLogo/1.png)](https://zarinp.al/navid_shokoufeh)

- **Bitcoin (BTC):** `bc1qgwfqm5e3fhyw879ycy23zljcxl2pvs575c3j7w`
- **USDT (TRC20):** `TJc5v4ktoFaG3WamjY5rvSZy7v2F6tFuuE` 

Thank you for your support! 🚀

# License

```vbnet

Copyright 2024 Navid Shokoufeh

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions, and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

```