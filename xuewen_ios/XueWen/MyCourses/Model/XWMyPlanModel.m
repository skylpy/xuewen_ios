//
//  XWMyPlanModel.m
//  XueWen
//
//  Created by aaron on 2018/7/29.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWMyPlanModel.h"
#import "XWHttpSessionManager.h"
#import "CourseModel.h"
#import "XWNetworking.h"

@implementation XWMyPlanModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"todaylearningtime"      : @"today_learning_time",
             @"todaytestnum"      : @"today_test_num",
             @"sumnotenum"     : @"sum_note_num",
             @"sumtestnum"      : @"sum_test_num",
             @"sumviewnum"   : @"sum_view_num",
             @"sumlearningtime"    : @"sum_learning_time",
             @"learning"   : @"learning"
             };
}

+ (NSDictionary *)objectClassInArray{
    return @{@"learning" : @"XWMyPlanRecordsModel"};
}

@end

@implementation XWMyPlanRecordsModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"date"        : @"data",
             @"studyTime"      : @"study_time"
             };
}

@end
