//
//  LearningPlanModel.m
//  XueWen
//
//  Created by ShaJin on 2017/12/27.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "LearningPlanModel.h"
@implementation LearningPlanInfoModel

/**
 "id":79,
 "course_name":"二代怎样接班",
 "count":29,
 "v":0,
 "rate":0
 */
/** 课程ID */
//@property(nonatomic,strong)NSString *courseID;
///** 课程名称 */
//@property(nonatomic,strong)NSString *courseName;
///** 课程节点数 */
//@property(nonatomic,strong)NSString *lessionCount;
///** 已看节点数 */
//@property(nonatomic,strong)NSString *viewedCount;
///** 课程进度 */
//@property(nonatomic,strong)NSString *progress;

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"courseID"        : @"id",
             @"courseName"      : @"course_name",
             @"lessionCount"    : @"count",
             @"viewedCount"     : @"v",
             @"progress"        : @"rate",
             @"timeLength"        : @"time_length",
             @"tchOrg"        : @"tch_org",
             @"testId"        : @"test_id",
             @"correct"        : @"correct",
             @"wrong"        : @"wrong",
             @"fraction"        : @"fraction",
             @"testCount"        : @"test_count",
             @"courseId"        : @"course_id",
             @"coverPhoto"        : @"cover_photo",
             @"coverPhotoAll"        : @"cover_photo_all"
             };
}

@end

@implementation LearningPlanModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"dataID"      : @"id",
             @"planID"      : @"plan_id",
             @"labelID"     : @"label_id",
             @"userID"      : @"user_id",
             @"companyID"   : @"company_id",
             @"userName"    : @"name",
             @"labelName"   : @"label_name",
             @"courseCount" : @"course_count",
             @"scheduleInfo": @"schedule_info",
             @"creatTime"   : @"create_time",
             @"palnTitle"   : @"title",
             @"startTime"   : @"time_s",
             @"endTime"     : @"time_e",
             @"planningCycle"     : @"planning_cycle",
             @"completeCourse"     : @"complete_course"
             };
}

+ (NSDictionary *)objectClassInArray{
    return @{@"scheduleInfo" : @"LearningPlanInfoModel"};
}

- (void)setStartTime:(NSString *)startTime{
    _startTime = startTime;//[startTime stringWithDataFormatter:@"yyyy-MM-dd"];
}

- (void)setEndTime:(NSString *)endTime{
    _endTime = endTime;//[endTime stringWithDataFormatter:@"yyyy-MM-dd"];
}
@end
