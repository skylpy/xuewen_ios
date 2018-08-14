//
//  XWLearningModel.m
//  XueWen
//
//  Created by Karron Su on 2018/7/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWLearningModel.h"

@implementation XWLearningModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"courseId" : @"id",
             @"courseName" : @"course_name",
             @"tchOrg" : @"tch_org",
             @"coverPhoto" : @"cover_photo",
             @"coverPhotoAll" : @"cover_photo_all",
             @"courseType" : @"course_type",
             };
}

@end
