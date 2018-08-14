//
//  SelectCouponViewController.h
//  XueWen
//
//  Created by ShaJin on 2018/3/5.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 支付页面选择优惠券
#import "XWListViewController.h"
@class CouponModel;
@interface SelectCouponViewController : XWListViewController

- (instancetype)initWithPrice:(float)price completeBlock:(void (^)(NSString *coupons,float price))complete;

@end
