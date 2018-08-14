//
//  Analytics.m
//  XueWen
//
//  Created by ShaJin on 2018/3/26.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "Analytics.h"
#import <UMAnalytics/MobClick.h>
@implementation Analytics
/** 自定义事件 */
+ (void)event:(NSString *)event label:(NSString *)label{
    [MobClick event:event label:label];
}

+ (void)event:(NSString *)event attributes:(NSDictionary *)attributes{
    [MobClick event:event attributes:attributes];
}
@end
