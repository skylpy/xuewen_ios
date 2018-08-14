//
//  LearningPlanModel.h
//  XueWen
//
//  Created by ShaJin on 2017/12/27.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LearningPlanInfoModel : NSObject
/**
 "id":79,
 "course_name":"二代怎样接班",
 "count":29,
 "v":0,
 "rate":0
 */
/** 课程ID */
@property (nonatomic, strong) NSString *courseID;
/** 课程名称 */
@property (nonatomic, strong) NSString *courseName;
/** 课程节点数 */
@property (nonatomic, strong) NSString *lessionCount;
/** 已看节点数 */
@property (nonatomic, strong) NSString *viewedCount;
/** 课程进度 */
@property (nonatomic, strong) NSString *progress;

@property (nonatomic, strong) NSString *timeLength;

@property (nonatomic, strong) NSString *tchOrg;

@property (nonatomic, strong) NSString *testId;

@property (nonatomic, strong) NSString *correct;

@property (nonatomic, strong) NSString *wrong;

@property (nonatomic, strong) NSString *fraction;

@property (nonatomic, strong) NSString *testCount;

@property (nonatomic, strong) NSString *courseId;

@property (nonatomic, strong) NSString *coverPhoto;

@property (nonatomic, strong) NSString *coverPhotoAll;

@end
@interface LearningPlanModel : NSObject
/**
 "id": 12,
 "plan_id": 3,
 "label_id": 0,
 "user_id": 84,
 "company_id": 37,
 "name": "沙金",
 "label_name": null,
 "post": "员工",
 "course_count": 3,
 "schedule": 0,
 "schedule_info": {
 "79": {5 items},
 "104": {5 items},
 "140": {5 items}
 },
 "finish_time": null,
 "create_time": 1514284134,
 "title": "测试学习计划",
 "time_s": 1514217600,
 "time_e": 1517241600,
 "all_insert_time": 1514284134,
 "status": 1
 */

/** 数据ID */
@property (nonatomic, strong) NSString *dataID;
/** 计划ID */
@property (nonatomic, strong) NSString *planID;
/** 标签ID */
@property (nonatomic, strong) NSString *labelID;
/** 用户ID */
@property (nonatomic, strong) NSString *userID;
/** 公司ID */
@property (nonatomic, strong) NSString *companyID;
/** 用户名（真实） */
@property (nonatomic, strong) NSString *userName;
/** 标签名 */
@property (nonatomic, strong) NSString *labelName;
/** 岗位名称 */
@property (nonatomic, strong) NSString *post;
/** 课程总数 */
@property (nonatomic, strong) NSString *courseCount;
/** 计划进度 */
@property (nonatomic, strong) NSString *schedule;
/** 进度详情 */
@property (nonatomic, strong) NSArray<LearningPlanInfoModel *> *scheduleInfo;
/** 创建时间 */
@property (nonatomic, strong) NSString *creatTime;
/** 计划标题 */
@property (nonatomic, strong) NSString *palnTitle;
/** 计划开始时间 */
@property (nonatomic, strong) NSString *startTime;
/** 计划结束时间 */
@property (nonatomic, strong) NSString *endTime;
/** 计划完成时间（已完成才会出现） */
@property (nonatomic, strong) NSString *finishTime;
/** 计划状态
	0	未开始
 1	进行中
 2	已完成
 3	已结束 */
@property (nonatomic, strong) NSString *status;
//计划周期
@property (nonatomic, strong) NSString *planningCycle;
//完成课程数
@property (nonatomic, strong) NSString *completeCourse;

@end
