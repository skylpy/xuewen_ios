//
//  ExamModel.m
//  XueWen
//
//  Created by ShaJin on 2017/12/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ExamModel.h"

@implementation ExamModel
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
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"creatTime"       : @"create_time",
             @"testName"        : @"course_name",
             @"testID"          : @"test_id",
             @"courseID"        : @"course_id",
             @"userID"          : @"user_id",
             @"rightCount"      : @"correct",
             @"errorCount"      : @"wrong",
             @"score"           : @"fraction",
             @"questions"       : @"content.data",
             @"companyID"       : @"company_id"
             };
}

+ (NSDictionary *)objectClassInArray{
    return @{@"questions" : @"QuestionsModel"};
}

- (void)setCreatTime:(NSString *)creatTime{
    _creatTime = [NSDate dateFormTimestamp:creatTime withFormat:nil];
}
@end
