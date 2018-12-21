//
//  XWCompanyBackModel.h
//  XueWen
//
//  Created by aaron on 2018/12/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWHttpBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XWCompanyBackModel : NSObject

//订单管理
+ (void)getPurchaseRecord:(NSInteger)page
                  success:(void(^)(NSArray * list))success
                  failure:(void(^)(NSString *error))failure;

//交易明细
+ (void)getTransactionRecordType:(NSString *)type
                            Page:(NSInteger)page
                         success:(void(^)(NSArray * list))success
                         failure:(void(^)(NSString *error))failure;

//优惠券
+ (void)getCouponListWithType:(NSString *)type
                      success:(void(^)(NSArray * list))success
                      failure:(void(^)(NSString *error))failure;

@end

@interface XWCompanyOrderModel : NSObject

@property (nonatomic, copy) NSString *Id;
/** 订单编号 */
@property (nonatomic, copy) NSString *orderID;
/** 订单课程编号 */
@property (nonatomic, copy) NSString *courseID;
/** 订单课程名称 */
@property (nonatomic, copy) NSString *courseName;
/** 订单课程封面 */
@property (nonatomic, copy) NSString *coverPhoto;
/** 下单时间 */
@property (nonatomic, copy) NSString *creatTime;
/** 订单金额 */
@property (nonatomic, copy) NSString *orderPrice;
/** 实付金额 */
@property (nonatomic, copy) NSString *price;
/** 订单状态 */
@property (nonatomic, copy) NSString *status;
/** 下单人昵称 */
@property (nonatomic, copy) NSString *nickName;
/** 下单人ID */
@property (nonatomic, copy) NSString *userID;
/** 订单类型 0课程1专题3超能组织*/
@property (nonatomic, copy) NSString *type;
/** 订单内容（课程信息||专题信息） */
@property (nonatomic, strong) id purchaseInfo;
/** 专题ID*/
@property (nonatomic, copy) NSString *collegeID;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, copy) NSString * orderAmount;
@property (nonatomic, copy) NSString * updateTime;

@property (nonatomic, copy) NSString * usePrice;


@end

@interface XWRecordModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userGold;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *givingName;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *payTypeName;

@end

NS_ASSUME_NONNULL_END
