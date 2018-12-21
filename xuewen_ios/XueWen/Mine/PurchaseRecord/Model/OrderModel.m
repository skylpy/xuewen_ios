//
//  OrderModel.m
//  XueWen
//
//  Created by ShaJin on 2017/12/19.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"orderID"     : @"order_id",
             @"courseName"  : @"course_name",
             @"creatTime"   : @"update_time",
             @"nickName"    : @"nick_name",
             @"userID"      : @"user_id",
             @"courseID"    : @"course_id",
             @"coverPhoto"  : @"cover_photo_all",
             @"type"        : @"purchase_type",
             @"orderPrice"  : @"order_price",
             @"collegeID"  : @"college_id",
             };
}

- (void)setCreatTime:(NSString *)creatTime{
    _creatTime = [creatTime stringWithDataFormatter:nil];
}
@end
