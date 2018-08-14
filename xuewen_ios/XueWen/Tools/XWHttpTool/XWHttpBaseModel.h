//
//  XWHttpBaseModel.h
//  XueWen
//
//  Created by Karron Su on 2018/5/4.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWHttpSessionManager.h"


/** 封装网络请求*/
@interface XWHttpBaseModel : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) id data;


/** GET请求 */
+ (void)BGET:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters success:(void (^)(XWHttpBaseModel *model))success failure:(void(^)(NSString *error))failure;
/** POST请求 */
+ (void)BPOST:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters success:(void (^)(XWHttpBaseModel *model))success failure:(void(^)(NSString *error))failure;
/** PUT请求 */
+ (void)BPUT:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters success:(void (^)(XWHttpBaseModel *model))success failure:(void(^)(NSString *error))failure;
/** DELETE请求 */
+ (void)BDELETE:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters success:(void (^)(XWHttpBaseModel *model))success failure:(void(^)(NSString *error))failure;

@end

@interface XWHttpModel : NSObject

@property (nonatomic, strong) NSString *perPage;
@property (nonatomic, strong) NSString *currentPage;
@property (nonatomic, strong) NSString *lastPage;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) id results;

@end

@interface XWHomeCourseModel : NSObject
// 热门课程
@property (nonatomic, strong) XWHttpModel *popularCourses;
// 近期上线
@property (nonatomic, strong) XWHttpModel *course;
// 热点资讯
@property (nonatomic, strong) XWHttpModel *article;
// 免费课程
@property (nonatomic, strong) XWCourseIndexModel *freeCourse;
// 重磅推荐
@property (nonatomic, strong) XWCourseIndexModel *hitCourse;

@end

