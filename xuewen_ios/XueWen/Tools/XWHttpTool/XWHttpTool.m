//
//  XWHttpTool.m
//  XueWen
//
//  Created by Karron Su on 2018/4/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHttpTool.h"
#import "XWHttpSessionManager.h"
#import "XWHttpBaseModel.h"
#import "XWAudioCoursModel.h"
#import "XWNotesModel.h"
#import "XWCommentModel.h"
#import "XWRecommendCourseModel.h"
#import "XWLearningModel.h"
#import "XWCompanyCoursModel.h"
#import "XWCountPlayTimeModel.h"
#import "XWIncomeModel.h"
#import "XWTransactionListModel.h"
#import "XWTransactionRecordModel.h"
#import "XWOrgManagerModel.h"
#import "XWDepartmentListModel.h"
#import "XWStaffInfoModel.h"
#import "XWLabelModel.h"
#import "XWDiscountModel.h"

#define PageSize  @"10"
static NSInteger page = 1;
static NSInteger commentPage = 1;
static NSInteger nearPage = 1;
static NSInteger lickPage = 1;
static NSInteger learnPage = 1;
static NSInteger CompanyCoursePage = 1;
static NSInteger CountPlayTimePage = 1;
static NSInteger TargetPage = 1;
static NSInteger incomePage = 1;
static NSInteger TransactionPage = 1;
static NSInteger OrgPage = 1;
@implementation XWHttpTool

#pragma mark - 新版首页

/** 近期上线和热门课程*/
+ (void)getCourseIndexWithOrderType:(NSString *)order_type success:(void (^)(NSMutableArray *, BOOL, NSMutableArray *))success failure:(XWFailureBlock)failure {
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
        NSArray *labelArray = [NSArray modelArrayWithClass:[XWCourseLabelModel class] json:model.data[@"thematic_name"]];
        if ([order_type isEqualToString:@"3"]) { // 最新版首页返回的数据
            // 免费课程
            [dataArray addObject:hModle.freeCourse];
            [dataArray addObject:popular];
            [dataArray addObject:hModle.hitCourse];
            [dataArray addObject:newCourse];
        }
        !success ? : success(dataArray, YES, [labelArray mutableCopy]);
    } failure:failure];
}

/** 标签*/
+ (void)getCourseLabelSuccess:(XWSuccessBlock)success failure:(XWFailureBlock)failure {
    [XWHttpBaseModel BGET:BASE_URL(CourseLabel) parameters:nil extra:kPrintParamters success:^(XWHttpBaseModel *model) {
        NSArray *array = [NSArray modelArrayWithClass:[XWCourseLabelModel class] json:model.data];
        !success ? : success([array mutableCopy], YES);
    } failure:failure];
}

/** 为你推荐*/
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
    
    [XWHttpBaseModel BGET:kBASE_URL(Cours, courseID) parameters:nil extra:0 success:^(XWHttpBaseModel *model) {
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
    [XWHttpBaseModel BPOST:BASE_URL(PlayCourseNodePlay) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        
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
    if (![popularOrder isEqualToString:@""] && popularOrder != nil) {
        [dict setValue:popularOrder forKey:@"popular_order"];
    }
    
    
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
+ (void)getRecommendCourseWith:(NSString *)courseId withTestId:(NSString *)testId withT:(BOOL)isTest success:(void (^)(NSMutableArray *))success failure:(XWFailureBlock)failure{
    NSString * atid = isTest?testId:@"0";
    ParmDict
    [dict setValue:@"10" forKey:@"size"];
    [dict setValue:atid forKey:@"a_t_id"];
    [XWHttpBaseModel BGET:kBASE_URL(RecommendCourse, courseId) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        XWHttpModel *httpModel = [XWHttpModel modelWithJSON:model.data];
        NSArray *dataArray = [NSArray modelArrayWithClass:[XWRecommendCourseModel class] json:httpModel.results];
        !success ? : success([dataArray mutableCopy]);
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark - 商学院
/** 大家在学*/
+ (void)getLearningDataWithIsFirstLoad:(BOOL)isFirstLoad size:(NSString *)size success:(XWSuccessBlock)success failure:(XWFailureBlock)failure companyId:(NSString *)companyId{
    if (isFirstLoad) {
        learnPage = 1;
    }else{
        learnPage++;
    }
    ParmDict
    [dict setValue:size forKey:@"size"];
    [dict setValue:@(learnPage) forKey:@"page"];
    [dict setValue:companyId forKey:@"company_id"];
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
+ (void)getCompanyCourseWithIsFirstLoad:(BOOL)isFirstLoad size:(NSString *)size success:(XWSuccessBlock)success failure:(XWFailureBlock)failure companyId:(NSString *)companyId{
    if (isFirstLoad) {
        CompanyCoursePage = 1;
    }else{
        CompanyCoursePage++;
    }
    ParmDict
    [dict setValue:size forKey:@"size"];
    [dict setValue:@(CompanyCoursePage) forKey:@"page"];
    [dict setValue:companyId forKey:@"company_id"];
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
+ (void)getCountPlayTimeWithOrderType:(NSString *)orderType isFirstLoad:(BOOL)isFirstLoad success:(void (^)(NSMutableArray *, BOOL,  XWCountPlayTimeModel*))success failure:(XWFailureBlock)failure size:(NSString *)size companyId:(NSString *)companyId{
    if (isFirstLoad) {
        CountPlayTimePage = 1;
    }else{
        CountPlayTimePage++;
    }
    ParmDict
    [dict setValue:orderType forKey:@"order_type"];
    [dict setValue:size forKey:@"size"];
    [dict setValue:@(CountPlayTimePage) forKey:@"page"];
    [dict setValue:companyId forKey:@"company_id"];
    
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
+ (void)getTargetDataWith:(BOOL)isFirstLoad type:(NSString *)type success:(void (^)(NSMutableArray *, BOOL, XWTargetRankModel *))success failure:(XWFailureBlock)failure size:(NSString *)size companyId:(NSString *)companyId{
    if (isFirstLoad) {
        TargetPage = 1;
    }else{
        TargetPage++;
    }
    
    ParmDict
    [dict setValue:type forKey:@"type"];
    [dict setValue:size forKey:@"size"];
    [dict setValue:@(TargetPage) forKey:@"page"];
    [dict setValue:companyId forKey:@"company_id"];
    
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

/** 获取商学院名称*/
+ (void)getCollegeName{
    [XWHttpBaseModel BGET:BASE_URL(CollegeName) parameters:nil extra:0 success:^(XWHttpBaseModel *model) {
        NSLog(@"collegeName is %@", model.data[@"college_name"]);
        [XWInstance shareInstance].collegeName = model.data[@"college_name"];
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark - 红包提现相关

/** 红包收益与佣金收益*/
+ (void)getBonusesEarningsWithType:(NSString *)type isFirstLoad:(BOOL)isFirstLoad date:(NSString *)date success:(void (^)(NSMutableArray *, BOOL, NSString *))success failure:(XWFailureBlock)failure{
    if (isFirstLoad) {
        incomePage = 1;
    }else{
        incomePage ++;
    }
    
    ParmDict
    [dict setValue:type forKey:@"type"];
    [dict setValue:PageSize forKey:@"size"];
    [dict setValue:@(incomePage) forKey:@"page"];
    [dict setValue:date forKey:@"years"];
    
    [XWHttpBaseModel BGET:BASE_URL(BonusesEarnings) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        NSString *key;
        if ([type isEqualToString:@"2"]) {
            key = @"commission_record";
        }else{
            key = @"bonusesrecord";
        }
        XWHttpModel *httpModel = [XWHttpModel modelWithJSON:model.data[key]];
        NSArray *array = [NSArray modelArrayWithClass:[XWIncomeModel class] json:httpModel.results];
        NSString *earnings = model.data[@"price"];
        !success ? : success([array mutableCopy], [httpModel.currentPage integerValue] >= [httpModel.lastPage integerValue], earnings);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 提现记录*/
+ (void)getMyTransactionListWithIsFirstLoad:(BOOL)isFirstLoad success:(XWSuccessBlock)success failure:(XWFailureBlock)failure{
    ParmDict
    if (isFirstLoad) {
        TransactionPage = 1;
    }else{
        TransactionPage ++;
    }
    [dict setValue:PageSize forKey:@"size"];
    [dict setValue:@(TransactionPage) forKey:@"page"];
    [XWHttpBaseModel BGET:BASE_URL(MyTransactionList) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        XWHttpModel *http = [XWHttpModel modelWithJSON:model.data];
        NSArray *array = [NSArray modelArrayWithClass:[XWTransactionListModel class] json:http.results];
        !success ? : success([array mutableCopy], [http.currentPage integerValue] >= [http.lastPage integerValue]);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 获取提现账号跟可提现金额*/
+ (void)getPayeeAccountSuccess:(void (^)(NSString *, NSString *))success failure:(XWFailureBlock)failure{
    [XWHttpBaseModel BGET:BASE_URL(GetPayeeAccount) parameters:nil extra:0 success:^(XWHttpBaseModel *model) {
        !success ? : success(model.data[@"bonuses_price"], model.data[@"payee_account"]);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 生成提现订单/提交提现申请*/
+ (void)createTransactionRecordWithPrice:(NSString *)price success:(void (^)(XWTransactionRecordModel *))success failure:(XWFailureBlock)failure{
    ParmDict
    [dict setValue:price forKey:@"price"];
    
    [XWHttpBaseModel BPOST:BASE_URL(CreateTransactionRecord) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        XWTransactionRecordModel *record = [XWTransactionRecordModel modelWithJSON:model.data];
        !success ? : success(record);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 绑定支付宝账号*/
+ (void)bindingAccountWithAccount:(NSString *)account realName:(NSString *)realName success:(void (^)(void))success failure:(XWFailureBlock)failure{
    ParmDict
    [dict setValue:account forKey:@"payee_account"];
    [dict setValue:realName forKey:@"real_name"];
    [XWHttpBaseModel BPOST:BASE_URL(BindingAccount) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 首页测一测和强推学院*/
+ (void)getJobCollegeSuccess:(void (^)(NSString *, NSMutableArray *))success failure:(XWFailureBlock)failure{
    [XWHttpBaseModel BGET:BASE_URL(GetJobCollege) parameters:nil extra:0 success:^(XWHttpBaseModel *model) {
        NSArray *dataSource = [NSArray modelArrayWithClass:[XWCourseLabelModel class] json:model.data[@"college"]];
        NSString *picture = model.data[@"job"][0][@"picture"];
        !success ? : success(picture, [dataSource mutableCopy]);
    } failure:failure];
}

/** 测一测推荐课程*/
+ (void)getTestRecommendCourseWithTestId:(NSString *)testId success:(XWSuccessBlock)success failure:(XWFailureBlock)failure{
    ParmDict
    [dict setValue:testId forKey:@"test_id"];
    [dict setValue:@"10" forKey:@"size"];
    [dict setValue:@"1" forKey:@"page"];
    
    [XWHttpBaseModel BGET:BASE_URL(GetRecommendCourse) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        XWHttpModel *httpModel = [XWHttpModel modelWithJSON:model.data];
        NSArray *dataArray = [NSArray modelArrayWithClass:[XWRecommendCourseModel class] json:httpModel.results];
        !success ? : success([dataArray mutableCopy], YES);
    } failure:failure];
}

#pragma mark - 轮播图管理
+ (void)addShufflingFigureWithPictureUrl:(NSString *)pictureUrl pictureLink:(NSString *)pictureLink success:(void (^)(void))success failure:(void (^)(NSString *))failure {
    
    ParmDict
    [dict setValue:@"2" forKey:@"type"];
    [dict setValue:@"1" forKey:@"picture_sort"];
    [dict setValue:pictureUrl forKey:@"picture_url"];
    if (pictureLink != nil && ![pictureLink isEqualToString:@""]) {
        [dict setValue:pictureLink forKey:@"picture_link"];
    }
    
    [XWHttpBaseModel BPOST:BASE_URL(ShufflingFigure) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 单个修改轮播图*/
+ (void)putShufflingFigureWithPictureUrl:(NSString *)pictureUrl pictureLink:(NSString *)pictureLink pictureSort:(NSString *)pictureSort bannerId:(NSString *)bannerId success:(void (^)(void))success failure:(void (^)(NSString *))failure {
    ParmDict
    [dict setValue:@"2" forKey:@"type"];
    [dict setValue:pictureSort forKey:@"picture_sort"];
    [dict setValue:pictureUrl forKey:@"picture_url"];
    [dict setValue:pictureLink forKey:@"picture_link"];

    [XWHttpBaseModel BPUT:kBASE_URL(FigurePut, bannerId) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

#pragma mark - 组织管理
/** 组织管理 - 账号列表*/
+ (void)getAdminUserListWithCompanyId:(NSString *)companyId success:(void (^)(NSMutableArray *))success failure:(void (^)(NSString *))failure {
    ParmDict
    [dict setValue:companyId forKey:@"company_id"];
    [dict setValue:@"1" forKey:@"page"];
    [dict setValue:@"999" forKey:@"size"];
    [XWHttpBaseModel BGET:BASE_URL(AccountInfo) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        XWHttpModel *http = [XWHttpModel modelWithJSON:model.data];
        NSArray *array = [NSArray modelArrayWithClass:[XWOrgManagerModel class] json:http.results];
        !success ? : success([array mutableCopy]);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 搜索账号*/
+ (void)searchAdminUserWithName:(NSString *)name success:(void (^)(NSMutableArray *, BOOL))success failure:(void (^)(NSString *))failure isFirstLoad:(BOOL)isFirstLoad {
    ParmDict
    [dict setValue:name forKey:@"name"];
    [dict setValue:@"10" forKey:@"size"];
    [dict setValue:kUserInfo.company_id forKey:@"company_id"];
    
    if (isFirstLoad) {
        OrgPage = 1;
    }else {
        OrgPage ++;
    }
    [dict setValue:@(OrgPage) forKey:@"page"];
    
    [XWHttpBaseModel BGET:BASE_URL(AccountInfo) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        XWHttpModel *http = [XWHttpModel modelWithJSON:model.data];
        NSArray *array = [NSArray modelArrayWithClass:[XWOrgManagerModel class] json:http.results];
        !success ? : success([array mutableCopy], [http.currentPage integerValue] >= [http.lastPage integerValue]);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 查询公司组织*/
+ (void)getCompanyDepartmentWithCompanyID:(NSString *)companyId dId:(NSString *)dId success:(void (^)(XWDepartmentListModel *))success failure:(void (^)(NSString *))failure {
    ParmDict
    [dict setValue:companyId forKey:@"id"];
    [dict setValue:dId forKey:@"d_id"];
    
    [XWHttpBaseModel BGET:BASE_URL(CompanyDepartment) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        XWDepartmentListModel *data = [XWDepartmentListModel modelWithJSON:model.data];
        !success ? : success(data);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 添加组织*/
+ (void)addDepartmentWithName:(NSString *)name pid:(NSString *)pid success:(void (^)(void))success failure:(void (^)(NSString *))failure {
    ParmDict
    [dict setValue:name forKey:@"department_name"];
    [dict setValue:pid forKey:@"pid"];
    
    [XWHttpBaseModel BPOST:BASE_URL(CompanyDepartment1) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 删除组织*/
+ (void)deleteDepartmentWithId:(NSString *)oid success:(void (^)(void))success failure:(void (^)(NSString *))failure {
    
    [XWHttpBaseModel BDELETE:kBASE_URL(CompanyDepartment1, oid) parameters:nil extra:0 success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 修改组织*/
+ (void)changeDepartmentWithId:(NSString *)oid name:(NSString *)name success:(void (^)(void))success failure:(void (^)(NSString *))failure {
    ParmDict
    [dict setValue:name forKey:@"department_name"];
    
    [XWHttpBaseModel BPUT:kBASE_URL(CompanyDepartment1, oid) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? :failure(error);
    }];
}

/** 员工详情*/
+ (void)getStaffInfoWithUserId:(NSString *)userId success:(void (^)(XWStaffInfoModel *))success failure:(void (^)(NSString *))failure {
    
    [XWHttpBaseModel BGET:kBASE_URL(AccountInfo, userId) parameters:nil extra:0 success:^(XWHttpBaseModel *model) {
        XWStaffInfoModel *data = [XWStaffInfoModel modelWithJSON:model.data];
        !success ? : success(data);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 课程标签*/
+ (void)getLabelListWithLabelId:(NSString *)labelId success:(void (^)(NSMutableArray *))success failure:(void (^)(NSString *))failure {
    ParmDict
    [dict setObject:labelId forKey:@"label_id"];
    
    [XWHttpBaseModel BGET:BASE_URL(CoursLabel) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        NSArray *array = [NSArray modelArrayWithClass:[XWLabelModel class] json:model.data[@"children"]];
        !success ? : success([array mutableCopy]);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 创建子用户*/
+ (void)createUserWithName:(NSString *)name password:(NSString *)password phone:(NSString *)phone departmentId:(NSString *)departmentId lableId:(NSString *)lableId post:(NSString *)post success:(void (^)(void))success failure:(void (^)(NSString *))failure {
    ParmDict
    [dict setValue:name forKey:@"name"];
    [dict setValue:password forKey:@"password"];
    [dict setValue:phone forKey:@"phone"];
    [dict setValue:departmentId forKey:@"department_id"];
    [dict setValue:lableId forKey:@"lable_id"];
    [dict setValue:kUserInfo.company_id forKey:@"company_id"];
    [dict setValue:post forKey:@"post"];
    
    [XWHttpBaseModel BPOST:BASE_URL(AccountInfo) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 更新账号数据*/
+ (void)updateUserInfoWithKey:(NSString *)key value:(NSString *)value userId:(NSString *)userId success:(void (^)(void))success failure:(void (^)(NSString *))failure {
    ParmDict
    [dict setValue:value forKey:key];
    
    [XWHttpBaseModel BPUT:kBASE_URL(AccountInfo, userId) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 赠送金币*/
+ (void)giveGoldWithToUserId:(NSString *)toUserId gold:(NSString *)gold success:(void (^)(void))success failure:(void (^)(NSString *))failure {
    ParmDict
    [dict setValue:toUserId forKey:@"to_user_id"];
    [dict setValue:gold forKey:@"gold"];
    [dict setValue:kUserInfo.company_id forKey:@"company_id"];
    
    [XWHttpBaseModel BPOST:BASE_URL(GiveGold) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
    
}

/** 优惠券列表*/
+ (void)getDiscountListSuccess:(void (^)(NSMutableArray *))success failure:(void (^)(NSString *))failure {
    ParmDict
    [dict setValue:kUserInfo.company_id forKey:@"company_id"];
    [dict setValue:@"1" forKey:@"type"];
    [dict setValue:@"15" forKey:@"size"];
    
    [XWHttpBaseModel BGET:BASE_URL(UserCoupon) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        NSArray *dataSource = [NSArray modelArrayWithClass:[XWDiscountModel class] json:model.data[@"data"]];
        !success ? : success([dataSource mutableCopy]);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
    
}

/** 赠送优惠券*/
+ (void)giveCouponWithUserID:(NSString *)userId couponId:(NSString *)couponId couponPrice:(NSString *)couponPrice success:(void (^)(void))success failure:(void (^)(NSString *))failure {
    ParmDict
    [dict setValue:userId forKey:@"user_id"];
    [dict setValue:couponId forKey:@"coupon_id"];
    [dict setValue:couponPrice forKey:@"coupon_price"];
    
    [XWHttpBaseModel BPOST:BASE_URL(CompanyCoupon) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        !success ? : success();
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

/** 获取部门列表*/
+ (void)getDepartmentListWithCompanyId:(NSString *)companyId did:(NSString *)did success:(void (^)(XWDepartmentModel *))success failure:(void (^)(NSString *))failure {
    ParmDict
    [dict setValue:companyId forKey:@"id"];
    [dict setValue:did forKey:@"d_id"];
    [XWHttpBaseModel BGET:BASE_URL(CompanyDepartment1) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        NSArray *array = [NSArray modelArrayWithClass:[XWDepartmentModel class] json:model.data];
        XWDepartmentModel *department = [array firstObject];
        !success ? : success(department);
    } failure:^(NSString *error) {
        !failure ? : failure(error);
    }];
}

@end
