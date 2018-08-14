//
//  ExamModel.h
//  XueWen
//
//  Created by ShaJin on 2017/12/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QuestionsModel;
@interface ExamModel : NSObject
/*
 "id":14,
 "test_id":1,
 "company_id":1,
 "course_id":189,
 "user_id":1,
 "correct":0,
 "wrong":6,
 "fraction":0,
 "count":1,
 "content":Array[6],
 "create_time":1513154524,
 "course_name":"营销三部曲之二：营销决策"
 */
/** 答题时间 */
@property (nonatomic, strong) NSString *creatTime;
/** 试卷名称 */
@property (nonatomic, strong) NSString *testName;
/** 试卷ID */
@property (nonatomic, strong) NSString *testID;
/** 试卷对应课程ID */
@property (nonatomic, strong) NSString *courseID;
/** 用户ID */
@property (nonatomic, strong) NSString *userID;
/** 答对题目数 */
@property (nonatomic, assign) NSInteger rightCount;
/** 搭错题目数 */
@property (nonatomic, assign) NSInteger errorCount;
/** 分数 */
@property (nonatomic, assign) NSInteger score;
/** 试题列表 */
@property (nonatomic, strong) NSArray<QuestionsModel *> *questions;
/** 公司ID */
@property (nonatomic, strong) NSString *companyID;
@end
