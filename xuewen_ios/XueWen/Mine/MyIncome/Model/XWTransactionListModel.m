//
//  XWTransactionListModel.m
//  XueWen
//
//  Created by Karron Su on 2018/9/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//
// 提现记录Model
#import "XWTransactionListModel.h"

@implementation XWTransactionListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"createTime" : @"create_time",
             @"reviewStatus" : @"review_status",
             };
}

@end
