//
//  XWCourseIndexModel.m
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCourseIndexModel.h"

@implementation XWCourseIndexModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"courseId" : @"id",
             @"userId" : @"user_id",
             @"courseName" : @"course_name",
             @"timeLength" : @"time_length",
             @"favorablePrice" : @"favorable_price",
             @"coverPhoto" : @"cover_photo",
             @"coverPhotoAll" : @"cover_photo_all",
             @"courseType" : @"course_type",
             @"pictureAll" : @"tch_org_photo_all",
             @"teacherProfile" : @"tch_org_introduction",
             @"shelvesTime" : @"shelves_time",
             @"shortIntroduction" : @"short_introduction",
             @"name" : @"tch_org",
             };
}


@end
