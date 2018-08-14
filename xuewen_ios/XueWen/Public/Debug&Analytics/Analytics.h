//
//  Analytics.h
//  XueWen
//
//  Created by ShaJin on 2018/3/26.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Analytics : NSObject
/** 自定义事件 */
+ (void)event:(NSString *)event label:(NSString *)label;

+ (void)event:(NSString *)event attributes:(NSDictionary *)attributes;
@end
