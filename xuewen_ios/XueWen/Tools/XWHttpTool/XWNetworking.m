//
//  XWNetworking.m
//  XueWen
//
//  Created by ShaJin on 2017/11/21.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
#import <AliyunOSSiOS/OSSService.h>
#import "XWNetworking.h"
#import "AFNetworking.h"
#import "NSString+AES128.h"
#import "CourseModel.h"
#import "LessionModel.h"
#import "CommonModel.h"
#import "CouponModel.h"
#import "TransactionModel.h"
#import "NetworkViewController.h"
#import "QuestionsModel.h"
#import "ExamModel.h"
#import "XWHttpSessionManager.h"
#import "OrderModel.h"
#import "CourseNoteModel.h"
#import "BannerModel.h"
#import "LearningPlanModel.h"
#import "CollegeModel.h"
#import "ProjectModel.h"
#import "InvitationedModel.h"
#import "CourseAudioModel.h"
#import "XWMyPlanModel.h"
//#import <nsurls>
#define PageSize  @"10"
static OSSClient * client;

@implementation XWNetworking
/** 获取课程音频 */
+ (void)getCourseAudioWithCourseID:(NSString *)courseID completeBlock:(XWCompleteBlock)completeBlock{
    [XWHttpSessionManager GET:kBASE_URL(CoursAudio, courseID) parameters:nil extra:kPrintResponse completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200 && completeBlock) {
            NSArray *array = [CourseAudioModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            CompleteFunc(completeBlock, responseJson, array);
        }
    }];
}

/** 新增用户观看记录，添加过的课程会出现在我的课程列表用，只有免费课程需要调用这个接口，付费课程购买后就会添加到我的课程中 */
+ (void)addUserWatchRecordWithCourseID:(NSString *)courseID{
    [XWHttpSessionManager GET:kBASE_URL(UserCourseRecord, courseID) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        // 没有返回值
    }];
}

/** 获取注册记录（邀请明细）(公司的) */
+ (void)getRegisteredRecordWithPage:(NSInteger)page date:(NSString *)date completeBlock:(XWCompleteBlock)completeBlock{
    NSMutableDictionary *dict = getPageDictionary(page);
    [dict setObject:date forKey:@"years"];
    [XWHttpSessionManager GET:kBASE_URL(Statistics, kUserInfo.oid) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200) {
            NSArray *array = [InvitationedModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            CompleteFunc(completeBlock, responseJson, array);
        }else{
            [MBProgressHUD showErrorMessage:responseJson[@"message"]];
        }
    }];
}

/** 获取注册记录（邀请明细）(个人的) */
+ (void)getPersonalRegisteredRecordWithPage:(NSInteger)page date:(NSString *)date completeBlock:(XWCompleteBlock)completeBlock{
    NSMutableDictionary *dict = getPageDictionary(page);
    [dict setObject:date forKey:@"years"];
    [dict setObject:kUserInfo.oid forKey:@"user_id"];
    [XWHttpSessionManager GET:BASE_URL(RegisteredRecord) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200 && completeBlock) {
            NSArray *array = [InvitationPersonalModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"res"][@"data"]];
            completeBlock(array,[responseJson[@"data"][@"res"][@"total"] integerValue],[responseJson[@"data"][@"res"][@"current_page"] integerValue] >= [responseJson[@"data"][@"res"][@"last_page"] integerValue]);
        }else{
            [MBProgressHUD showErrorMessage:responseJson[@"message"]];
        }
    }];
}

/** 获取已邀请人数和奖励的优惠券金额 */
+ (void)getInvitationCountWithCompleteBlock:(void(^)(NSInteger people, NSString *coupon))completeBlock{
    [XWHttpSessionManager GET:kBASE_URL(RegisteredRecord, kUserInfo.oid) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200 && completeBlock) {
            NSInteger people = [responseJson[@"data"][@"people"] integerValue];
            NSString *coupon = responseJson[@"data"][@"coupon"];
            completeBlock(people,coupon);
        }
    }];
}

/** 获取邀请链接 */
+ (void)getInvitationURLWithcompletionBlock:(void(^)(NSString *url))completionBlock{
    [XWHttpSessionManager GET:BASE_URL(Invitation) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200 && completionBlock) {
            completionBlock(responseJson[@"data"][@"url"]);
        }else{
            [MBProgressHUD showErrorMessage:responseJson[@"message"]];
        }
    }];
}

/** 用户同意邀请 */
+ (void)invitationAccessWithCode:(NSString *)code completionBlock:(void(^)(BOOL succeed))completionBlock{
    [XWHttpSessionManager POST:BASE_URL(InvitationAccess) parameters:@{@"code" : (code.length > 0) ? code : @""} extra:kShowProgress completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        NSString *message = responseJson[@"message"];
        if (statusCode == 201) {
            [MBProgressHUD showSuccessMessage:message];
        }else{
            [MBProgressHUD showErrorMessage:message];
        }
        XWWeakSelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf succeed:statusCode == 201 block:completionBlock];
        });
    }];
}

/** 新的支付订单接口，2018.03.07以后使用这个接口 */
+ (void)purchaseOrderWithOrderID:(NSString *)orderID couponID:(NSString *)couponID completionBlock:(void(^)(BOOL succeed))completionBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:orderID forKey:@"order_id"];
    [dict setObject:(couponID.length > 0) ? couponID : @"" forKey:@"coupon_id"];
    [XWHttpSessionManager POST:BASE_URL(PayOrder) parameters:dict extra:kShowProgress completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        BOOL succeed = NO;
        /** 支付成功返回YES 余额不足返回NO 其他错误只提示不返回 */
        if (statusCode == 200) {
            [MBProgressHUD showSuccessMessage:@"购买成功"];
            succeed = YES;
        }else{
            succeed = NO;
            [MBProgressHUD showErrorMessage:responseJson[@"message"]];
        }
        XWWeakSelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf succeed:succeed block:completionBlock];
        });
        
    }];
}

/** 获取订单详情&&创建订单 */
+ (void)creatOrderWithID:(NSString *)identifier type:(int)type completeBlock:(void (^)(float gold, OrderModel *order))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *url = nil;
    if (type == 0 || type == 1) {
        url = BASE_URL(CreatOrder);
        [dict setObject:identifier forKey:@"value_id"];
        [dict setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    }else{
        url = kBASE_URL(OrderInfo, identifier);
    }
    [XWHttpSessionManager GET:url parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200) {
            OrderModel *order = [OrderModel mj_objectWithKeyValues:responseJson[@"data"][@"purchaserecord"]];
            NSString *class = [order.type isEqualToString:@"0"] ? @"CourseModel" : @"ProjectModel";
            order.purchaseInfo = [NSClassFromString(class) mj_objectWithKeyValues:responseJson[@"data"][@"purchaserecord"][@"purchase_info"]];
            float gold = [responseJson[@"data"][@"gold"] floatValue];
            if (completeBlock) {
                completeBlock(gold,order);
            }
        }else{
            [MBProgressHUD showErrorMessage:responseJson[@"message"] completionBlock:^{
                if (completeBlock) {
                    completeBlock(0.0,nil);
                }
            }];
        }
    }];
}

/** 获取我的优惠券列表 */
+ (void)getCouponListWithType:(NSString *)type page:(int)page completeBlock:(XWCompleteBlock)completeBlock{
    NSMutableDictionary *dict = getPageDictionary(page);
    [dict setObject:type forKey:@"type"];
    [XWHttpSessionManager GET:BASE_URL(UserCoupon) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        NSArray *coupons = [CouponModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
        CompleteFunc(completeBlock, responseJson, coupons);
    }];
}

/** 根据专题ID获取专题详情 */
+ (void)getThematicInfoWithID:(NSString *)labelID completeBlock:(void (^)(ProjectModel *model))completeBlock{
    [XWHttpSessionManager GET:kBASE_URL(ThematicLabelInfo, labelID) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200 && completeBlock) {
            ProjectModel *model = [ProjectModel mj_objectWithKeyValues:responseJson[@"data"]];
            completeBlock(model);
        }
    }];
}

/** 根据标签ID获取专题列表（通常只有一个） */
+ (void)getCourseThematicListWithID:(NSString *)labelID completeBlock:(XWCompleteBlock)completeBlock{
    [XWHttpSessionManager GET:BASE_URL(CourseThematicLabel) parameters:@{@"c_label_id":labelID,@"type":@"app"} extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        NSArray *array = [ProjectModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
        CompleteFunc(completeBlock, responseJson, array);
    }];
}

/** 获取学院列表  */
+ (void)getCollegeListWithCompleteBlock:(XWCompleteBlock)completeBlock{
    [XWHttpSessionManager GET:BASE_URL(CollegeModule) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200) {
            NSArray *array = [CollegeModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            CompleteFunc(completeBlock, responseJson, array);
        }else{
            /** 数据错误也要有返回 */
            completeBlock([NSArray array],0,YES);
        }
    }];
}

/** 获取学习计划 */
+ (void)getLearningPlanListWithPage:(NSInteger)page completeBlock:(void (^)(NSArray<LearningPlanModel *> *plans , BOOL isLast))completeBlock{
    NSMutableDictionary *dict = getPageDictionary(page);
    [XWHttpSessionManager GET:BASE_URL(LearningPlan) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200 && completeBlock) {
            NSArray *array = [LearningPlanModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
             completeBlock(array,([responseJson[@"data"][@"current_page"] integerValue] >= [responseJson[@"data"][@"last_page"] integerValue]));
            
        }
    }];
}

/** 获取轮播图 */
+ (void)getBannerImagesWithCompleteBlock:(void (^)(NSArray<BannerModel *> *banners))completeBlock cid:(NSString *)cid{
    
    ParmDict
    [dict setValue:cid forKey:@"cid"];
    [dict setValue:@"2" forKey:@"type"];
    [XWHttpSessionManager GET:BASE_URL(ShufflingFigure) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200 && completeBlock) {
            NSArray *array = [BannerModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            completeBlock(array);
        }
    }];
}

/** 删除笔记 */
+ (void)deleteNoteWithNoteID:(NSString *)noteID{
    [XWHttpSessionManager DELETE:kBASE_URL(CourseNotes, noteID) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        //
    }];
}

/** 添加笔记 */
+ (void)addCourseNoteWithCourseID:(NSString *)courseID courseName:(NSString *)courseName content:(NSString *)content status:(NSString *)status completeBlock:(void (^)(void))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:courseID forKey:@"course_id"];
    [dict setObject:content forKey:@"notes_content"];
    [dict setObject:status forKey:@"status"];
    [Analytics event:EventSendNote attributes:dict];
    [XWHttpSessionManager POST:BASE_URL(CourseNotes) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (completeBlock) {
            completeBlock();
        }
    }];
}

/** 获取单个课程下的笔记 */
+ (void)getCourseNotesListWithCourseID:(NSString *)courseID type:(NSString *)type page:(NSInteger)page completeBlock:(void (^)(NSArray<CourseNoteModel *> *notes , BOOL isLast))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:PageSize forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [dict setObject:type forKey:@"status"];
    [XWHttpSessionManager GET:kBASE_URL(CourseNotes, courseID) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200) {
            NSArray *array = [CourseNoteModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            if (completeBlock) {
                completeBlock(array,([responseJson[@"data"][@"current_page"] integerValue] == [responseJson[@"data"][@"last_page"] integerValue]));
            }
        }
    }];
}

/** 获取我的笔记列表 */
+ (void)getMyNotesListWithPage:(NSInteger)page completeBlock:(void (^)(NSArray<CourseNoteModel *> *notes , BOOL isLast))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:PageSize forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [XWHttpSessionManager GET:BASE_URL(CourseNotes) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200) {
            NSArray *array = [CourseNoteModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            if (completeBlock) {
                completeBlock(array,([responseJson[@"data"][@"current_page"] integerValue] >= [responseJson[@"data"][@"last_page"] integerValue]));
            }
        }
    }];
}

/** 订单列表 */
+ (void)getPurchaseRecordWithType:(NSString *)type page:(NSInteger)page completeBlock:(void (^)(NSArray<OrderModel *> *orders , BOOL isLast))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:type forKey:@"type"];
    [dict setObject:PageSize forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [XWHttpSessionManager GET:BASE_URL(PurchaseRecord) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200 && completeBlock) {
            NSArray *array = [OrderModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            
            completeBlock(array,([responseJson[@"data"][@"current_page"] integerValue] >= [responseJson[@"data"][@"last_page"] integerValue]));
        }else{
            [XWPopupWindow popupWindowsWithTitle:@"错误" message:responseJson buttonTitle:@"好的" buttonBlock:nil];
        }
    }];
}

/** 注册/重置密码 */
+ (void)registWithPhone:(NSString *)phone password:(NSString *)password code:(NSString *)code regist:(BOOL)regist completeBlock:(void (^)(BOOL succeed,NSString *status))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:phone forKey:@"phone"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:code forKey:@"code"];
    NSString *url = BASE_URL(regist ? RegistAccount : ResetPassword);
    [XWHttpSessionManager POST:url parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (completeBlock) {
            completeBlock(statusCode == 200,responseJson[@"message"]);
        }
    }];
}

/** 获取验证码 */
+ (void)getAuthCodeWithPhoneNumber:(NSString *)number isRegister:(BOOL)isRegister completeBlock:(void (^)(NSString *authCode))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:number forKey:@"phone"];
    if (isRegister) {
        [dict setObject:@"register" forKey:@"type"];
    }
    [XWHttpSessionManager GET:BASE_URL(AuthCode) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200 && completeBlock) {
            completeBlock([NSString stringWithFormat:@"%@",responseJson[@"data"][@"smscode"]]);
        }else{
            [MBProgressHUD showErrorMessage:responseJson[@"message"]];
        }
    }];
}

/** 获取我的考试列表 */
+ (void)getMyTestListWithPage:(NSInteger)page completionBlock:(void (^)(NSArray<ExamModel *> *exams , BOOL isLast))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:PageSize forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [dict setObject:[XWInstance shareInstance].userInfo.oid forKey:@"user_id"];
    [XWHttpSessionManager GET:BASE_URL(TestRecord) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        switch (statusCode) {
            case 200:{
                NSArray *exams = [ExamModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
                NSArray *array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N"];
                for (ExamModel *exam in exams) {// 给选项添加ABCD
                    for (int i = 0; i < exam.questions.count; i++) {
                        QuestionsModel *question = exam.questions[i];
                        question.title = [NSString stringWithFormat:@"（%@）%@（%d/%ld）",question.multiSelect ? @"多选" : @"单选" ,question.content,i + 1,(unsigned long)exam.questions.count];
                        for (int j = 0; j < question.options.count; j++) {
                            QuestionsOptionModel *option = question.options[j];
                            option.title = [NSString stringWithFormat:@"%@、%@",array[j],option.content];
                        }
                    }
                }
                if (completeBlock) {
                    completeBlock(exams,getIsLast(responseJson));
                }
            }break;
            default:
                break;
        }
    }];
}

/** 保存答题结果 */
+ (void)saveTestResultWithCourseID:(NSString *)courseID rightCount:(NSInteger)rightCount errorCount:(NSInteger)errorCount score:(NSInteger)score questions:(NSArray<QuestionsModel *> *)questions completionBlock:(void (^)(id result))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:courseID forKey:@"course_id"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)rightCount] forKey:@"correct"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)errorCount] forKey:@"wrong"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)score] forKey:@"fraction"];
    NSDictionary *contentDic = @{@"data":[QuestionsModel mj_keyValuesArrayWithObjectArray:questions]};
    NSString *jsonStr = [NSString stringWithJsonData:contentDic];
    [dict setObject:jsonStr forKey:@"content"];
    [XWHttpSessionManager POST:BASE_URL(TestRecord) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if ([responseJson[@"status"] isEqualToString:@"success"] && completeBlock) {
            completeBlock(responseJson);
        }
    }];
}

/** 根据试题ID获取试题 */
+ (void)getQuestionsListWithTestID:(NSString *)testID CompletionBlock:(void (^)(NSArray<QuestionsModel *> *questions))completeBlock{
    if ([testID isEqualToString:@"0"]) {
        return;
    }
    [XWHttpSessionManager GET:kBASE_URL(TestNode, testID) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        switch (statusCode) {
            case 200:{
                NSArray *questions = [QuestionsModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
                NSArray *array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N"];
                for (int i = 0; i < questions.count; i++) {
                    QuestionsModel *question = questions[i];
                    question.title = [NSString stringWithFormat:@"（%@）%@（%d/%ld）",question.multiSelect ? @"多选" : @"单选" ,question.content,i + 1,(unsigned long)questions.count];
                    for (int j = 0; j < question.options.count; j++) {
                        QuestionsOptionModel *option = question.options[j];
                        option.title = [NSString stringWithFormat:@"%@、%@",array[j],option.content];
                    }
                }
                if (completeBlock) {
                    completeBlock(questions);
                }
            }break;
            default:
                break;
        }
    }];
}

/** 搜索课程 */
+ (void)searchWithSearch:(NSString *)search page:(NSInteger)page orderType:(NSString *)orderType free:(NSString *)free CompletionBlock:(void (^)(NSArray<CourseModel *> *courses ,NSInteger totalCount))completeBlock{
//    NSString *url = kBASE_URL(SearchCourse, search); // 改用下边的接口 2018.01.17
    NSString *url = BASE_URL(Cours);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (search.length > 0) {
        [dict setObject:search forKey:@"name"];
    }else{
        if (completeBlock) {
            completeBlock([NSArray array],0);
        }
        return;
    }
    [dict setObject:PageSize forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    if ([@[@"1",@"2",@"3",@"4"] containsObject:orderType]) {
        [dict setObject:orderType forKey:@"order_type"];
    }
    if ([@[@"0",@"1",@"2"] containsObject:free]) {
        [dict setObject:free forKey:@"free"];
    }
    [XWHttpSessionManager GET:url parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200) {
            NSArray *course = [CourseModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            NSInteger count = [responseJson[@"data"][@"total"] integerValue];
            if (completeBlock) {
                completeBlock(course,count);
            }
        }
    }];
}

/** 获取支付宝支付参数 */
+ (void)getZhiFuBaoParameterWithPrice:(NSInteger)price withCompletionBlock:(void(^)(NSString *orderString))completionBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:price * 100] forKey:@"total_fee"];
    [dict setObject:[NSString stringWithFormat:@"支付宝充值%ld元",(long)price] forKey:@"body"];
    [dict setObject:@"alipay" forKey:@"pay"];
    [dict setObject:@"app" forKey:@"trade_type"];
    [XWHttpSessionManager POST:BASE_URL(GetPayOrder) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200 && completionBlock) {
            completionBlock(responseJson[@"data"][@"pay"]);
        }
    }];
}

/** 获取观看记录 */
+ (void)getMyLearningRecordWithPage:(NSInteger)page Size:(NSString *)size CompletionBlock:(XWCompleteBlock)completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:size forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [XWHttpSessionManager GET:BASE_URL(Userlearninghistory) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200) {
          
            if (![responseJson[@"message"] isEqualToString:@"没有学习记录！"]){
                NSArray *array = [CourseModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
                CompleteFunc(completeBlock, responseJson, array);
            }else {
                CompleteFunc(nil, nil, nil);
            }
            
        }else {
            CompleteFunc(nil, nil, nil);
        }
    }];
}

+ (void)getMyLearningRecordWithPage:(NSInteger)page CompletionBlock:(XWCompleteBlock)completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:PageSize forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [XWHttpSessionManager GET:BASE_URL(Userlearninghistory) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200) {
            
            if (![responseJson[@"message"] isEqualToString:@"没有学习记录！"]){
                NSArray *array = [CourseModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
                CompleteFunc(completeBlock, responseJson, array);
            }
            
        }
    }];
}

/** 交易列表 */
+ (void)getTransactionRecordWithType:(NSString *)type startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime completionBlock:(void(^)(NSArray<TransactionModel *> *transactions, BOOL isLast))completionBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([@[@"0",@"1",@"2"] containsObject:type]) {
        [dict setObject:type forKey:@"type"];
    }
    if (startTime > 0) {
        [dict setObject:[NSString stringWithFormat:@"%f",startTime] forKey:@"startTime"];
    }
    if (endTime > 0) {
        [dict setObject:[NSString stringWithFormat:@"%f",endTime] forKey:@"endTime"];
    }
    [XWHttpSessionManager GET:BASE_URL(TransactionRecord) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        BOOL isLast = NO;
        if (statusCode == 200) {
            if ([responseJson[@"data"][@"current_page"] integerValue] >= [responseJson[@"data"][@"last_page"] integerValue]) {
                isLast = YES;
            }
            NSArray *array = [TransactionModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            if (completionBlock) {
                completionBlock(array,isLast);
            }
        }
    }];
}

/** 清空课程观看记录 */
+ (void)deleteViewingRecordWithCourseID:(NSString *)courseID completionBlock:(void(^)(BOOL succeed))completionBlock{
    [XWHttpSessionManager POST:BASE_URL(ClearViewingRecord) parameters:@{@"course_id":courseID} extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (completionBlock) {
            completionBlock(statusCode == 200);
        }
    }];
}

/** 更新视频观看时间 */
+ (void)updateUserViewingRecordWithCourseID:(NSString *)courseID NodeID:(NSString *)nodeID watchTime:(NSInteger)time finished:(BOOL)finished completionBlock:(void(^)(BOOL succeed))completionBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:courseID forKey:@"course_id"];
    [dict setValue:nodeID forKey:@"course_node_id"];
    [dict setValue:[NSNumber numberWithInteger:time*1000] forKey:@"watch_time"];
    [dict setObject:finished ? @"1" : @"0" forKey:@"finished"];
    [XWHttpSessionManager POST:BASE_URL(UserViewingRecord) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (completionBlock) {
            if (statusCode == 201) {
                completionBlock(YES);
            }else{
                completionBlock(NO);
            }
        }
    }];
}



/** 取消订单 */
+ (void)deleteOrderOrderWithOrderID:(NSString *)orderID completionBlock:(void(^)(BOOL succeed))completionBlock{
    [XWHttpSessionManager DELETE:kBASE_URL(CancelOrder, orderID) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (completionBlock) {
            completionBlock([responseJson[@"status"] isEqualToString:@"success"]);
        }
    }];
}

/** 购买专题 */
+ (void)purchaseThematicWithID:(NSString *)projectID completionBlock:(void(^)(BOOL succeed))completionBlock{
    [XWHttpSessionManager POST:BASE_URL(ThematicPay) parameters:@{@"thematic_id":projectID,@"coupon_id":@""} extra:0 | kShowProgress completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        /** 支付成功返回YES 余额不足返回NO 其他错误只提示不返回 */
        if (statusCode == 200) {
            [MBProgressHUD showSuccessMessage:@"购买成功"];
            [self succeed:YES block:completionBlock];
        }else{
            if ([responseJson[@"message"] isEqualToString:@"余额不足"]) {
                [self succeed:NO block:completionBlock];
            }else{
                [MBProgressHUD showErrorMessage:responseJson[@"message"]];
            }
        }
        
    }];
}

/** 支付订单 */
+ (void)purchaseOrderWithOrderID:(NSString *)orderID completionBlock:(void(^)(BOOL succeed))completionBlock{
    [XWHttpSessionManager POST:BASE_URL(PayOrder) parameters:@{@"order_id":orderID} extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        /** 支付成功返回YES 余额不足返回NO 其他错误只提示不返回 */
        if (statusCode == 200) {
            [MBProgressHUD showSuccessMessage:@"购买成功"];
            [self succeed:YES block:completionBlock];
        }else{
            if ([responseJson[@"message"] isEqualToString:@"余额不足"]) {
                
                [self succeed:NO block:completionBlock];
            }else{
                [MBProgressHUD showErrorMessage:responseJson[@"message"]];
            }
        }
        
    }];
    
}

/** 新的购买课程接口 2018.01.18 以后用这个接口 */
+ (void)purchaseCourseWithCourseID:(NSString *)courseID couponID:(NSString *)couponID completionBlock:(void(^)(BOOL succeed))completionBlock{
    // couponID是为了以后添加优惠券功能拓展的
    NSString *url = BASE_URL(PayCourse);
    [XWHttpSessionManager GET:url parameters:@{@"course_id":courseID} extra:kShowProgress completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        /** 购买成功返回YES 余额不足返回NO 其他错误只提示不返回 */
        if (statusCode == 200) {
            [MBProgressHUD showSuccessMessage:@"购买成功"];
            [self succeed:YES block:completionBlock];
        }else{
            if ([responseJson[@"message"] isEqualToString:@"余额不足"]) {
                
                [self succeed:NO block:completionBlock];
            }else{
                [MBProgressHUD showErrorMessage:responseJson[@"message"]];
            }
        }
        
    }];
}

/** 获取视频播放凭证 */
+ (void)getPlayAuthWithVideoID:(NSString *)videoID completionBlock:(void (^)(NSString *playAuth))completeBlock failure:(void (^)(NSString *))failure{
    [XWHttpSessionManager POST:BASE_URL(VideoPlay) parameters:@{@"VideoId":videoID} extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200 && completeBlock) {
            completeBlock(responseJson[@"PlayAuth"]);
        }else{
            !failure ? : failure(responseJson[@"message"]);
        }
    }];
}

/** 获取我的优惠券 */
+ (void)getCouponRecordCompletionBlock:(void (^)(NSArray<CouponModel *> *courses ,BOOL isLast))completeBlock{
    [XWHttpSessionManager GET:BASE_URL(CouponRecord) parameters:nil extra:kShowProgress completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        BOOL isLast = NO;
        if (statusCode == 200) {
            if ([responseJson[@"data"][@"current_page"] integerValue] >= [responseJson[@"data"][@"last_page"] integerValue]) {
                isLast = YES;
            }
            NSArray *array = [CouponModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            if (completeBlock) {
                completeBlock(array,isLast);
            }
        }
    }];
}

/** 我的学习记录汇总（有折线图部分） */
+ (void)getCourseListWithMyClassWithID:(NSString *)ID completeBlock:(void (^)(XWMyPlanModel *model))completeBlock{
    
    [XWHttpSessionManager GET:kBASE_URL(Countplaytime, ID) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200 && completeBlock) {
            XWMyPlanModel *model = [XWMyPlanModel mj_objectWithKeyValues:responseJson[@"data"]];
            completeBlock(model);
        }
    }];
}

/** 获取我的课程||企业给我买的课程列表 */
+ (void)getCourseListWithMyClass:(BOOL)myClass page:(NSInteger)page CompletionBlock:(XWCompleteBlock)completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:PageSize forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    if (!myClass) {
        [dict setObject:[XWInstance shareInstance].userInfo.company_id forKey:@"company_id"];
    }
    [XWHttpSessionManager GET:BASE_URL(UserCourse) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200) {
            NSArray *array = [CourseModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            CompleteFunc(completeBlock, responseJson,array);
        }
    }];
}

+ (void)getCourseListWithMyClass:(BOOL)myClass page:(NSInteger)page withSize:(NSString *)size CompletionBlock:(XWCompleteBlock)completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:size forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    if (!myClass) {
        [dict setObject:[XWInstance shareInstance].userInfo.company_id forKey:@"company_id"];
    }
    [XWHttpSessionManager GET:BASE_URL(UserCourse) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200) {
            NSArray *array = [CourseModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            CompleteFunc(completeBlock, responseJson,array);
        }
    }];
}

/** 删除一个收藏的课程 */
+ (void)deleteFavoriteCourseWithID:(NSString *)courseID CompletionBlock:(void (^)(BOOL succeed))completeBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL(FavoriteCourse),courseID];
    [XWHttpSessionManager DELETE:url parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (completeBlock) {
            completeBlock(statusCode == 200);
        }
    }];
}

/** 收藏一个课程 */
+ (void)addFavoriteCourseWithID:(NSString *)courseID CompletionBlock:(void (^)(BOOL succeed))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:courseID forKey:@"course_id"];
    [XWHttpSessionManager POST:BASE_URL(FavoriteCourse) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (completeBlock) {
            completeBlock(statusCode == 200);
        }
    }];
}

/** 获取课程收藏列表 */
+ (void)getFavoriteCourseListWithPage:(NSInteger)page CompletionBlock:(void (^)(NSArray<CourseModel *> *courses ,BOOL isLast))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:PageSize forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [XWHttpSessionManager GET:BASE_URL(FavoriteCourse) parameters:dict extra:kShowProgress completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 200) {
            BOOL isLast = NO;
            if ([responseJson[@"data"][@"current_page"] integerValue] >= [responseJson[@"data"][@"last_page"] integerValue]) {
                isLast = YES;
            }
            NSArray *array = [CourseModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
            if (completeBlock) {
                completeBlock(array,isLast);
            }
        }
    }];
}

/** 添加一个评论 */
+ (void)addCommentWithID:(NSString *)courseID content:(NSString *)content CompletionBlock:(void (^)(BOOL succeed))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:courseID forKey:@"course_id"];
    [dict setObject:content forKey:@"comment"];
    [Analytics event:EventSendCommont attributes:dict];
    [XWHttpSessionManager POST:BASE_URL(CoursCommon) parameters:dict extra:kShowProgress completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        if (statusCode == 201) {
            [MBProgressHUD showSuccessMessage:@"评论成功"];
        }else{
            [MBProgressHUD showErrorMessage:responseJson[@"message"]];
        }
        
        if (completeBlock) {
            completeBlock(statusCode == 201);
        }
    }];
}

/** 获取评论列表 */
+ (void)getCourseCommentWithID:(NSString *)courseID page:(NSInteger)page CompletionBlock:(void (^)(NSArray<CommonModel *> *commons , BOOL isLast))completeBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:PageSize forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [XWHttpSessionManager GET:kBASE_URL(CoursCommon, courseID) parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        BOOL isLast = NO;
        switch (statusCode) {
            case 200:{
                if ([responseJson[@"data"][@"current_page"] integerValue] >= [responseJson[@"data"][@"last_page"] integerValue]) {
                    isLast = YES;
                }
                NSArray *array = [CommonModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
                if (completeBlock) {
                    completeBlock(array,isLast);
                }
            }break;
            default:
                break;
        }
    }];
}

/** 获取课程详情 */
+ (void)getCoursInfoWithID:(NSString *)coursID showProgress:(BOOL)showProgress CompletionBlock:(void (^)(LessionModel *lession))completeBlock{
    ExtraParameters extra = showProgress ? kShowProgress : 0;
//    extra = extra | kPrintResponse;
    [XWHttpSessionManager GET:kBASE_URL(Cours, coursID) parameters:nil extra:extra completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        LessionModel *lession = nil;
        switch (statusCode) {
            case 200:{
                lession = [LessionModel mj_objectWithKeyValues:responseJson[@"data"][@"course"]];
                NSNumber *number = responseJson[@"data"][@"audio_type"];
                lession.audio_type = [number integerValue];
                lession.isBought = ([responseJson[@"data"][@"type"] integerValue] == 1) ? YES : NO ;
                NSArray *courseArray = responseJson[@"data"][@"course_node"];
                if (courseArray.count == 0 || courseArray == nil) {
                    lession.isCourse_node = NO;
                    lession.lessions = [LessionNodeModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"node_audio"]];
                }else{
                    lession.isCourse_node = YES;
                    lession.lessions = [LessionNodeModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"course_node"]];
                }
                
                lession.needRestudy = ([responseJson[@"data"][@"reset_test"] integerValue] == 1) ? NO : YES;
//                lession.canPlay  = ([responseJson[@"data"][@"expiry_time"] integerValue] == 1) ? YES : NO ;
            }break;
            default:
                break;
        }
        if (completeBlock) {
            if (!lession) {
                [MBProgressHUD showErrorMessage:@"加载数据失败"];
            }
            completeBlock(lession);
        }
    }];
}

/** 获取单个标签下所有课程 && 获取课程列表 */
+ (void)getCoursLabelInfoWithID:(NSString *)labelID order:(NSString *)order free:(NSString *)free page:(NSInteger)page CompletionBlock:(XWCompleteBlock)completeBlock{
    NSString *url = BASE_URL(Cours);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"20" forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    if (labelID) {
        [dict setObject:labelID forKey:@"id"];
    }
    if ([@[@"0",@"1",@"2",@"3",@"4",@"5"] containsObject:order]) {
        [dict setObject:order forKey:@"order_type"];
    }
    if ([@[@"0",@"1",@"2"] containsObject:free]) {
        [dict setObject:free forKey:@"free"];
    }
    [XWHttpSessionManager GET:url parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        switch (statusCode) {
            case 200:{
                NSArray *course = [CourseModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
                NSInteger count = [responseJson[@"data"][@"total"] integerValue];
                BOOL isLast = ([responseJson[@"data"][@"current_page"] integerValue] >= [responseJson[@"data"][@"last_page"] integerValue]);
                if (completeBlock) {
                    completeBlock(course,count,isLast);
                }
            }break;
            default:
                break;
        }
    }];
}

/** 获取单个标签下所有课程 && 获取课程列表 */
+ (void)getCoursLabelInfoWithID:(NSString *)labelID order:(NSString *)order free:(NSString *)free take:(NSString *)take page:(NSInteger)page CompletionBlock:(XWCompleteBlock)completeBlock{
    NSString *url = BASE_URL(Cours);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:PageSize forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    if (labelID) {
        [dict setObject:labelID forKey:@"id"];
        [Analytics event:EventLabelInfo label:labelID];
    }
    if ([@[@"0",@"1",@"2",@"3",@"4"] containsObject:order]) {
        [dict setObject:order forKey:@"order_type"];
    }
    if ([@[@"0",@"1",@"2"] containsObject:free]) {
        [dict setObject:free forKey:@"free"];
    }
    if ([@[@"0",@"1",@"2"] containsObject:take]) {
        [dict setObject:take forKey:@"take"];
    }
    [XWHttpSessionManager GET:url parameters:dict extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        switch (statusCode) {
            case 200:{
                NSArray *course = [CourseModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"][@"data"]];
                NSInteger count = [responseJson[@"data"][@"total"] integerValue];
                BOOL isLast = ([responseJson[@"data"][@"current_page"] integerValue] >= [responseJson[@"data"][@"last_page"] integerValue]);
                if (completeBlock) {
                    completeBlock(course,count,isLast);
                }
            }break;
            default:
                break;
        }
    }];
}

/** 获取课程标签列表 */
+ (void)getCoursLabelListWithCompletionBlock:(void (^)(BOOL succeed))completeBlock{
    [XWHttpSessionManager GET:BASE_URL(CoursLabel) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        switch (statusCode) {
            case 200:{
                NSArray *courses = [CourseLabelModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"]];
                NSMutableArray *mArray = [NSMutableArray array];
                for (int i = 0; i < courses.count; i++) {
                    CourseLabelModel *labelModel = courses[i];
                    if (![labelModel.labelName isEqualToString:@"全部"]) {
                        NSMutableArray *mArr = [NSMutableArray array];
                        for (int j = 0; j < labelModel.children.count; j++) {
                            CourseLabelModel *model = labelModel.children[j];
                            if (![model.labelName isEqualToString:@"全部"]) {
                                NSMutableArray *labels = [NSMutableArray array];
                                
                                for (int k = 0; k < model.children.count; k++) {
                                    CourseLabelModel *label = model.children[k];
                                    if (![label.labelName isEqualToString:@"全部"]) {
                                        [labels addObject:label];
                                    }
                                }
                                model.children = labels;
                                [mArr addObject:model];
                            }
                        }
                        labelModel.children = mArr;
                        [mArray addObject:labelModel];
                    }
                }
                if (mArray.count > 0) {
                    [XWInstance shareInstance].courseLabelList = mArray;
                }
                [self succeed:(mArray.count > 0) block:completeBlock];
            }break;
            default:
                break;
        }
    }];
}

/** 设置头像 */
+ (void)setPersonalHeaderWithImage:(UIImage *)image completionBlock:(void(^)(NSString *status))completeBlock{
    if (image && [image isKindOfClass:[UIImage class]]) {
        [MBProgressHUD showActivityMessageInWindow:@"上传中"];
        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
        // 必填字段
        put.bucketName = @"xuewen-oss";
        put.objectKey = [NSString stringWithFormat:@"uploads/%@/%@.jpg",getDateFormat(),getCurrentTime(13)];
        put.uploadingData = [image zip]; // 直接上传NSData
        OSSTask * putTask = [client putObject:put];
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                  [self setPersonalInfoWithParam:@{@"picture":put.objectKey} completionBlock:completeBlock];
            } else {
                [MBProgressHUD hideHUD];
                [self tips:@"Failure" bolck:completeBlock];
            }
            return nil;
        }];
    }else{
        [self tipNoParamWithBlock:completeBlock];
    }
}



/** 设置个人信息 */
+ (void)setPersonalInfoWithParam:(NSDictionary *)param completionBlock:(void(^)(NSString *status))completeBlock{
    if (param) {
        [XWHttpSessionManager PUT:kBASE_URL(AccountInfo, [XWInstance shareInstance].userInfo.oid) parameters:param extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
            if (statusCode == 201) {
                [XWInstance shareInstance].userInfo = [XWUserInfo mj_objectWithKeyValues:responseJson[@"data"]];
                [self postNotificationWithName:PersonalInformationUpdate];
                [self tips:Succeed bolck:completeBlock];
                [MBProgressHUD hideHUD];
            }else{
                [self tips:responseJson[@"message"] bolck:completeBlock];
            }
            
        }];
    }else{
        [MBProgressHUD hideHUD];
        [self tipNoParamWithBlock:completeBlock];
    }
}

/** 获取账号信息 */
+ (void)getAccountInfoWithCompletionBlock:(void(^)(NSString *status))completeBlock{
    [XWHttpSessionManager GET:kBASE_URL(AccountInfo, [XWInstance shareInstance].userInfo.oid) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        switch (statusCode) {
            case 200:{
                [XWInstance shareInstance].userInfo = [XWUserInfo mj_objectWithKeyValues:responseJson[@"data"]];
                [self postNotificationWithName:PersonalInformationUpdate];
                [self tips:Succeed bolck:completeBlock];
            }break;
            default:
                break;
        }
    }];
}

/** 登陆 */
+ (void)loginWithAccount:(NSString *)account password:(NSString *)password completionBlock:(void(^)(NSString *status))completeBlock{
    if (account && password) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:account forKey:@"account"];
        [dict setValue:password forKey:@"password"];
        [[XWHttpSessionManager new] POST:BASE_URL(loginAccount) parameters:dict extra:kShowProgress  completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
            if (statusCode == 200) {
                XWInstance *instance = [XWInstance shareInstance];
                instance.userInfo = [XWUserInfo mj_objectWithKeyValues:responseJson[@"data"][@"user"]];
                instance.accessToken = responseJson[@"data"][@"token"];
                [self postNotificationWithName:PersonalInformationUpdate];
                [self tips:@"登陆成功" bolck:completeBlock];
            }else{
                [self tips:responseJson[@"message"] bolck:completeBlock];
            }
        }];
    }else{
        [self tipNoParamWithBlock:completeBlock];
    }
}

/** 获取服务器当前时间 */
+ (void)getServerTime{
    /** 此处阻塞主线程，保证这个请求返回之前没有网络请求 */
    NSURL *url = [NSURL URLWithString:BASE_URL(ServerTime)];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[[NSOperationQueue alloc]init]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSInteger time = [dict[@"data"][@"time"] integerValue];
            [XWInstance shareInstance].timeDiff = [getCurrentTime(10) integerValue]  - time;
        }else{
            [XWNetworking netStatusChangedWithNoNetwork:NO];
        }
        dispatch_semaphore_signal(semaphore);//不管请求状态是什么，都得发送信号，否则会一直卡着进程
    }] resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
}

/** 检查系统版本 */
+ (void)checkAppVersion{
    [XWHttpSessionManager GET:BASE_URL(AppVersion) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        switch (statusCode) {
            case 200:{
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                NSInteger currentVersion = getVersionNumber(app_Version);
                NSInteger newestVersion = getVersionNumber(responseJson[@"data"][@"versionCode"]);
                NSString *information = responseJson[@"data"][@"information"];
                NSArray *array = [information componentsSeparatedByString:@"<br>"];
                NSString *message = [array componentsJoinedByString:@"\n"];
                if (currentVersion < newestVersion) {
                    BOOL mustUpdate = [responseJson[@"data"][@"is_force"] boolValue];
                    ;
                    if (mustUpdate) {
                        [XWPopupWindow popupWindowsWithTitle:@"检测到新版本" message:message leftTitle:@"前往更新" rightTitle:nil leftBlock:^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:responseJson[@"data"][@"version_url"]]];
                        } rightBlock:nil];
                    }else{
                        [XWPopupWindow popupWindowsWithTitle:@"检测到新版本" message:message leftTitle:@"前往更新" rightTitle:@"暂不更新" leftBlock:^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:responseJson[@"data"][@"version_url"]]];
                        } rightBlock:nil];
                    }
                }
            }break;
            default:
                break;
        }
    }];
}

/** 设置OSSClient */
+ (void)setupOSSClient{
    [XWHttpSessionManager GET:BASE_URL(OSS) parameters:nil extra:0 completeBlock:^(NSInteger statusCode, id responseJson, NSError *error) {
        switch (statusCode) {
            case 200:{
                NSString *AccessKeyId = responseJson[@"data"][@"Credentials"][@"AccessKeyId"];
                NSString *AccessKeySecret = responseJson[@"data"][@"Credentials"][@"AccessKeySecret"];
                NSString *SecurityToken = responseJson[@"data"][@"Credentials"][@"SecurityToken"];
                NSString *endpoint = @"http://oss-cn-shenzhen.aliyuncs.com";
                // 移动端建议使用STS方式初始化OSSClient。更多鉴权模式请参考后面的访问控制章节。
                id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:AccessKeyId secretKeyId:AccessKeySecret securityToken:SecurityToken];
                OSSClientConfiguration * conf = [OSSClientConfiguration new];
                conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
                conf.timeoutIntervalForRequest = 30; // 网络请求的超时时间
                conf.timeoutIntervalForResource = 24 * 60 * 60; // 允许资源传输的最长时间
                client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
                [XWAliOSSManager sharedInstance].client = client;
            }break;
            default:
                break;
        }
    }];
}

NSInteger getVersionNumber(NSString *version){
    NSArray *array = [version componentsSeparatedByString:@"."];
    NSInteger appVersion = 0;
    if (array.count == 1){
        appVersion = [array[0] integerValue] * 10000;
    }else if (array.count == 2){
        appVersion = [array[0] integerValue] * 10000 + [array[1] integerValue] * 100;
    }else if (array.count == 3){
        appVersion = [array[0] integerValue] * 10000 + [array[1] integerValue] * 100 + [array[2] integerValue];
    }
    return appVersion;
}

#pragma mark- 公共方法
+ (void)tipNoParamWithBlock:(void(^)(NSString *status))block{
    [self tips:@"缺失参数" bolck:block];
}

+ (void)tips:(NSString *)tip bolck:(void(^)(NSString *status))block{
    if (block) {
        block(tip);
    }
}

+ (void)succeed:(BOOL)succeed block:(void(^)(BOOL succeed))block{
    if (block) {
        block(succeed);
    }
}

/** 获取当前时间 */
NSString * getDateFormat(){
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd";
    return [formatter stringFromDate:date];
}

BOOL getIsLast(id responseJson){
    NSLog(@"current_page is %@, last_page is %@", responseJson[@"data"][@"current_page"], responseJson[@"data"][@"last_page"]);
    return [responseJson[@"data"][@"current_page"] integerValue] >= [responseJson[@"data"][@"last_page"] integerValue];
}

NSMutableDictionary * getPageDictionary(NSInteger page){
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:PageSize forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    
    return dict;
}

/** 无网络或连接不上服务器时显示 */
+ (void)netStatusChangedWithNoNetwork:(BOOL)noNetWork{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].keyWindow.rootViewController = [[NetworkViewController alloc] initWithNoNetwork:noNetWork];
    });
    
}

/** 点击了未开放功能时显示 */
void showForbid(){
    [XWPopupWindow popupWindowsWithTitle:@"禁止" message:@"该功能暂未开放" buttonTitle:@"好的" buttonBlock:nil];
    
}
/** 提示 */
void showTips(NSString *message){
    [XWPopupWindow popupWindowsWithTitle:@"提示" message:message buttonTitle:@"好的" buttonBlock:nil];
}
void todo(NSString *message){
    [XWPopupWindow popupWindowsWithTitle:@"提示" message:[NSString stringWithFormat:@"这是一个没有实现的功能，位置代码：%@",message] buttonTitle:@"好的" buttonBlock:nil];
}
void CompleteFunc(XWCompleteBlock completeBlock,id responseJson,NSArray *array){
    if (completeBlock) {
        completeBlock(array,[responseJson[@"data"][@"total"] integerValue],[responseJson[@"data"][@"current_page"] integerValue] >= [responseJson[@"data"][@"last_page"] integerValue]);
    }
}
@end
