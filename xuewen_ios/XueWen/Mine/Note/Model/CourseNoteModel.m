//
//  CourseNoteModel.m
//  XueWen
//
//  Created by ShaJin on 2017/12/19.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "CourseNoteModel.h"

@implementation CourseNoteModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"noteID"          : @"id",
             @"courseID"        : @"course_id",
             @"content"         : @"notes_content",
             @"creatTime"       : @"create_time",
             @"nickName"        : @"nick_name",
             @"companyID"       : @"company_id",
             @"picture"         : @"picture_all",
             @"courseName"      : @"course_name"
             };
}

- (void)setCreatTime:(NSString *)creatTime{
    _creatTime = [creatTime translateDateFormatter:@"yyyy-MM-dd"];
    _creatDate = [creatTime stringWithDataFormatter:@"yyyy-MM-dd"];
}
@end
