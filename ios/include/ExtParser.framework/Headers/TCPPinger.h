//
//  MMTCPPinger.h
//  TCPPing
//
//  Created by badwin on 2023/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TCPPinger : NSObject

/// 节点探测
/// - Parameters:
///   - node: 节点域名或 IP
///   - port: 监听端口
///   - count: 节点数
- (int)ping:(NSString *)node port:(int)port count:(int)count;

/// 是否有效 IP
/// - Parameter ipStr: IP 字符串
+ (BOOL)isValidIP:(NSString *)ipStr;


+ (NSString *)LookupIP:(NSString *)domain;

@end

NS_ASSUME_NONNULL_END
