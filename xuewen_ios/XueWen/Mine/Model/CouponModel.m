//
//  CouponModel.m
//  XueWen
//
//  Created by ShaJin on 2017/12/1.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
// 优惠券模型
#import "CouponModel.h"

@implementation CouponModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"couponID"    : @"id",
             @"status"      : @"coupon_status",
             @"creatTime"   : @"create_time",
             @"useTime"     : @"coupon_validity_time",
             @"title"       : @"coupon_name",
             @"describe"    : @"coupon_desc",
             @"price"       : @"coupon_amount",
             @"validity"    : @"validity_time"
             };
}

- (void)setCreatTime:(NSString *)creatTime{
    _creatTime = [NSDate dateFormTimestamp:creatTime withFormat:@"yyyy.MM.dd"];
}

- (void)setUseTime:(NSString *)useTime{
    _useTime = [NSDate dateFormTimestamp:useTime withFormat:@"yyyy.MM.dd"];
}

- (void)setStatus:(NSString *)status{
    _status = status;
    _canUse = ([status isEqualToString:@"1"] || [status isEqualToString:@"2"]);
}

@end
/**
 "id": 1645,
 "user_id": 84,
 "coupon_id": 37,
 "coupon_name": "30元",
 "coupon_desc": "全场抵用 不限次数 用完即止",
 "coupon_price": "30.00",
 "coupon_amount": "30.00",
 "coupon_status": 1,
 "create_time": 1520385316,
 "coupon_validity_time": 1522977316,
 "giving_id": 0,
 "day": 30
 */
