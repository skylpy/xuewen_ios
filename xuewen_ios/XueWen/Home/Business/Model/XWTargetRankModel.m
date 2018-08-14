//
//  XWTargetRankModel.m
//  XueWen
//
//  Created by Karron Su on 2018/7/29.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWTargetRankModel.h"

@implementation XWTargetRankModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"userId" : @"id",
             @"companyId" : @"company_id",
             @"departmentName" : @"department_name",
             @"finishTime" : @"finish_time",
             @"createTime" : @"create_time",
             @"pictureAll" : @"picture_all",
             @"fabulousType" : @"fabulous_type",
             };
}

@end
