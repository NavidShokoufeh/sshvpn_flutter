//
//  CheckConnectData.m
//
//  Created by NavidShokoufeh on 1403-08-01.
//


#import "CheckConnectData.h"
#import "NodeModel.h"

@implementation CheckConnectData

+(NSDictionary*)checkConnectParmer:(NodeModel*)modal {
    if([modal.nodeName isEqualToString:@"SSH"]) {
        return @{@"type":@"sshtunnel",
                 @"username":modal.username,
                 @"password":modal.password,
                 @"address":modal.server,
                 @"port":modal.port,
                 @"allowInsecure":@(modal.TLS),
                 @"chap_enable":@(modal.CHAP),
                 @"pap_enable":@(modal.PAP),
                 @"mschap2_enable":@(modal.MSCHAP2),
                 @"udpgw":modal.udpgw,
                 @"udpgw_port":modal.udpgw_port,};
    }
    return @{};
}

+(NodeModel*)getModalForDic:(NSDictionary*)selectDic {
    if([selectDic[@"type"] isEqualToString:@"sshtunnel"]) {
        NodeModel * modal = [NodeModel new];
        modal.nodeName = @"SSH";
        modal.username =selectDic[@"username"];
        modal.password =selectDic[@"password"];
        modal.server =selectDic[@"address"];
        modal.port =selectDic[@"port"];
        modal.TLS =[selectDic[@"allowInsecure"] boolValue];
        modal.PAP =[selectDic[@"pap_enable"] boolValue];
        modal.CHAP =[selectDic[@"chap_enable"] boolValue];
        modal.MSCHAP2 =[selectDic[@"mschap2_enable"] boolValue];
        modal.udpgw =selectDic[@"udpgw"];
        modal.udpgw_port =selectDic[@"udpgw_port"];
        return modal;
        
    }
    return NodeModel.new;
}

@end
