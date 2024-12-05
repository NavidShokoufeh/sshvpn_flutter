//
//  lwIP.h
//  lwIP
//
//  Created by Carl Chen on 06/12/2017.
//  Copyright © 2017 nswebfrog. All rights reserved.
//

#import <Foundation/Foundation.h>


//#include <mach/mach_time.h>
//#include <stdio.h>

@class SSProtocol;
@class NEPacketTunnelNetworkSettings;

typedef void(^lwSetupNetworkSettingsCallback)(NEPacketTunnelNetworkSettings *setting);

typedef void(^lwIPOutputCallback)(NSData *ipPackets, int family);

@interface lwIP : NSObject

+(instancetype)shared;

/// 全局队列
@property (nonatomic, readonly, strong)dispatch_queue_t worker;

/// 设置 GEOIP 数据库地址
/// - Parameter geoip: 数据库地址
+(void)setup:(NSString *)geoip;

/// 设置代理服务器配置文件
/// - Parameter protcol: 配置信息
-(void)setup:(SSProtocol *)protcol;

/// 发送 IP 数据包
/// - Parameters:
///   - packet: IP Packet
///   - family: AF_INET, AF_INET6
-(void)WriteIPPacket:(NSData *)packet family:(int)family;

/// 设置数据包输出回调
/// - Parameter callback: IP 数据包回调
-(void)SetlwIPOutputCallback:(lwIPOutputCallback)callback;

/// 设置数据包输出回调
/// - Parameter callback: 网络接口设置回掉
-(void)SetlwSetupNetworkSettingsCallback:(lwSetupNetworkSettingsCallback)callback;

/// 判断当前调用是否在队列中执行
-(BOOL)InQueue;

/// 判断当前调用是否在队列中执行
+(BOOL)InQueue;


-(BOOL)close;

@end
