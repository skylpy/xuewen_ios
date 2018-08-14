//
//  ProjectModel.m
//  XueWen
//
//  Created by ShaJin on 2018/1/24.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ProjectModel.h"

@implementation ProjectModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"projectID"       : @"id",
             @"projectName"     : @"label_name",
             @"picture"         : @"cover_all",
             @"price"           : @"amount",
             @"projects"        : @"thematic_info",
             @"courses"         : @"course_info",
             @"originalPrice"  : @"original_price"
             };
}

+ (NSDictionary *)objectClassInArray{
    return @{
             @"projects" : @"ProjectModel",
             @"courses" : @"CourseModel"
             };
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.projectID     forKey:@"projectID"];
    [aCoder encodeObject:self.projectName   forKey:@"projectName"];
    [aCoder encodeObject:self.introduction  forKey:@"introduction"];
    [aCoder encodeObject:self.picture       forKey:@"picture"];
    [aCoder encodeObject:self.price         forKey:@"price"];
    [aCoder encodeBool:self.buy             forKey:@"buy"];
    [aCoder encodeObject:self.projects      forKey:@"projects"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.projectID =        [aDecoder decodeObjectForKey:@"projectID"];
        self.projectName =      [aDecoder decodeObjectForKey:@"projectName"];
        self.introduction =     [aDecoder decodeObjectForKey:@"introduction"];
        self.picture =          [aDecoder decodeObjectForKey:@"picture"];
        self.price =            [aDecoder decodeObjectForKey:@"price"];
        self.buy =              [aDecoder decodeBoolForKey:@"buy"];
        self.projects =         [aDecoder decodeObjectForKey:@"projects"];
    }
    return self;
}
@end
