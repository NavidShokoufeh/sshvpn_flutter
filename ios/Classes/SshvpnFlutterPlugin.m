#import "SshvpnFlutterPlugin.h"
#import "vpn_adapter_ios/NodeModel.h"
#import "vpn_adapter_ios/CheckConnectData.h"
#import <ExtParser/ExtParser.h>
#import <SshLib/SshLib.h>

@interface SshvpnFlutterPlugin ()

@property (nonatomic, assign) BOOL isObserverAdded;
@property (nonatomic,strong) NodeModel * modal;

@end

@implementation SshvpnFlutterPlugin{
    FlutterMethodChannel *_iOSToFlutterChannel;
    YDVPNStatus connectionStatus;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.navidshokoufeh.sshvpn_flutter"
            binaryMessenger:[registrar messenger]];
  SshvpnFlutterPlugin* instance = [[SshvpnFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    instance->_iOSToFlutterChannel = [FlutterMethodChannel
               methodChannelWithName:@"responseReceiver"
               binaryMessenger:[registrar messenger]];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if([@"setupVpn" isEqualToString:call.method]){
      if (!self.isObserverAdded) {
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnConnectionStatusDidChange) name:@"kApplicationVPNStatusDidChangeNotification" object:nil];
          self.isObserverAdded = YES;
      }
      
      self.modal = [[NodeModel alloc] init];
      self.modal.nodeName = @"SSH";
      self.modal.TLS = [call.arguments[@"enableTLS"] boolValue];
      self.modal.CHAP = [call.arguments[@"enableCHAP"] boolValue];
      self.modal.MSCHAP2 = [call.arguments[@"enableMSCHAP2"] boolValue];
      self.modal.PAP = [call.arguments[@"enablePAP"] boolValue];
      self.modal.server = [NSString stringWithFormat:@"%@", call.arguments[@"hostName"] ?: @""];
      self.modal.port = [NSString stringWithFormat:@"%@", call.arguments[@"sslPort"] ?: @""];
      self.modal.username = [NSString stringWithFormat:@"%@", call.arguments[@"userName"] ?: @""];
      self.modal.password = [NSString stringWithFormat:@"%@", call.arguments[@"password"] ?: @""];
      self.modal.udpgw = [NSString stringWithFormat:@"%@", call.arguments[@"udpgw"] ?: @""];
      self.modal.udpgw_port = [NSString stringWithFormat:@"%@", call.arguments[@"udpgw_port"] ?: @""];
      self.modal.desc = @"";
      
      [NodeModel shareInstance].selectNode = self.modal;
      
      [[PDVPNManager sharedManager] setupVPNManager];

      result(@(YES));
  }else if([@"connect" isEqualToString:call.method]){
      [[PDVPNManager sharedManager] connectUsing:[CheckConnectData checkConnectParmer:self.modal]];
      result(@(YES));
  }else if([@"disconnect" isEqualToString:call.method]){
      [[PDVPNManager sharedManager] disconnect];
      result(@(YES));
  }else if([@"checkLastConnectionStatus" isEqualToString:call.method]){
      NSInteger lastConnectionStatus = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastConnectionStatus"];
      
      
      if(lastConnectionStatus == YDVPNStatusConnected){
          result(@"Connected");
      }else if(lastConnectionStatus == YDVPNStatusConnecting){
          result(@"Connecting");
      }
      else if(lastConnectionStatus == YDVPNStatusDisconnected){
          result(@"Disconnected") ;
      }
  }else {
    result(FlutterMethodNotImplemented);
  }
}

-(void)vpnConnectionStatusDidChange{
    if(connectionStatus == PDVPNManager.sharedManager.status){
        return;
    }
    
    connectionStatus = PDVPNManager.sharedManager.status;
    
    if (PDVPNManager.sharedManager.status == YDVPNStatusConnected) {
        NSLog(@"Connected");
        NSDictionary *data = @{@"status": @"Connected"};
        [self sendMessageToFlutter:data];
    }else if (PDVPNManager.sharedManager.status == YDVPNStatusConnecting) {
        NSLog(@"Connecting");
        NSDictionary *data = @{@"status": @"Connecting"};
        [self sendMessageToFlutter:data];
    }
    else if (PDVPNManager.sharedManager.status == YDVPNStatusDisconnected){
        NSLog(@"Disconnected");
        NSDictionary *data = @{@"status": @"Disconnected"};
        [self sendMessageToFlutter:data];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@(PDVPNManager.sharedManager.status) forKey:@"lastConnectionStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sendMessageToFlutter:(NSDictionary *)message {
    if (_iOSToFlutterChannel) {
        [_iOSToFlutterChannel invokeMethod:@"connectResponse" arguments:message];
    }
}

@end
