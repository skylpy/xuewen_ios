//
//  XWHttpTool.h
//  XueWen
//
//  Created by Karron Su on 2018/4/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWCourseIndexModel.h"
#import "XWCourseLabelModel.h"
#import "XWArticleContentModel.h"
#import "XWCoursInfoModel.h"
#import "XWExamHistoryModel.h"
#import "XWCompanyInfoModel.h"
#import "XWCountPlayTimeModel.h"
#import "XWTargetRankModel.h"

/**
 请求成功返回的数据

 @param array 数据源
 @param isLast 是否是最后一页
 */
typedef void(^XWSuccessBlock)(NSMutableArray *array, BOOL isLast);

/**
 请求失败

 @param errorInfo 失败信息
 */
typedef void(^XWFailureBlock)(NSString *errorInfo);
@interface XWHttpTool : NSObject

#pragma mark - 新版首页

/** 热门课程和近期上线*/
+ (void)getCourseIndexWithOrderType:(NSString *)order_type success:(XWSuccessBlock)success failure:(XWFailureBlock)failure;

/** 标签*/
+ (void)getCourseLabelSuccess:(XWSuccessBlock)success failure:(XWFailureBlock)failure;

/** 猜你喜欢*/
+ (void)getLickCourseWith:(NSString *)size isFirstLoad:(BOOL)isFirstLoad success:(XWSuccessBlock)success failure:(XWFailureBlock)failure;

/** 文章-获取列表*/
+ (void)getArticleListWithIsFirstLoad:(BOOL)isFirstLoad title:(NSString *)title success:(XWSuccessBlock)success failure:(XWFailureBlock)failure;

/** 文章-获取单个文章*/
+ (void)getArticleContentWith:(NSString *)articleId success:(void(^)(XWArticleContentModel *model))success failure:(XWFailureBlock)failure;

#pragma mark - 音频列表
/** 音频课程列表*/
+ (void)getAudioCoursesWithName:(NSString *)name isFirstLoad:(BOOL)isFirstLoad success:(XWSuccessBlock)success failure:(XWFailureBlock)failure;

#pragma mark - 课程详情

/** 查询一个课程详情*/
+ (void)getCourseDetailWithCourseID:(NSString *)courseID success:(void(^)(XWCoursInfoModel *infoModel))success failure:(XWFailureBlock)failure;

/** 查看单个课程下的笔记*/
+ (void)getCourseNotesWithCoursID:(NSString *)coursID status:(NSString *)status isFirstLoad:(BOOL)isFirstLoad success:(XWSuccessBlock)success failure:(XWFailureBlock)failure;

/** 单个课程下的讨论*/
+ (void)getCourseCommentWithCoursID:(NSString *)coursID isFirstLoad:(BOOL)isFirstLoad success:(XWSuccessBlock)success failure:(XWFailureBlock)failure;

/** 添加播放量*/
+ (void)postCouresNodePlayWithNodeId:(NSString *)nodeId;

#pragma mark - 商城跳转
/** 商城跳转链接*/
+ (void)getShopUrlSuccess:(void(^)(NSString *url))success failure:(XWFailureBlock)failure;

#pragma mark - 近期上线列表与热门课程更多
/** 近期上线列表与热门课程更多*/
+ (void)getNearFutureListWithIsFirstLoad:(BOOL)isFirstLoad orderType:(NSString *)orderType success:(XWSuccessBlock)success failure:(void(^)(NSString *error))failure popularOrder:(NSString *)popularOrder;

#pragma mark - 微信支付接口
/** 微信支付接口*/
+ (void)getWXParamterWithPrice:(NSInteger)price success:(void(^)(id result))success failure:(void(^)(NSString *error))failure;

#pragma mark - 考试相关
/** 考试历史记录*/
+ (void)getExamHistoryInfoWithCourseId:(NSString *)courseId success:(void(^)(XWExamHistoryModel *historyModel))success failure:(XWFailureBlock)failure;

/** 个人课程推荐*/
+ (void)getRecommendCourseWith:(NSString *)courseId success:(void(^)(NSMutableArray *array))success failure:(XWFailureBlock)failure;

#pragma mark - 商学院
/** 大家在学*/
+ (void)getLearningDataWithIsFirstLoad:(BOOL)isFirstLoad size:(NSString *)size success:(XWSuccessBlock)success failure:(XWFailureBlock)failure;

/** 企业课程列表*/
+ (void)getCompanyCourseWithIsFirstLoad:(BOOL)isFirstLoad size:(NSString *)size success:(XWSuccessBlock)success failure:(XWFailureBlock)failure;

/** 获取单个组织*/
+ (void)getCompanyInfoWithID:(NSString *)companyId success:(void(^)(XWCompanyInfoModel *infoModel))success failure:(XWFailureBlock)failure;

/** 商学院学习排名*/
+ (void)getCountPlayTimeWithOrderType:(NSString *)orderType isFirstLoad:(BOOL)isFirstLoad success:(void(^)(NSMutableArray *array, BOOL isLast, XWCountPlayTimeModel *rankModel))success failure:(XWFailureBlock)failure size:(NSString *)size;

/** 目标排名*/
+ (void)getTargetDataWith:(BOOL)isFirstLoad type:(NSString *)type success:(void(^)(NSMutableArray *array, BOOL isLast, XWTargetRankModel *rankModel))success failure:(XWFailureBlock)failure size:(NSString *)size;

/** 添加点赞量*/
+ (void)postFabulousWithUserID:(NSString *)userId fabulous:(NSString *)fabulous success:(void(^)(void))success failure:(XWFailureBlock)failure;

/** 学习时间播放量累加*/
+ (void)postStudyTimeWithTime:(NSInteger)time userID:(NSString *)userId success:(void(^)(void))success failure:(XWFailureBlock)failure;

/** 用户上传反馈*/
+ (void)postUserFeedBackWithMessage:(NSString *)message phone:(NSString *)phone img:(NSString *)img success:(void(^)(void))success failure:(void(^)(NSString *errorInfo))failure;

@end
