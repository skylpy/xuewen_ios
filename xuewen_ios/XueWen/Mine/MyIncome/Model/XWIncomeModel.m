//
//  XWIncomeModel.m
//  XueWen
//
//  Created by Karron Su on 2018/9/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWIncomeModel.h"

@implementation XWIncomeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId" : @"user_id",
             @"userPid" : @"user_pid",
             @"createTime" : @"create_time",
             @"pictureAll" : @"picture_all",
             @"commissionPrice" : @"commission_price",
             @"orderPrice" : @"order_price",
             };
}

@end
