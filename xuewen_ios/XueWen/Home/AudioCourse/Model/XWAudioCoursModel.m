//
//  XWAudioCoursModel.m
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWAudioCoursModel.h"

@implementation XWAudioCoursModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"courseId" : @"id",
             @"tchOrg" : @"tch_org",
             @"courseName" : @"course_name",
             @"timeLength" : @"time_length",
             @"favorablePrice" : @"favorable_price",
             @"coverPhoto" : @"cover_photo",
             @"coverPhotoAll" : @"cover_photo_all",
             @"pictureAll" : @"picture_all",
             @"courseAudioArray" : @"course_audio",
             @"courseType" : @"course_type"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"courseAudioArray" : [XWAudioNodeModel class]};
}

@end
