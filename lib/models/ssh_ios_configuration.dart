class SSHIOSConfiguration {
  bool? enableTLS;
  bool? enablePAP;
  bool? enableCHAP;
  bool? enableMSCHAP2;

  SSHIOSConfiguration(
      {this.enableTLS = false,
      this.enablePAP = false,
      this.enableCHAP = false,
      this.enableMSCHAP2 = true});
}
