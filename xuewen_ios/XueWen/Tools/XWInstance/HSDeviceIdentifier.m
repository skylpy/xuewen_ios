//
//  XQDeviceIdentifier.m
//  Xiaoqianr
//
//  Created by iOS李鹏 on 2017/6/6.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import "HSDeviceIdentifier.h"
#import "OpenUDID.h"
#import <SSKeychain/SSKeychain.h>

@implementation HSDeviceIdentifier

static void extracted(NSString **currentDeviceUUIDStr) {
    if (*currentDeviceUUIDStr == nil || [*currentDeviceUUIDStr isEqualToString:@""])
    {
        
        *currentDeviceUUIDStr = [OpenUDID value];
        [SSKeychain setPassword: [OpenUDID value] forService:@" "account:@"uuid"];
        
    }
}

+ (NSString *)getUniqueIdentifier
{
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@" "account:@"uuid"];
    extracted(&currentDeviceUUIDStr);
    return currentDeviceUUIDStr;
}

@end
