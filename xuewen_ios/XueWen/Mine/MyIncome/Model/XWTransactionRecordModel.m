//
//  XWTransactionRecordModel.m
//  XueWen
//
//  Created by Karron Su on 2018/9/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//
// 生成提现订单Model

#import "XWTransactionRecordModel.h"

@implementation XWTransactionRecordModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"payeeAccount" : @"payee_account",
             };
}

@end
