//
//  CouponModel.h
//  XueWen
//
//  Created by ShaJin on 2017/12/1.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
// 优惠券模型
#import <Foundation/Foundation.h>

@interface CouponModel : NSObject
/** 优惠券ID */
@property (nonatomic, strong) NSString *couponID;
/** 优惠券状态1未使用，2已使用 */
@property (nonatomic, strong) NSString *status;
/** 优惠券创建时间(开始时间) */
@property (nonatomic, strong) NSString *creatTime;
/** 优惠券使用时间（结束时间） */
@property (nonatomic, strong) NSString *useTime;
/** 优惠券名称 */
@property (nonatomic, strong) NSString *title;
/** 优惠券详情 */
@property (nonatomic, strong) NSString *describe;
/** 优惠券抵扣价格 */
@property (nonatomic, strong) NSString *price;
/** 优惠券有效期 */
@property (nonatomic, strong) NSString *validity;
/** 是否可以使用 */
@property (nonatomic, assign) BOOL canUse;
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

@end
