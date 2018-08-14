//
//  XWCoursModel.m
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCoursModel.h"

@implementation XWCoursModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"courseId" : @"id",
             @"coverPhoto" : @"cover_photo",
             @"coverPhotoAll" : @"cover_photo_all",
             @"courseName" : @"course_name",
             @"timeLength" : @"time_length",
             @"favorablePrice" : @"favorable_price",
             @"createTime" : @"create_time",
             @"testID" : @"test_id",
             @"peopleNum" : @"people_num",
             @"courseType" : @"course_type",
             @"courseShelves" : @"course_shelves",
             @"tchOrgPhoto" : @"tch_org_photo",
             @"tchOrgIntroduction" : @"tch_org_introduction",
             @"tchOrg" : @"tch_org",
             @"userID" : @"user_id",
             @"teacherProfile" : @"teacher_profile",
             @"tchOrgPhotoAll" : @"tch_org_photo_all",
             
             };
}



@end
