//
//  XWTransactionRecordModel.h
//  XueWen
//
//  Created by Karron Su on 2018/9/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//
// 生成提现订单Model

#import <Foundation/Foundation.h>

@interface XWTransactionRecordModel : NSObject

/**提现金额*/
@property (nonatomic, strong) NSString *price;
/** 提现账号*/
@property (nonatomic, strong) NSString *payeeAccount;
/** 提现时间*/
@property (nonatomic, strong) NSString *time;

@end
