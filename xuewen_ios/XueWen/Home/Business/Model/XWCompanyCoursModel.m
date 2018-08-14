//
//  XWCompanyCoursModel.m
//  XueWen
//
//  Created by Karron Su on 2018/7/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCompanyCoursModel.h"

@implementation XWCompanyCoursModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"courseId" : @"id",
             @"courseName" : @"course_name",
             @"companyId" : @"company_id",
             @"coverPhoto" : @"cover_photo",
             @"coverPhotoAll" : @"cover_photo_all",
             @"userId" : @"user_id",
             @"courseType" : @"course_type",
             };
}

@end
