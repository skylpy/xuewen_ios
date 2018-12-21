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
#import "XWCoursInfoModel.h"
#import "XWExamHistoryModel.h"
#import "XWCompanyInfoModel.h"
#import "XWCountPlayTimeModel.h"
#import "XWTargetRankModel.h"
@class XWTransactionRecordModel;
@class XWDepartmentListModel;
@class XWStaffInfoModel;
@class XWDepartmentModel;

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
+ (void)getCourseIndexWithOrderType:(NSString *)order_type success:(void(^)(NSMutableArray *array, BOOL isLast, NSMutableArray *labelArray))success failure:(XWFailureBlock)failure;

/** 标签*/
+ (void)getCourseLabelSuccess:(XWSuccessBlock)success failure:(XWFailureBlock)failure;

/** 猜你喜欢*/
+ (void)getLickCourseWith:(NSString *)size isFirstLoad:(BOOL)isFirstLoad success:(XWSuccessBlock)success failure:(XWFailureBlock)failure;



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
+ (void)getRecommendCourseWith:(NSString *)courseId withTestId:(NSString *)testId withT:(BOOL)isTest success:(void (^)(NSMutableArray *))success failure:(XWFailureBlock)failure;

#pragma mark - 商学院
/** 大家在学*/
+ (void)getLearningDataWithIsFirstLoad:(BOOL)isFirstLoad size:(NSString *)size success:(XWSuccessBlock)success failure:(XWFailureBlock)failure companyId:(NSString *)companyId;

/** 企业课程列表*/
+ (void)getCompanyCourseWithIsFirstLoad:(BOOL)isFirstLoad size:(NSString *)size success:(XWSuccessBlock)success failure:(XWFailureBlock)failure companyId:(NSString *)companyId;

/** 获取单个组织*/
+ (void)getCompanyInfoWithID:(NSString *)companyId success:(void(^)(XWCompanyInfoModel *infoModel))success failure:(XWFailureBlock)failure;

/** 商学院学习排名*/
+ (void)getCountPlayTimeWithOrderType:(NSString *)orderType isFirstLoad:(BOOL)isFirstLoad success:(void(^)(NSMutableArray *array, BOOL isLast, XWCountPlayTimeModel *rankModel))success failure:(XWFailureBlock)failure size:(NSString *)size companyId:(NSString *)companyId;

/** 目标排名*/
+ (void)getTargetDataWith:(BOOL)isFirstLoad type:(NSString *)type success:(void(^)(NSMutableArray *array, BOOL isLast, XWTargetRankModel *rankModel))success failure:(XWFailureBlock)failure size:(NSString *)size companyId:(NSString *)companyId;

/** 添加点赞量*/
+ (void)postFabulousWithUserID:(NSString *)userId fabulous:(NSString *)fabulous success:(void(^)(void))success failure:(XWFailureBlock)failure;

/** 学习时间播放量累加*/
+ (void)postStudyTimeWithTime:(NSInteger)time userID:(NSString *)userId success:(void(^)(void))success failure:(XWFailureBlock)failure;

/** 用户上传反馈*/
+ (void)postUserFeedBackWithMessage:(NSString *)message phone:(NSString *)phone img:(NSString *)img success:(void(^)(void))success failure:(void(^)(NSString *errorInfo))failure;

/** 获取商学院名称*/
+ (void)getCollegeName;

#pragma mark - 红包提现相关
/** 红包收益与佣金收益*/
+ (void)getBonusesEarningsWithType:(NSString *)type isFirstLoad:(BOOL)isFirstLoad date:(NSString *)date success:(void(^)(NSMutableArray *array, BOOL isLast, NSString *earnings))success failure:(XWFailureBlock)failure;

/** 提现记录*/
+ (void)getMyTransactionListWithIsFirstLoad:(BOOL)isFirstLoad success:(XWSuccessBlock)success failure:(XWFailureBlock)failure;

/** 获取提现账号跟可提现金额*/
+ (void)getPayeeAccountSuccess:(void(^)(NSString *bonusesPrice, NSString *payeeAccount))success failure:(XWFailureBlock)failure;

/** 生成提现订单/提交提现申请*/
+ (void)createTransactionRecordWithPrice:(NSString *)price success:(void(^)(XWTransactionRecordModel *model))success failure:(XWFailureBlock)failure;

/** 绑定支付宝账号*/
+ (void)bindingAccountWithAccount:(NSString *)account realName:(NSString *)realName success:(void(^)(void))success failure:(XWFailureBlock)failure;

/** 首页测一测和强推学院*/
+ (void)getJobCollegeSuccess:(void(^)(NSString *testPic, NSMutableArray *array))success failure:(XWFailureBlock)failure;

/** 测一测推荐课程*/
+ (void)getTestRecommendCourseWithTestId:(NSString *)testId success:(XWSuccessBlock)success failure:(XWFailureBlock)failure;

#pragma mark - 轮播图管理
/** 添加轮播图*/
+ (void)addShufflingFigureWithPictureUrl:(NSString *)pictureUrl pictureLink:(NSString *)pictureLink success:(void(^)(void))success failure:(void(^)(NSString *error))failure;

/** 单个修改轮播图*/
+ (void)putShufflingFigureWithPictureUrl:(NSString *)pictureUrl pictureLink:(NSString *)pictureLink pictureSort:(NSString *)pictureSort bannerId:(NSString *)bannerId success:(void(^)(void))success failure:(void(^)(NSString *error))failure;

#pragma mark - 组织管理
/** 组织管理 - 账号列表*/
+ (void)getAdminUserListWithCompanyId:(NSString *)companyId success:(void(^)(NSMutableArray *dataSource))success failure:(void(^)(NSString *error))failure;

/** 搜索账号*/
+ (void)searchAdminUserWithName:(NSString *)name success:(void(^)(NSMutableArray *dataSource, BOOL isLast))success failure:(void(^)(NSString *error))failure isFirstLoad:(BOOL)isFirstLoad;

/** 查询公司组织*/
+ (void)getCompanyDepartmentWithCompanyID:(NSString *)companyId dId:(NSString *)dId success:(void(^)(XWDepartmentListModel *dataModel))success failure:(void(^)(NSString *error))failure;

/** 添加组织*/
+ (void)addDepartmentWithName:(NSString *)name pid:(NSString *)pid success:(void(^)(void))success failure:(void(^)(NSString *error))failure;

/** 删除组织*/
+ (void)deleteDepartmentWithId:(NSString *)oid success:(void(^)(void))success failure:(void(^)(NSString *error))failure;

/** 修改组织*/
+ (void)changeDepartmentWithId:(NSString *)oid name:(NSString *)name success:(void(^)(void))success failure:(void(^)(NSString *error))failure;

/** 员工详情*/
+ (void)getStaffInfoWithUserId:(NSString *)userId success:(void(^)(XWStaffInfoModel *model))success failure:(void(^)(NSString *error))failure;

/** 课程标签*/
+ (void)getLabelListWithLabelId:(NSString *)labelId success:(void(^)(NSMutableArray *dataSource))success failure:(void(^)(NSString *error))failure;

/** 创建子用户*/
+ (void)createUserWithName:(NSString *)name password:(NSString *)password phone:(NSString *)phone departmentId:(NSString *)departmentId lableId:(NSString *)lableId post:(NSString *)post success:(void(^)(void))success failure:(void(^)(NSString *error))failure;

/** 更新账号数据*/
+ (void)updateUserInfoWithKey:(NSString *)key value:(NSString *)value userId:(NSString *)userId success:(void(^)(void))success failure:(void(^)(NSString *error))failure;

/** 赠送金币*/
+ (void)giveGoldWithToUserId:(NSString *)toUserId gold:(NSString *)gold success:(void(^)(void))success failure:(void(^)(NSString *error))failure;

/** 优惠券列表*/
+ (void)getDiscountListSuccess:(void(^)(NSMutableArray *dataSource))success failure:(void(^)(NSString *error))failure;

/** 赠送优惠券*/
+ (void)giveCouponWithUserID:(NSString *)userId couponId:(NSString *)couponId couponPrice:(NSString *)couponPrice success:(void(^)(void))success failure:(void(^)(NSString *error))failure;

/** 获取部门列表*/
+ (void)getDepartmentListWithCompanyId:(NSString *)companyId did:(NSString *)did success:(void(^)(XWDepartmentModel *department))success failure:(void(^)(NSString *error))failure;

@end

