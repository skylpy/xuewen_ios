//
//  XWDiscountModel.h
//  XueWen
//
//  Created by Karron Su on 2018/12/15.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWDiscountModel : NSObject

/** 优惠券id*/
@property (nonatomic, strong) NSString *couponId;
/** 用户id*/
@property (nonatomic, strong) NSString *user_id;
/** 剩余金额*/
@property (nonatomic, strong) NSString *coupon_amount;
/** 总金额*/
@property (nonatomic, strong) NSString *coupon_price;
/** 描述*/
@property (nonatomic, strong) NSString *coupon_desc;
/** 名称*/
@property (nonatomic, strong) NSString *coupon_name;
/** 是否能使用*/
@property (nonatomic, strong) NSString *coupon_status;
/** 有效期*/
@property (nonatomic, strong) NSString *coupon_validity_time;
/** 是否选中*/
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
