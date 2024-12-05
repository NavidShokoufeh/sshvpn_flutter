//
//  NWRunLoop.h
//  xsocks
//
//  Created by badwin on 2023/12/20.
//

#import <Foundation/Foundation.h>
#import <openconnect/SSProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface NWRunLoop : NSObject
+(instancetype)currentRunLoop;

/// 当前工作线程队列，可以外部提供
@property (nonatomic, strong)dispatch_queue_t worker;

/// VMESS 协议信息
@property (nonatomic, strong, readonly)SSProtocol *protocol;

/// 设置 GEOIP 数据库地址
/// - Parameter geoip: 数据库地址
+(void)setup:(nullable NSString *)geoip;

/// 设置服务器支持协议
/// - Parameter protocol: 协议名称
-(void)setup:(SSProtocol *)protocol;

/// 查询某个 IP 是否属于中国
/// - Parameter ip: IP 地址
-(BOOL)lookup:(char *)ip;

@end

NS_ASSUME_NONNULL_END
