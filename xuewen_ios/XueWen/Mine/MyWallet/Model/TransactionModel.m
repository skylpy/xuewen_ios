//
//  TransactionModel.m
//  XueWen
//
//  Created by ShaJin on 2017/12/5.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "TransactionModel.h"

@implementation TransactionModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"orderID"     : @"order_id",
             @"title"       : @"body",
             @"creatTime"   : @"create_time"
             };
}
@end
