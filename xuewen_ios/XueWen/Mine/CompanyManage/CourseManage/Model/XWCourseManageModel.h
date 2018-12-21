//
//  XWCourseManageModel.h
//  XueWen
//
//  Created by aaron on 2018/12/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWHttpBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class XWColProfileModel;
@interface XWCourseManageModel : NSObject

@property (nonatomic,copy) NSString * Id;
@property (nonatomic,copy) NSString * uid;
@property (nonatomic,copy) NSString * ucompanyid;
@property (nonatomic,copy) NSString * coverphoto;
@property (nonatomic,copy) NSString * coverphotoall;
@property (nonatomic,copy) NSString * coursename;
@property (nonatomic,copy) NSString * tchorg;
@property (nonatomic,copy) NSString * timelength;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * favorableprice;
@property (nonatomic,copy) NSString * introduction;
@property (nonatomic,copy) NSString * tchorgphoto;
@property (nonatomic,copy) NSString * tchorgintroduction;
@property (nonatomic,copy) NSString * total;
@property (nonatomic,copy) NSString * createtime;
@property (nonatomic,copy) NSString * expirytime;
@property (nonatomic,copy) NSString * percentage;
@property (nonatomic,copy) NSString * amount;
@property (nonatomic,copy) NSString * courseId;

//是否收藏（0：没收藏 1：收藏)
@property (nonatomic,copy) NSString * type;

//全部价格
@property (nonatomic,assign) CGFloat allprice;

//选择收藏
@property (nonatomic,assign) BOOL isSelect;

//订单ID
@property (nonatomic,copy) NSString * order_id;
//订单数
@property (nonatomic,copy) NSString * p_people_num;
//总数
@property (nonatomic,assign) NSInteger people_count;

//已购课程
+ (void)courseManagePage:(NSInteger)page
                 success:(void(^)(NSArray * list))success
                 failure:(void(^)(NSString *error))failure;

//收藏课程
+ (void)favoriteCourseManagePage:(NSInteger)page
                         success:(void(^)(NSArray * list))success
                         failure:(void(^)(NSString *error))failure;

//课程库
+ (void)courseLibraryPage:(NSInteger)page
                     Name:(NSString *)name
                      Lid:(NSString *)lid
                  success:(void(^)(NSArray * list))success
                  failure:(void(^)(NSString *error))failure;

//添加收藏
+ (void)addFavoriteCourseManageCourseId:(NSString *)courseId
                                success:(void(^)(void))success
                                failure:(void(^)(NSString *error))failure ;

//添加订单
+ (void)addOrderCourseId:(NSString *)courseId
                 success:(void(^)(NSDictionary * dic))success
                 failure:(void(^)(NSString *error))failure;

//支付订单
+ (void)orderCourseId:(NSString *)courseId
             couponId:(NSString *)couponId
              success:(void(^)(NSString *suc))success
              failure:(void(^)(NSString *error))failure;

//确认订单
+ (void)sureOrderID:(NSString *)orderId
           couponId:(NSString *)coupon_id
             course:(NSArray *)course
            success:(void(^)(NSString *suc))success
            failure:(void(^)(NSString *error))failure;

//订单详情
+ (void)orderDateilOrderID:(NSString *)orderId
                   success:(void(^)(NSDictionary * dic))success
                   failure:(void(^)(NSString *error))failure;

@end

@interface XWCollectionModel : NSObject

@property (nonatomic,copy) NSString * Id;
@property (nonatomic,copy) NSString * userid;
@property (nonatomic,copy) NSString * courseid;
@property (nonatomic,copy) NSString * type;

@property (nonatomic,copy) XWColProfileModel * profile;

@end

@interface XWColProfileModel : NSObject

@property (nonatomic,copy) NSString * Id;
@property (nonatomic,copy) NSString * userid;
@property (nonatomic,copy) NSString * coursename;
@property (nonatomic,copy) NSString * timelength;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * favorableprice;
@property (nonatomic,copy) NSString * coverphoto;
@property (nonatomic,copy) NSString * coverphotothumb;
@property (nonatomic,copy) NSString * introduction;
@property (nonatomic,copy) NSString * tchorg;
@property (nonatomic,copy) NSString * tchorgphoto;
@property (nonatomic,copy) NSString * tchorgintroduction;
@property (nonatomic,copy) NSString * createtime;

@end

NS_ASSUME_NONNULL_END
