//
//  PDParserSSTP.h
//  ExtParser
//
//  Created by badwin on 2024/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDParserGeneral : NSObject

+(nullable NSDictionary *)parse:(NSString *)uri protocol:(NSString *)protocol;

+(nullable NSDictionary *)parse:(NSString *)url;

+(void)setLogLevel:(NSString *)level;
@end

NS_ASSUME_NONNULL_END
