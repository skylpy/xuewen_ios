//
//  XWHttpBaseModel.m
//  XueWen
//
//  Created by Karron Su on 2018/5/4.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHttpBaseModel.h"

@implementation XWHttpBaseModel

/** GET请求 */
+ (void)BGET:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters success:(void (^)(XWHttpBaseModel *))success failure:(void (^)(NSString *))failure{
    [XWHttpSessionManager GET:URLString parameters:parameters extra:extraParamters completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        [self handleresponseJson:responseJson statusCode:statusCode success:success failure:failure];
    }];
}

/** POST请求 */
+ (void)BPOST:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters success:(void (^)(XWHttpBaseModel *))success failure:(void (^)(NSString *))failure{
    [XWHttpSessionManager POST:URLString parameters:parameters extra:extraParamters completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        [self handleresponseJson:responseJson statusCode:statusCode success:success failure:failure];
    }];
}

/** PUT请求 */
+ (void)BPUT:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters success:(void (^)(XWHttpBaseModel *))success failure:(void (^)(NSString *))failure{
    [XWHttpSessionManager PUT:URLString parameters:parameters extra:extraParamters completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        [self handleresponseJson:responseJson statusCode:statusCode success:success failure:failure];
    }];
}

/** DELETE请求 */
+ (void)BDELETE:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters success:(void (^)(XWHttpBaseModel *))success failure:(void (^)(NSString *))failure{
    [XWHttpSessionManager DELETE:URLString parameters:parameters extra:extraParamters completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        [self handleresponseJson:responseJson statusCode:statusCode success:success failure:failure];
    }];
}

/** 数据统一处理*/
+ (void)handleresponseJson:(id)responseJson statusCode:(NSInteger)status success:(void(^)(XWHttpBaseModel *))success failure:(void(^)(NSString *))failure {
    XWHttpBaseModel *model = [XWHttpBaseModel modelWithJSON:responseJson];
    if (status == 200) {
        !success ? : success(model);
    }else{
        !failure ? : failure(model.message);
    }
}

@end

@implementation XWHttpModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"perPage" : @"per_page",
             @"currentPage" : @"current_page",
             @"lastPage" : @"last_page",
             @"results" : @"data"
             };
}

@end

@implementation XWHomeCourseModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"popularCourses" : @"popular_courses",
             @"course" : @"new_course",
             @"freeCourse" : @"free_course",
             @"hitCourse" : @"hit_course"
             };
}

@end


