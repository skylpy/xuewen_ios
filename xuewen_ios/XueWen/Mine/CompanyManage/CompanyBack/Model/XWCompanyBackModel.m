//
//  XWCompanyBackModel.m
//  XueWen
//
//  Created by aaron on 2018/12/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCompanyBackModel.h"

@implementation XWCompanyBackModel

//订单管理
+ (void)getPurchaseRecord:(NSInteger)page
                  success:(void(^)(NSArray * list))success
                  failure:(void(^)(NSString *error))failure{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(15) forKey:@"size"];
    [dic setValue:[XWInstance shareInstance].userInfo.company_id forKey:@"company_id"];
    
    [XWHttpBaseModel BGET:BASE_URL(PurchaseRecord) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        NSArray * arr = [NSArray modelArrayWithClass:[XWCompanyOrderModel class] json:model.data[@"data"]];
        !success?:success(arr);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

//交易明细
+ (void)getTransactionRecordType:(NSString *)type
                            Page:(NSInteger)page
                         success:(void(^)(NSArray * list))success
                         failure:(void(^)(NSString *error))failure{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:type forKey:@"type"];
    [dic setValue:@(15) forKey:@"size"];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:[XWInstance shareInstance].userInfo.company_id forKey:@"company_id"];
    
    [XWHttpBaseModel BGET:BASE_URL(TransactionRecord) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        NSArray * arr = [NSArray modelArrayWithClass:[XWRecordModel class] json:model.data[@"data"]];
        !success?:success(arr);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

//优惠券
+ (void)getCouponListWithType:(NSString *)type
                      success:(void(^)(NSArray * list))success
                      failure:(void(^)(NSString *error))failure {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:type forKey:@"type"];
    [dic setValue:[XWInstance shareInstance].userInfo.company_id forKey:@"company_id"];
    
    [XWHttpBaseModel BGET:BASE_URL(UserCoupon) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        NSArray *coupons = [CouponModel mj_objectArrayWithKeyValuesArray:model.data[@"data"]];

        !success?:success(coupons);

    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

@end

@implementation XWCompanyOrderModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"Id":@"id",
             @"orderID"     : @"order_id",
             @"courseName"  : @"course_name",
             @"creatTime"   : @"create_time",
             @"nickName"    : @"nick_name",
             @"userID"      : @"user_id",
             @"courseID"    : @"course_id",
             @"coverPhoto"  : @"cover_photo_all",
             @"type"        : @"purchase_type",
             @"orderPrice"  : @"order_price",
             @"orderAmount"  : @"order_amount",
             @"updateTime"  : @"update_time",
             @"status"  : @"status",
             @"usePrice"  : @"use_price",
             @"couponId"  : @"coupon_id"
             };
}

@end

@implementation XWRecordModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"Id":@"id",
             @"orderID"     : @"order_id",
             @"type"  : @"type",
             @"body"   : @"body",
             @"price"    : @"price",
             @"createTime"      : @"create_time",
             @"payType"    : @"pay_type",
             @"userId"  : @"user_id",
             @"nickName"        : @"nick_name",
             @"userGold"  : @"user_gold",
             @"state"  : @"state",
             @"givingName":@"giving_name",
             @"typeName":@"type_name",
             @"payTypeName":@"pay_type_name"
             };
}

@end
