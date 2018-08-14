//
//  CommonModel.m
//  XueWen
//
//  Created by ShaJin on 2017/11/28.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "CommonModel.h"
/** 评论列表 */ 
@implementation CommonModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"nickName"    : @"nick_name",
             @"creatTime"   : @"create_time",
             @"picture"     : @"picture_all",
             };
}

- (void)setCreatTime:(NSString *)creatTime{
    _creatTime = [creatTime translateDateFormatter:@"yyyy-MM-dd"];
}
@end
