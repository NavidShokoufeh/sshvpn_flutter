//
//  YDVPNManager.h
//  VPNExtension
//
//  Created by Badwin on 2023/1/15.
//  Copyright © 2023 RongVP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>
#import <ExtParser/ExtParser.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YDProviderManagerCompletion)(NETunnelProviderManager *_Nullable manager);
typedef void(^YDPingResponse)(NSString *url, long long rtt);
typedef void(^YDGetStatisticsResponse)(int64_t downloadlink, int64_t uploadlink, int64_t mdownloadlink, int64_t muploadlink);
typedef void(^YDDownloadProgress)(int64_t downloadSpeed, BOOL isDone);
typedef void(^YDUploadProgress)(int64_t uploadSpeed, BOOL isDone);

@class YDItemInfo;

typedef enum : NSUInteger {
    YDVPNStatusIDLE = 0,
    YDVPNStatusConnecting,
    YDVPNStatusConnected,
    YDVPNStatusDisconnecting,
    YDVPNStatusDisconnected
} YDVPNStatus;


@protocol YDStorage <NSObject>

- (BOOL)setObject:(nullable NSObject<NSCoding> *)object forKey:(NSString *)key;

- (BOOL)setString:(NSString *)value forKey:(NSString *)key;

- (nullable id)getObjectOfClass:(Class)cls forKey:(NSString *)key;

- (nullable NSString *)getStringForKey:(NSString *)key;

- (void)removeValueForKey:(NSString *)key;

@end



@interface PDVPNManager : NSObject

+(void)setVPNServerAddress:(NSString *)address;

+(void)setVPNLocalizedDescription:(NSString *)description;

/// 设置组 ID，用于扩展进程和主进程进行通讯，扩展进程和主进程都需要调用，请 App 启动就调用
/// - Parameter groupId: 组 ID
+(void)setGroupID:(NSString *)groupId;

/// Manager
+(instancetype)sharedManager;

// 主进程调用，扩展进程不要调
-(void)setupVPNManager;


@property (nonatomic, strong, readonly, class, nullable)NSString *mmdb;

/// UDP Socks
@property (nonatomic)BOOL udpSocks;

/// 代理共享
@property (nonatomic)BOOL shareable;

/// TCP Pings
@property (nonatomic)BOOL pingUseTcp;

/// 存储
@property (nonatomic, strong)id<YDStorage> storage;

/// 当前连接状态
@property (nonatomic, readonly)YDVPNStatus status;

/// 当前连接节点
@property (nonatomic, strong, readonly)NSString *connectedURL;

/// 连接 VPN 的时间
@property (nonatomic, strong, readonly)NSDate *connectedDate;

/// 引擎类型，0 是 xray， 1 是 v2ray
@property (nonatomic)int engine;

/// 是否全局模式，启动 VPN 或者切换节点前设置有效
@property (nonatomic)BOOL isGlobalMode;

/// 开始连接
/// - Parameter url: 节点 URL
-(void)connect:(NSString *)url;

/// 使用标准 JSON 连接服务器
/// - Parameter server: 服务器信息
-(BOOL)connectUsing:(NSDictionary *)server;

/// 断开连接
-(void)disconnect;

/// 切换节点
/// - Parameter url: 节点 URL
-(void)changeURL:(NSString *)url;

/// 获取当前自定义 DNS
-(NSArray <NSString *> *)GetDNS;

/// 删除 DNS 服务器
/// - Parameter dns: dns 服务器
-(void)deleteDnsServer:(NSString *)dns;

/// 添加 DNS 服务器
/// - Parameter dns: dns 服务器
-(void)addDnsServer:(NSString *)dns;

/// 主进程调用，扩展进程不要调
/// - Parameters:
///   - ips: ping 列表
///   - response: ping 响应
-(void)ping:(NSArray <NSString *> *)ips response:(YDPingResponse)response;

/// TCP Ping
/// - Parameters:
///   - ips: ping 列表
///   - response: ping 影响，按 URL 和 RTT 成对返回
-(void)tcpping:(NSArray <NSString *> *)ips response:(YDPingResponse)response;

/// 添加节点
/// - Parameter protocol: 节点 URL
-(void)addProtocol:(NSString *)protocol;

/// 添加订阅节点
/// - Parameters:
///   - protocol: 节点 URL
///   - name: 订阅名称
-(void)addProtocol:(NSString *)protocol name:(NSString *)name;

/// 删除某个名称下的节点
/// - Parameters:
///   - protoccol: 节点
///   - name: 节点名称
-(void)deleteProtocol:(NSString *)protoccol name:(NSString *)name;

/// 删除某个协议下所有节点
/// - Parameter name: 节点名称
-(void)deleteName:(NSString *)name;

/// 获取所有节点
-(NSArray <NSString *> *)allProtocols;

/// 获取某一个订阅下面所有节点
/// - Parameter name: 订阅名称
-(NSArray <NSString *> *)allProtocols:(NSString *)name;

/// 获取所有订阅列表名称
-(NSArray <NSString *> *)allSubscriptions;

/// 向扩展进程发送活跃检查，DEBU 时使用
-(void)echo;


-(void)getStatistics:(YDGetStatisticsResponse) response;

/// 设置路由配置
//    [
//        {
//          "method": "direct",
//          "type": "ip",
//          "content": "192.168.9.3"
//        },
//        {
//          "method": "proxy",
//          "type": "domain",
//          "content": "www.baidu.com"
//        },
//        {
//          "method": "block",
//          "type": "ip",
//          "content": "192.168.9.3"
//        }
//    ]
/// - Parameter router: 路由配置
-(void)setRouterConfiguration:(nullable NSArray <NSDictionary *> *)router;

/// 下载测速
/// - Parameter progress: 下载速度统计
-(void)download:(YDDownloadProgress)progress;


/// 上传测速
/// - Parameter progress: 上传测速统计
-(void)upload:(YDUploadProgress)progress;

@end

// 下面节点是在扩展进程中调用的接口
@interface PDVPNManager (Extension)

/// 扩展进程调用，主进程不要调
/// - Parameter ips: url 列表
/// - Parameter type: 0 ICMP, 1 TCP
-(void)ping:(NSArray *)ips type:(int)type;

/// 扩展进程调用，主进程不要调
-(void)setupExtenstionApplication;

/// 获取 router
-(NSArray <NSDictionary *> *)getRouterConfiguration;
@end


NS_ASSUME_NONNULL_END
