//
//  XWNetworking.h
//  XueWen
//
//  Created by ShaJin on 2017/11/21.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CourseModel;
@class CourseLabelModel;
@class LessionModel;
@class CommonModel;
@class CouponModel;
@class TransactionModel;
@class QuestionsModel;
@class ExamModel;
@class OrderModel;
@class CourseNoteModel;
@class BannerModel;
@class LearningPlanModel;
@class ProjectModel;
@class InvitationedModel,XWMyPlanModel;
typedef void(^XWCompleteBlock)(NSArray *array, NSInteger totalCount, BOOL isLast);

@interface XWNetworking : NSObject



/** 获取课程音频 */
+ (void)getCourseAudioWithCourseID:(NSString *)courseID completeBlock:(XWCompleteBlock)completeBlock;
/** 新增用户观看记录，添加过的课程会出现在我的课程列表用，只有免费课程需要调用这个接口，付费课程购买后就会添加到我的课程中 */
+ (void)addUserWatchRecordWithCourseID:(NSString *)courseID;
/** 获取注册记录（邀请明细）(个人的) */
+ (void)getPersonalRegisteredRecordWithPage:(NSInteger)page date:(NSString *)date completeBlock:(XWCompleteBlock)completeBlock;
/** 获取注册记录（邀请明细）(公司的) */
+ (void)getRegisteredRecordWithPage:(NSInteger)page date:(NSString *)date completeBlock:(XWCompleteBlock)completeBlock;
/** 获取已邀请人数和奖励的优惠券金额 */
+ (void)getInvitationCountWithCompleteBlock:(void(^)(NSInteger people, NSString *coupon))completeBlock;
/** 获取邀请链接 */
+ (void)getInvitationURLWithcompletionBlock:(void(^)(NSString *url))completionBlock;
/** 用户同意邀请 */
+ (void)invitationAccessWithCode:(NSString *)code completionBlock:(void(^)(BOOL succeed))completionBlock;
/** 新的支付订单接口，2018.03.07以后使用这个接口 */
+ (void)purchaseOrderWithOrderID:(NSString *)orderID couponID:(NSString *)couponID completionBlock:(void(^)(BOOL succeed))completionBlock;
/** 获取订单详情&&创建订单 */
+ (void)creatOrderWithID:(NSString *)identifier type:(int)type completeBlock:(void (^)(float gold, OrderModel *order))completeBlock;
/** 获取我的优惠券列表 */
+ (void)getCouponListWithType:(NSString *)type page:(int)page completeBlock:(XWCompleteBlock)completeBlock;
/** 根据专题ID获取专题详情 */
+ (void)getThematicInfoWithID:(NSString *)labelID completeBlock:(void (^)(ProjectModel *model))completeBlock;
/** 根据标签ID获取专题列表（通常只有一个） */
+ (void)getCourseThematicListWithID:(NSString *)labelID completeBlock:(XWCompleteBlock)completeBlock;
/** 获取学院列表  */
+ (void)getCollegeListWithCompleteBlock:(XWCompleteBlock)completeBlock;
/** 获取学习计划 */
+ (void)getLearningPlanListWithPage:(NSInteger)page completeBlock:(void (^)(NSArray<LearningPlanModel *> *plans , BOOL isLast))completeBlock;
/** 获取轮播图 */
+ (void)getBannerImagesWithCompleteBlock:(void (^)(NSArray<BannerModel *> *banners))completeBlock cid:(NSString *)cid;
/** 删除笔记 */
+ (void)deleteNoteWithNoteID:(NSString *)noteID;
/** 添加笔记 */
+ (void)addCourseNoteWithCourseID:(NSString *)courseID courseName:(NSString *)courseName content:(NSString *)content status:(NSString *)status completeBlock:(void (^)(void))completeBlock;
/** 获取单个课程下的笔记 */
+ (void)getCourseNotesListWithCourseID:(NSString *)courseID type:(NSString *)type page:(NSInteger)page completeBlock:(void (^)(NSArray<CourseNoteModel *> *notes , BOOL isLast))completeBlock;
/** 获取我的笔记列表 */
+ (void)getMyNotesListWithPage:(NSInteger)page completeBlock:(void (^)(NSArray<CourseNoteModel *> *notes , BOOL isLast))completeBlock;
/** 订单列表 */
+ (void)getPurchaseRecordWithType:(NSString *)type page:(NSInteger)page completeBlock:(void (^)(NSArray<OrderModel *> *orders , BOOL isLast))completeBlock;
/** 注册/重置密码 */
+ (void)registWithPhone:(NSString *)phone password:(NSString *)password code:(NSString *)code regist:(BOOL)regist completeBlock:(void (^)(BOOL succeed,NSString *status))completeBlock;
/** 获取验证码 */
+ (void)getAuthCodeWithPhoneNumber:(NSString *)number isRegister:(BOOL)isRegister completeBlock:(void (^)(NSString *authCode))completeBlock;
/** 获取我的考试列表 */
+ (void)getMyTestListWithPage:(NSInteger)page completionBlock:(void (^)(NSArray<ExamModel *> *exams , BOOL isLast))completeBlock;
/** 保存答题结果 */
+ (void)saveTestResultWithCourseID:(NSString *)courseID rightCount:(NSInteger)rightCount errorCount:(NSInteger)errorCount score:(NSInteger)score questions:(NSArray<QuestionsModel *> *)questions completionBlock:(void (^)(id result))completeBlock;
/** 根据试题ID获取试题 */
+ (void)getQuestionsListWithTestID:(NSString *)testID CompletionBlock:(void (^)(NSArray<QuestionsModel *> *questions))completeBlock;
/** 搜索 */
+ (void)searchWithSearch:(NSString *)search page:(NSInteger)page orderType:(NSString *)orderType free:(NSString *)free CompletionBlock:(void (^)(NSArray<CourseModel *> *courses ,NSInteger totalCount))completeBlock;
/** 获取支付宝支付参数 */
+ (void)getZhiFuBaoParameterWithPrice:(NSInteger)price withCompletionBlock:(void(^)(NSString *orderString))completionBlock;
/** 清空课程观看记录 */
+ (void)deleteViewingRecordWithCourseID:(NSString *)courseID completionBlock:(void(^)(BOOL succeed))completionBlock;
/** 获取观看记录 */
+ (void)getMyLearningRecordWithPage:(NSInteger)page Size:(NSString *)size CompletionBlock:(XWCompleteBlock)completeBlock;
+ (void)getMyLearningRecordWithPage:(NSInteger)page CompletionBlock:(XWCompleteBlock)completeBlock;
/** 交易列表 */
+ (void)getTransactionRecordWithType:(NSString *)type startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime completionBlock:(void(^)(NSArray<TransactionModel *> *transactions, BOOL isLast))completionBlock;
/** 更新视频观看时间 */
+ (void)updateUserViewingRecordWithCourseID:(NSString *)courseID NodeID:(NSString *)nodeID watchTime:(NSInteger)time finished:(BOOL)finished completionBlock:(void(^)(BOOL succeed))completionBlock;
/** 取消订单 */
+ (void)deleteOrderOrderWithOrderID:(NSString *)orderID completionBlock:(void(^)(BOOL succeed))completionBlock;
/** 购买专题 */
+ (void)purchaseThematicWithID:(NSString *)projectID completionBlock:(void(^)(BOOL succeed))completionBlock kDeprecated("purchaseOrderWithOrderID:couponID:completionBlock:");
/** 支付订单 */
+ (void)purchaseOrderWithOrderID:(NSString *)orderID completionBlock:(void(^)(BOOL succeed))completionBlock kDeprecated("purchaseOrderWithOrderID:couponID:completionBlock:");
/** 购买课程 */
+ (void)purchaseCourseWithCourseID:(NSString *)courseID couponID:(NSString *)couponID completionBlock:(void(^)(BOOL succeed))completionBlock kDeprecated("purchaseOrderWithOrderID:couponID:completionBlock:");
/** 获取视频播放凭证 */
+ (void)getPlayAuthWithVideoID:(NSString *)videoID completionBlock:(void (^)(NSString *playAuth))completeBlock failure:(void(^)(NSString *errorinfo))failure;
/** 获取我的课程||企业给我买的课程列表 */
+ (void)getCourseListWithMyClass:(BOOL)myClass page:(NSInteger)page CompletionBlock:(XWCompleteBlock)completeBlock;
/** 我的学习记录汇总（有折线图部分） */
+ (void)getCourseListWithMyClassWithID:(NSString *)ID completeBlock:(void (^)(XWMyPlanModel *model))completeBlock;
+ (void)getCourseListWithMyClass:(BOOL)myClass page:(NSInteger)page withSize:(NSString *)size CompletionBlock:(XWCompleteBlock)completeBlock;
/** 删除一个收藏的课程 */
+ (void)deleteFavoriteCourseWithID:(NSString *)courseID CompletionBlock:(void (^)(BOOL succeed))completeBlock;
/** 收藏一个课程 */
+ (void)addFavoriteCourseWithID:(NSString *)courseID CompletionBlock:(void (^)(BOOL succeed))completeBlock;
/** 获取课程收藏列表 */
+ (void)getFavoriteCourseListWithPage:(NSInteger)page CompletionBlock:(void (^)(NSArray<CourseModel *> *courses ,BOOL isLast))completeBlock;
/** 添加一个评论 */
+ (void)addCommentWithID:(NSString *)courseID content:(NSString *)content CompletionBlock:(void (^)(BOOL succeed))completeBlock;
/** 获取评论列表 */
+ (void)getCourseCommentWithID:(NSString *)courseID page:(NSInteger)page CompletionBlock:(void (^)(NSArray<CommonModel *> *commons , BOOL isLast))completeBlock;
/** 获取课程详情 */
+ (void)getCoursInfoWithID:(NSString *)coursID showProgress:(BOOL)showProgress CompletionBlock:(void (^)(LessionModel *lession))completeBlock;
/** 获取单个标签下所有课程 && 获取课程列表 */
+ (void)getCoursLabelInfoWithID:(NSString *)labelID order:(NSString *)order free:(NSString *)free page:(NSInteger)page CompletionBlock:(XWCompleteBlock)completeBlock kDeprecated("改用getCoursLabelInfoWithID:order:free:take:page:CompletionBlock:");
/** 获取单个标签下所有课程 && 获取课程列表 2018.01.23 改用这个方法*/
+ (void)getCoursLabelInfoWithID:(NSString *)labelID order:(NSString *)order free:(NSString *)free take:(NSString *)take page:(NSInteger)page CompletionBlock:(XWCompleteBlock)completeBlock;
/** 获取课程标签列表 */
+ (void)getCoursLabelListWithCompletionBlock:(void (^)(BOOL succeed))completeBlock;
/** 设置个人信息 */
+ (void)setPersonalInfoWithParam:(NSDictionary *)param completionBlock:(void(^)(NSString *status))completeBlock;
/** 设置头像 */
+ (void)setPersonalHeaderWithImage:(UIImage *)image completionBlock:(void(^)(NSString *status))completeBlock;
/** 获取账号信息 */
+ (void)getAccountInfoWithCompletionBlock:(void(^)(NSString *status))completeBlock;



/** 登陆 */
+ (void)loginWithAccount:(NSString *)account password:(NSString *)password completionBlock:(void(^)(NSString *status))completeBlock;
/** 检查系统版本 */
+ (void)checkAppVersion;
/** 设置OSSClient */
+ (void)setupOSSClient;
/** 无网络或连接不上服务器时显示 */
+ (void)netStatusChangedWithNoNetwork:(BOOL)noNetWork;
/** 获取服务器当前时间 */
+ (void)getServerTime;
/** 点击了未开放功能时显示 */
void showForbid(void);
/** 提示 */
void showTips(NSString *message);
void todo(NSString *message);
@end
