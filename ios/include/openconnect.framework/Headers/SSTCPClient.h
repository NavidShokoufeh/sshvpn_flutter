//
//  SSClient.h
//  xsocks
//
//  Created by badwin on 2023/11/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SSClientStateIDLE = 0,
    SSClientStateConnecting,
    SSClientStateConnected,
    SSClientStateDisconnected,
} SSClientState;

// 表示 App 发送的数据包使用什么协议传输
typedef enum : NSUInteger {
    SSProtocolTypeTCP,
    SSProtocolTypeUDP,
    SSProtocolTypeICMP,
} SSProtocolType;

@class SSTCPClient;
@class SSProtocol;

@protocol SSClientDelegate <NSObject>

/// 接收到消息内容
/// - Parameters:
///   - client: TCP 客户端
///   - message: 消息内容
///   - length: 消息长度
-(void)tcpClient:(SSTCPClient *)client didReceiveMessage:(uint8_t *)message length:(int)length;

/// 收到客户端状态变化事件
/// - Parameters:
///   - client: TCP 客户端
///   - state: 连接状态
-(void)tcpClient:(SSTCPClient *)client didChangeState:(SSClientState)state;
@end


@interface SSTCPClient : NSObject

/// 当前客户端引用计数
@property (nonatomic, class, readonly)long long refCount;

/// 连接的真实服务器地址
@property (nonatomic, strong, readonly)NSString *target;

/// 连接的真实服务器端口
@property (nonatomic, readonly)int port;

@property (nonatomic, readonly)SSProtocolType proto;

/// 使用什么代理协议，如果是 direct 的话为空
@property (nonatomic, strong, readonly, nullable)SSProtocol *protocol;

/// 客户端标签
@property (nonatomic, strong)NSString *tag;

/// 当前连接状态
@property (nonatomic)SSClientState sstate;

/// 客户端代理
@property (nonatomic, weak)id<SSClientDelegate> delegate;

/// 初始化 VMESS 客户端
/// - Parameters:
///   - target: 连接目标服务器
///   - port: 连接目标服务器端口
///   - proto: 连接协议，支持 TCP 和 UDP，默认创建 IPv4 协议
-(instancetype)initWithTarget:(NSString *)target port:(int)port proto:(SSProtocolType)proto;

/// 初始化 VMESS 客户端
/// - Parameters:
///   - target: 连接目标服务器
///   - port: 连接目标服务器端口
///   - proto: 连接协议，支持 TCP 和 UDP
///   - family: IPv4, IPv6 协议，AF_INET, AF_INET6
-(instancetype)initWithTarget:(NSString *)target port:(int)port proto:(SSProtocolType)proto family:(int)family;

/// 发送二进制数据
/// - Parameters:
///   - message: 二进制数据内容
///   - length: 内存长度
-(BOOL)sendMessage:(uint8_t *)message length:(int)length;

/// 获取当前连接的证书
/// - Parameters:
///   - certificate: 证书内容
///   - length: 证书长度
///   - evp: 0 是 sha1， 1 是 sha256
-(void)getCertificate:(uint8_t *)certificate length:(int *)length evp:(int)evp;

/// 关闭连接，注意是真实关闭连接，如果还有数据正在发送中或者接受中，可能会丢失数据
-(void)close;

/// 打开链接
-(void)connect;

/// 通过外部定时器检查是否超时
-(void)checkTimeout;
@end

NS_ASSUME_NONNULL_END
