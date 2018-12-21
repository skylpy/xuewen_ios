//
//  BannerModel.m
//  XueWen
//
//  Created by ShaJin on 2017/12/21.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
#import "BannerModel.h"

@implementation BannerModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"companyID"   : @"company_id",
             @"creatTime"   : @"create_time",
             @"imageID"   : @"id",
             @"desc"   : @"picture_desc",
             @"link"   : @"picture_link",
             @"sort"   : @"picture_sort",
             @"pictureUrl" : @"picture_url"
             };
}

- (void)setCreatTime:(NSString *)creatTime{
    _creatTime = [creatTime stringWithDataFormatter:nil];
}
@end
