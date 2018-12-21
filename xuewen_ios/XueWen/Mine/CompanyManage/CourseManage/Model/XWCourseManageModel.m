//
//  XWCourseManageModel.m
//  XueWen
//
//  Created by aaron on 2018/12/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCourseManageModel.h"

@implementation XWCourseManageModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"Id"      : @"id",
             @"uid"      : @"u_id",
             @"ucompanyid"     : @"u_company_id",
             @"coverphoto"      : @"cover_photo",
             @"coverphotoall"   : @"cover_photo_all",
             @"coursename"    : @"course_name",
             @"tchorg"   : @"tch_org",
             @"timelength"   : @"time_length",
             @"price"    : @"price",
             @"favorableprice"   : @"favorable_price",
             @"introduction"   : @"introduction",
             @"tchorgphoto"    : @"tch_org_photo",
             @"tchorgintroduction"   : @"tch_org_introduction",
             @"total"   : @"total",
             @"createtime"    : @"create_time",
             @"expirytime"   : @"expiry_time",
             @"percentage"    : @"Percentage",
             @"amount"   : @"amount",
             @"courseId" : @"course_id"
             };
}

//添加订单
+ (void)addOrderCourseId:(NSString *)courseId
                 success:(void(^)(NSDictionary * dic))success
                 failure:(void(^)(NSString *error))failure {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:courseId forKey:@"course_id"];
    [dic setValue:[XWInstance shareInstance].userInfo.company_id forKey:@"company_id"];
    
    [XWHttpBaseModel BPOST:BASE_URL(PurchaseRecord) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        !success?:success(model.data);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

//支付订单
+ (void)orderCourseId:(NSString *)courseId
             couponId:(NSString *)couponId
              success:(void(^)(NSString *suc))success
              failure:(void(^)(NSString *error))failure{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:courseId forKey:@"order_id"];
    [dic setValue:couponId forKey:@"coupon_id"];
    [dic setValue:[XWInstance shareInstance].userInfo.company_id forKey:@"company_id"];
    
    [XWHttpBaseModel BPOST:BASE_URL(pricePCPay) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        !success?:success(@"suc");
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

//确认订单
+ (void)sureOrderID:(NSString *)orderId
           couponId:(NSString *)coupon_id
             course:(NSArray *)course
            success:(void(^)(NSString *suc))success
            failure:(void(^)(NSString *error))failure{
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:course options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:coupon_id forKey:@"coupon_id"];
    [dic setValue:jsonStr forKey:@"course"];
//    [dic setValue:[XWInstance shareInstance].userInfo.company_id forKey:@"company_id"];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BASE_URL(CancelOrder),orderId];
    
    [XWHttpBaseModel BPUT:urlString parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        !success?:success(model.data[@"gold"]);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

//已购课程
+ (void)courseManagePage:(NSInteger)page
                 success:(void(^)(NSArray * list))success
                 failure:(void(^)(NSString *error))failure {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(15) forKey:@"size"];
    [dic setValue:[XWInstance shareInstance].userInfo.company_id forKey:@"company_id"];
    
    [XWHttpBaseModel BGET:BASE_URL(UserCourse) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        NSArray * arr = [NSArray modelArrayWithClass:[XWCourseManageModel class] json:model.data[@"data"]];
        !success?:success(arr);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

//订单详情
+ (void)orderDateilOrderID:(NSString *)orderId
                   success:(void(^)(NSDictionary * dic))success
                   failure:(void(^)(NSString *error))failure {
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BASE_URL(CancelOrder),orderId];
    
    [XWHttpBaseModel BGET:urlString parameters:nil extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        !success?:success(model.data);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

//课程库
+ (void)courseLibraryPage:(NSInteger)page
                     Name:(NSString *)name
                      Lid:(NSString *)lid
                  success:(void(^)(NSArray * list))success
                  failure:(void(^)(NSString *error))failure {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(15) forKey:@"size"];
    [dic setValue:name forKey:@"name"];
    [dic setValue:lid forKey:@"id"];
    
    [XWHttpBaseModel BGET:BASE_URL(Cours) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        NSArray * arr = [NSArray modelArrayWithClass:[XWCourseManageModel class] json:model.data[@"data"]];
        !success?:success(arr);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

//收藏课程
+ (void)favoriteCourseManagePage:(NSInteger)page
                         success:(void(^)(NSArray * list))success
                         failure:(void(^)(NSString *error))failure {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(15) forKey:@"size"];
    [dic setValue:[XWInstance shareInstance].userInfo.company_id forKey:@"company_id"];
    
    [XWHttpBaseModel BGET:BASE_URL(FavoriteCourse) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        NSArray * arr = [NSArray modelArrayWithClass:[XWCourseManageModel class] json:model.data[@"data"]];
        !success?:success(arr);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

//添加收藏
+ (void)addFavoriteCourseManageCourseId:(NSString *)courseId
                                success:(void(^)(void))success
                                failure:(void(^)(NSString *error))failure {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:courseId forKey:@"course_id"];
    [dic setValue:[XWInstance shareInstance].userInfo.company_id forKey:@"company_id"];
    
    [XWHttpBaseModel BPOST:BASE_URL(addFavorite) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        !success?:success();
    } failure:^(NSString *error) {
        !failure?:failure(error);
    }];
}

@end

@implementation XWCollectionModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"Id"      : @"id",
             @"userid"      : @"user_id",
             @"courseid"     : @"course_id",
             @"type"      : @"type",
             @"profile"   : @"profile"
             
             };
}

@end

@implementation XWColProfileModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"Id"      : @"id",
             @"userid"      : @"user_id",
             @"coursename"     : @"course_name",
             @"timelength"      : @"time_length",
             @"price"   : @"price",
             @"favorableprice"    : @"favorable_price",
             @"coverphoto"   : @"cover_photo",
             @"coverphotothumb"   : @"cover_photo_thumb",
             @"introduction"    : @"introduction",
             @"tchorg"   : @"tch_org",
             @"tchorgphoto"   : @"tch_org_photo",
             @"tchorgintroduction"    : @"tch_org_introduction",
             @"createtime"   : @"create_time"
            
             };
}

@end
