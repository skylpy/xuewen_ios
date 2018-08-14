//
//  XWCourseLabelModel.m
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCourseLabelModel.h"

@implementation XWCourseLabelModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"labelId" : @"id",
             @"labelName": @"label_name",
             @"labelPictureAll" : @"label_picture_all",
             @"labelPicture" : @"label_picture"
             };
}

@end
