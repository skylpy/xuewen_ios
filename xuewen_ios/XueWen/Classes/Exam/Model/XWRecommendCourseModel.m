//
//  XWRecommendCourseModel.m
//  XueWen
//
//  Created by Karron Su on 2018/7/5.
//  Copyright © 2018年 KarronSu. All rights reserved.
//
// 个人课程标签推荐Model

#import "XWRecommendCourseModel.h"

@implementation XWRecommendCourseModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"courseID" : @"id",
             @"courseName" : @"course_name",
             @"coverPhotoAll" : @"cover_photo_all",
             @"coverPhoto" : @"cover_photo"
             };
}

@end
