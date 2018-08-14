//
//  XWHttpTool.m
//  XueWen
//
//  Created by Karron Su on 2018/4/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHttpTool.h"
#import "XWHttpSessionManager.h"
#import "XWArticleModel.h"
#import "XWHttpBaseModel.h"
#import "XWAudioCoursModel.h"
#import "XWNotesModel.h"
#import "XWCommentModel.h"
#import "XWRecommendCourseModel.h"
#import "XWLearningModel.h"
#import "XWCompanyCoursModel.h"
#import "XWCountPlayTimeModel.h"

#define PageSize  @"10"
static NSInteger page = 1;
static NSInteger commentPage = 1;
static NSInteger nearPage = 1;
static NSInteger lickPage = 1;
static NSInteger learnPage = 1;
static NSInteger CompanyCoursePage = 1;
static NSInteger CountPlayTimePage = 1;
static NSInteger TargetPage = 1;

@implementation XWHttpTool

#pragma mark - 新版首页

/** 近期上线和热门课程*/
+ (void)getCourseIndexWithOrderType:(NSString *)order_type success:(XWSuccessBlock)success failure:(XWFailureBlock)failure {
    ParmDict
    [dict setValue:order_type forKey:@"order_type"];
    
    NSString *size = [[NSString alloc] init];
    if ([order_type isEqualToString:@"3"]) {
        size = @"3";
    }else{
        size = @"2";
    }
    
    [dict setValue:size forKey:@"size"];
    
    [XWHttpBaseModel BGET:BASE_URL(CourseIndex) parameters:dict extra:kPrintParamters success:^(XWHttpBaseModel *model) {
        XWHomeCourseModel *hModle = [XWHomeCourseModel modelWithJSON:model.data];
        // 热门课程
        NSArray *popular = [NSArray modelArrayWithClass:[XWCourseIndexModel class] json:hModle.popularCourses.results];
        // 近期上线
        NSArray *newCourse = [NSArray modelArrayWithClass:[XWCourseIndexModel class] json:hModle.course.results];
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        if (popular == nil) {
            popular = [[NSArray alloc] init];
        }
        if (hModle.freeCourse == nil) {
            hModle.freeCourse = [[XWCourseIndexModel alloc] init];
        }
        if (hModle.hitCourse == nil) {
            hModle.hitCourse = [[XWCourseIndexModel alloc] init];
        }
        if ([order_type isEqualToString:@"3"]) { // 最新版首页返回的数据
            // 免费课程
            [dataArray addObject:hModle.freeCourse];
            [dataArray addObject:popular];
            [dataArray addObject:hModle.hitCourse];
            [dataArray addObject:newCourse];
        }else{ // 老首页返回的数据
            // 热点资讯
            NSArray *article = [NSArray modelArrayWithClass:[XWArticleModel class] json:hModle.article.results];
            
            [dataArray addObject:popular];
            [dataArray addObject:newCourse];
            [dataArray addObject:article];
        }
        !success ? : success(dataArray, YES);
    } failure:failure];
}

/** 标签*/
+ (void)getCourseLabelSuccess:(XWSuccessBlock)success failure:(XWFailureBlock)failure {
    [XWHttpBaseModel BGET:BASE_URL(CourseLabel) parameters:nil extra:kPrintParamters success:^(XWHttpBaseModel *model) {
        NSArray *array = [NSArray modelArrayWithClass:[XWCourseLabelModel class] json:model.data];
        !success ? : success([array mutableCopy], YES);
    } failure:failure];
}

/** 猜你喜欢*/
+ (void)getLickCourseWith:(NSString *)size isFirstLoad:(BOOL)isFirstLoad success:(XWSuccessBlock)success failure:(XWFailureBlock)failure {
    ParmDict
    [dict setValue:size forKey:@"size"];
    [dict setValue:@"3" forKey:@"order_type"];
    
    if (isFirstLoad) {
        lickPage = 1;
    }else{
        lickPage++;
    }
    [dict setValue:@(lickPage) forKey:@"page"];
    
    [XWHttpBaseModel BGET:BASE_URL(LickCourse) parameters:dict extra:kPrintParamters success:^(XWHttpBaseModel *model) {
        XWHttpModel *bModel = [XWHttpModel modelWithJSON:model.data];
        NSArray *array = [NSArray modelArrayWithClass:[XWCourseIndexModel class] json:bModel.results];
        NSInteger currentPage = [bModel.currentPage integerValue];
        NSInteger lastPage = [bModel.lastPage integerValue];
        BOOL isLast = currentPage >= lastPage ? YES : NO;
        !success ? : success([array mutableCopy], isLast);
    } failure:failure];

}

/** 文章-获取列表*/
+ (void)getArticleListWithIsFirstLoad:(BOOL)isFirstLoad title:(NSString *)title success:(XWSuccessBlock)success failure:(XWFailureBlock)failure{
    ParmDict
    [dict setValue:PageSize forKey:@"size"];
    [dict setValue:title forKey:@"title"];
    if (isFirstLoad) {
        page = 1;
    }else{
        page++;
    }
    [dict setValue:@(page) forKey:@"page"];
    
    [XWHttpBaseModel BGET:BASE_URL(Article) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWHttpModel *bModel = [XWHttpModel modelWithJSON:model.data];
        NSArray *data = [NSArray modelArrayWithClass:[XWArticleContentModel class] json:bModel.results];
        NSInteger currentPage = [bModel.currentPage integerValue];
        NSInteger lastPage = [bModel.lastPage integerValue];
        !success ? : success([data mutableCopy], currentPage >= lastPage);
    } failure:failure];
    
}

/** 文章-获取单个文章*/
+ (void)getArticleContentWith:(NSString *)articleId success:(void (^)(XWArticleContentModel *))success failure:(XWFailureBlock)failure{
    [XWHttpBaseModel BGET:kBASE_URL(Article, articleId) parameters:nil extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWArticleContentModel *contentModel = [XWArticleContentModel modelWithJSON:model.data];
        !success ? : success(contentModel);
    } failure:failure];
}

#pragma mark - 音频列表

/** 音频课程列表*/
+ (void)getAudioCoursesWithName:(NSString *)name isFirstLoad:(BOOL)isFirstLoad success:(XWSuccessBlock)success failure:(XWFailureBlock)failure{
    ParmDict
    if (isFirstLoad) {
        page = 1;
    }else{
        page ++;
    }
    [dict setValue:PageSize forKey:@"size"];
    [dict setValue:@(page) forKey:@"page"];
    [dict setValue:name forKey:@"name"];
    [XWHttpBaseModel BGET:BASE_URL(AudioCourse) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWHttpModel *bModel = [XWHttpModel modelWithJSON:model.data];
        NSInteger currentPage = [bModel.currentPage integerValue];
        NSInteger lastPage = [bModel.lastPage integerValue];
        NSMutableArray *array = [[NSArray modelArrayWithClass:[XWAudioCoursModel class] json:bModel.results] mutableCopy];
        !success ? :  success(array, currentPage >= lastPage);
    } failure:failure];
}

#pragma mark - 课程详情

/** 查询一个课程详情*/
+ (void)getCourseDetailWithCourseID:(NSString *)courseID success:(void (^)(XWCoursInfoModel *))success failure:(XWFailureBlock)failure{
    
    [XWHttpBaseModel BGET:kBASE_URL(Cours, courseID) parameters:nil extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWCoursInfoModel *infoModel = [XWCoursInfoModel modelWithJSON:model.data];
        !success ? : success(infoModel);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 查看单个课程下的笔记*/
+ (void)getCourseNotesWithCoursID:(NSString *)coursID status:(NSString *)status isFirstLoad:(BOOL)isFirstLoad success:(XWSuccessBlock)success failure:(XWFailureBlock)failure{
    if (isFirstLoad) {
        page = 1;
    }else{
        page ++;
    }
    
    ParmDict
    [dict setValue:@(page) forKey:@"page"];
    [dict setValue:PageSize forKey:@"size"];
    [dict setValue:status forKey:@"status"];
    [XWHttpBaseModel BGET:kBASE_URL(CourseNotes, coursID) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWHttpModel *bModel = [XWHttpModel modelWithJSON:model.data];
        NSInteger currentPage = [bModel.currentPage integerValue];
        NSInteger lastPage = [bModel.lastPage integerValue];
        NSMutableArray *array = [[NSArray modelArrayWithClass:[XWNotesModel class] json:bModel.results] mutableCopy];
        !success ? : success(array, currentPage>=lastPage);
    } failure:failure];
}

/** 单个课程下的讨论*/
+ (void)getCourseCommentWithCoursID:(NSString *)coursID isFirstLoad:(BOOL)isFirstLoad success:(XWSuccessBlock)success failure:(XWFailureBlock)failure{
    if (isFirstLoad) {
        commentPage = 1;
    }else{
        commentPage ++;
    }
    ParmDict
    [dict setValue:@(commentPage) forKey:@"page"];
    [dict setValue:PageSize forKey:@"size"];
    
    [XWHttpBaseModel BGET:kBASE_URL(CoursCommon, coursID) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWHttpModel *bModel = [XWHttpModel modelWithJSON:model.data];
        NSInteger currentPage = [bModel.currentPage integerValue];
        NSInteger lastPage = [bModel.lastPage integerValue];
        NSMutableArray *array = [[NSArray modelArrayWithClass:[XWCommentModel class] json:bModel.results] mutableCopy];
        !success ? : success(array, currentPage>=lastPage);
    } failure:failure];
}

+ (void)postCouresNodePlayWithNodeId:(NSString *)nodeId{
    ParmDict
    [dict setValue:nodeId forKey:@"node_id"];
    [XWHttpBaseModel BPOST:BASE_URL(PlayCourseNodePlay) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark - 商城跳转链接

+ (void)getShopUrlSuccess:(void (^)(NSString *))success failure:(XWFailureBlock)failure{
    [XWHttpBaseModel BGET:BASE_URL(GetShopJump) parameters:nil extra:kPrintParamters success:^(XWHttpBaseModel *model) {
        !success ? : success(model.data[@"url"]);
    } failure:failure];
}

#pragma mark - 近期上线列表

+ (void)getNearFutureListWithIsFirstLoad:(BOOL)isFirstLoad orderType:(NSString *)orderType success:(XWSuccessBlock)success failure:(void (^)(NSString *))failure popularOrder:(NSString *)popularOrder{
    if (isFirstLoad) {
        nearPage = 1;
    }else{
        nearPage ++;
    }
    ParmDict
    [dict setValue:orderType forKey:@"order_type"];
    [dict setValue:@"10" forKey:@"size"];
    [dict setValue:@(nearPage) forKey:@"page"];
//    if (![popularOrder isEqualToString:@""] && popularOrder != nil) {
//        [dict setValue:popularOrder forKey:@"popular_order"];
//    }
    
    
    [XWHttpBaseModel BGET:BASE_URL(CourseIndex) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWHttpModel *httpModel = [XWHttpModel modelWithJSON:model.data];
        NSInteger currentPage = [httpModel.currentPage integerValue];
        NSInteger lastPage = [httpModel.lastPage integerValue];
        BOOL isLast = currentPage >= lastPage ? YES : NO;
        NSMutableArray *array = [[NSArray modelArrayWithClass:[XWCourseIndexModel class] json:httpModel.results] mutableCopy];
        !success ? : success(array, isLast);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

#pragma mark - 微信支付
+ (void)getWXParamterWithPrice:(NSInteger)price success:(void (^)(id))success failure:(void (^)(NSString *))failure{
    ParmDict
    [dict setObject:[NSNumber numberWithInteger:price * 100] forKey:@"total_fee"];
    [dict setObject:[NSString stringWithFormat:@"微信充值%ld元",(long)price] forKey:@"body"];
    [dict setObject:@"wechat" forKey:@"pay"];
    [dict setObject:@"app" forKey:@"trade_type"];
    
    [XWHttpBaseModel BPOST:BASE_URL(GetPayOrder) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        !success ? : success(model.data);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

#pragma mark - 考试相关
/** 考试历史记录*/
+ (void)getExamHistoryInfoWithCourseId:(NSString *)courseId success:(void (^)(XWExamHistoryModel *))success failure:(XWFailureBlock)failure{
    [XWHttpBaseModel BGET:kBASE_URL(GetHistoryInfo, courseId) parameters:nil extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWExamHistoryModel *hisModel = [XWExamHistoryModel modelWithJSON:model.data];
        !success ? : success(hisModel);
    } failure:failure];
}

/** 个人课程标签*/
+ (void)getRecommendCourseWith:(NSString *)courseId success:(void (^)(NSMutableArray *))success failure:(XWFailureBlock)failure{
    ParmDict
    [dict setValue:@(10) forKey:@"size"];
    [XWHttpBaseModel BGET:kBASE_URL(RecommendCourse, courseId) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWHttpModel *httpModel = [XWHttpModel modelWithJSON:model.data];
        NSArray *dataArray = [NSArray modelArrayWithClass:[XWRecommendCourseModel class] json:httpModel.results];
        !success ? : success([dataArray mutableCopy]);
    } failure:failure];
}

#pragma mark - 商学院
/** 大家在学*/
+ (void)getLearningDataWithIsFirstLoad:(BOOL)isFirstLoad size:(NSString *)size success:(XWSuccessBlock)success failure:(XWFailureBlock)failure{
    if (isFirstLoad) {
        learnPage = 1;
    }else{
        learnPage++;
    }
    ParmDict
    [dict setValue:size forKey:@"size"];
    [dict setValue:@(learnPage) forKey:@"page"];
    
    [XWHttpBaseModel BGET:BASE_URL(GetLearning) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWHttpModel *httpModel = [XWHttpModel modelWithJSON:model.data];
        NSInteger currentPage = [httpModel.currentPage integerValue];
        NSInteger lastPage = [httpModel.lastPage integerValue];
        NSArray *dataArray = [NSArray modelArrayWithClass:[XWLearningModel class] json:httpModel.results];
        !success ? : success([dataArray mutableCopy], currentPage>=lastPage);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 企业课程列表*/
+ (void)getCompanyCourseWithIsFirstLoad:(BOOL)isFirstLoad size:(NSString *)size success:(XWSuccessBlock)success failure:(XWFailureBlock)failure{
    if (isFirstLoad) {
        CompanyCoursePage = 1;
    }else{
        CompanyCoursePage++;
    }
    ParmDict
    [dict setValue:size forKey:@"size"];
    [dict setValue:@(CompanyCoursePage) forKey:@"page"];
    [XWHttpBaseModel BGET:BASE_URL(CompanyCourse) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWHttpModel *httpModel = [XWHttpModel modelWithJSON:model.data];
        NSInteger currentPage = [httpModel.currentPage integerValue];
        NSInteger lastPage = [httpModel.lastPage integerValue];
        NSArray *dataArray = [NSArray modelArrayWithClass:[XWCompanyCoursModel class] json:httpModel.results];
        !success ? : success([dataArray mutableCopy], currentPage>=lastPage);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 获取单个组织*/
+ (void)getCompanyInfoWithID:(NSString *)companyId success:(void (^)(XWCompanyInfoModel *))success failure:(XWFailureBlock)failure{
    
    [XWHttpBaseModel BGET:kBASE_URL(CompanyInfo, companyId) parameters:nil extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWCompanyInfoModel *infoModel = [XWCompanyInfoModel modelWithJSON:model.data];
        !success ? : success(infoModel);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 商学院学习排名*/
+ (void)getCountPlayTimeWithOrderType:(NSString *)orderType isFirstLoad:(BOOL)isFirstLoad success:(void (^)(NSMutableArray *, BOOL,  XWCountPlayTimeModel*))success failure:(XWFailureBlock)failure size:(NSString *)size{
    if (isFirstLoad) {
        CountPlayTimePage = 1;
    }else{
        CountPlayTimePage++;
    }
    ParmDict
    [dict setValue:orderType forKey:@"order_type"];
    [dict setValue:size forKey:@"size"];
    [dict setValue:@(CountPlayTimePage) forKey:@"page"];
    
    [XWHttpBaseModel BGET:BASE_URL(Countplaytime) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
//        NSLog(@"data is %@", model.data);
        XWHttpModel *httpModel = [XWHttpModel modelWithJSON:model.data[@"all_user"]];
        NSInteger currentPage = [httpModel.currentPage integerValue];
        NSInteger lastPage = [httpModel.lastPage integerValue];
        NSArray *dataArray = [NSArray modelArrayWithClass:[XWCountPlayTimeModel class] json:httpModel.results];
        XWCountPlayTimeModel *rankModel = [XWCountPlayTimeModel modelWithJSON:model.data[@"mine"]];
       
        !success ? : success([dataArray mutableCopy], currentPage>=lastPage, rankModel);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 目标排名*/
+ (void)getTargetDataWith:(BOOL)isFirstLoad type:(NSString *)type success:(void (^)(NSMutableArray *, BOOL, XWTargetRankModel *))success failure:(XWFailureBlock)failure size:(NSString *)size{
    if (isFirstLoad) {
        TargetPage = 1;
    }else{
        TargetPage++;
    }
    
    ParmDict
    [dict setValue:type forKey:@"type"];
    [dict setValue:size forKey:@"size"];
    [dict setValue:@(TargetPage) forKey:@"page"];
    [XWHttpBaseModel BGET:BASE_URL(GetTargetData) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
//        NSLog(@"data is %@", model.data);
        XWHttpModel *httpModel = [XWHttpModel modelWithJSON:model.data[@"admin_user"]];
        NSInteger currentPage = [httpModel.currentPage integerValue];
        NSInteger lastPage = [httpModel.lastPage integerValue];
        NSArray *dataArray = [NSArray modelArrayWithClass:[XWTargetRankModel class] json:httpModel.results];
        XWTargetRankModel *rankModel = [XWTargetRankModel modelWithJSON:model.data[@"user"]];
        !success ? : success([dataArray mutableCopy], currentPage >= lastPage, rankModel);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 添加点赞量*/
+ (void)postFabulousWithUserID:(NSString *)userId fabulous:(NSString *)fabulous success:(void (^)(void))success failure:(XWFailureBlock)failure{
    ParmDict
    [dict setValue:userId forKey:@"user_id"];
    [dict setValue:fabulous forKey:@"fabulous"];
    
    [XWHttpBaseModel BPOST:BASE_URL(PostFabulous) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
    
}

/** 学习时间播放量累加*/
+ (void)postStudyTimeWithTime:(NSInteger)time userID:(NSString *)userId success:(void (^)(void))success failure:(XWFailureBlock)failure{
    ParmDict
    
    [dict setValue:@(time*1000) forKey:@"study_time"];
    [dict setValue:userId forKey:@"user_id"];
    [XWHttpBaseModel BPOST:BASE_URL(CountPlayTime) parameters:dict extra:kPrintParamters success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 用户上传反馈*/
+ (void)postUserFeedBackWithMessage:(NSString *)message phone:(NSString *)phone img:(NSString *)img success:(void (^)(void))success failure:(void (^)(NSString *))failure{
    ParmDict
    [dict setValue:phone forKey:@"phone"];
    [dict setValue:message forKey:@"message"];
    [dict setValue:img forKey:@"img_url"];
    
    [XWHttpBaseModel BPOST:BASE_URL(UserFeedback) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}















@end
