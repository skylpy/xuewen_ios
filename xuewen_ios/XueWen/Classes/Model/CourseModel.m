//
//  CourseModel.m
//  XueWen
//
//  Created by ShaJin on 2017/11/24.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "CourseModel.h"
@implementation CourseProjectModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"projectID"       : @"id",
             @"picture"         : @"cover"
             };
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.projectID         forKey:@"projectID"];
    [aCoder encodeObject:self.picture           forKey:@"picture"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.projectID =    [aDecoder decodeObjectForKey:@"projectID"];
        self.picture =      [aDecoder decodeObjectForKey:@"picture"];
    }
    return self;
}
@end

@implementation CourseLabelModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"labelID"     : @"id",
             @"labelName"   : @"label_name",
             @"thematics"   : @"thematic_info"
            };
}

+ (NSDictionary *)objectClassInArray{
    return @{
             @"children"    : @"CourseLabelModel",
             @"thematics"   : @"CourseProjectModel"
             };
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.labelID       forKey:@"labelID"];
    [aCoder encodeObject:self.labelName     forKey:@"labelName"];
    [aCoder encodeObject:self.pid           forKey:@"pid"];
    [aCoder encodeObject:self.children      forKey:@"children"];
    [aCoder encodeObject:self.thematics     forKey:@"thematics"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.labelID =      [aDecoder decodeObjectForKey:@"labelID"];
        self.labelName =    [aDecoder decodeObjectForKey:@"labelName"];
        self.pid =          [aDecoder decodeObjectForKey:@"pid"];
        self.children =     [aDecoder decodeObjectForKey:@"children"];
        self.thematics =    [aDecoder decodeObjectForKey:@"thematics"];
    }
    return self;
}

- (instancetype)copy{
    CourseLabelModel *label = [CourseLabelModel new];
    label.labelID = self.labelID;
    label.labelName = self.labelName;
    label.pid = self.pid;
    label.children = [NSArray arrayWithArray:self.children];
    return label;
}
@end
@implementation CourseModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"courseID"            : @"id",
             @"courseName"          : @"course_name",
             @"labelID"             : @"lable_id",
             @"labelName"           : @"lable_name",
             @"coverPhoto"          : @"cover_photo_all",
             @"price"               : @"amount",
             @"timeLength"          : @"time_length",
             @"introduction"        : @"introduction",
             @"teacherName"         : @"tch_org",
             @"teacherPhoto"        : @"tch_org_photo",
             @"teacherIntroduction" : @"tch_org_introduction",
             @"createTime"          : @"create_time",
             @"lessions"            : @"course_node",
             @"updateTime"          : @"update_time",
             @"percentage"          : @"Percentage",
             @"isOptional"          : @"course_type",
             @"learningTime"        : @"learning_time",
             @"hisID"               : @"course_id",
             @"courseType"          : @"course_type"
             };
}

@end
