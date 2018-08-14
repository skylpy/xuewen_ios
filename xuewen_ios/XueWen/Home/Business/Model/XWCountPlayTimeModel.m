//
//  XWCountPlayTimeModel.m
//  XueWen
//
//  Created by Karron Su on 2018/7/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCountPlayTimeModel.h"

@implementation XWCountPlayTimeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"totalTime" : @"total_time",
             @"departmentName" : @"department_name",
             @"userId" : @"id",
             @"coverPictureAll" : @"picture_all",
             @"fabulousType" : @"fabulous_type",
             };
}


@end
