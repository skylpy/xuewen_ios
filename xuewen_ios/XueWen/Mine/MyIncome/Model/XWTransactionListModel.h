//
//  XWTransactionListModel.h
//  XueWen
//
//  Created by Karron Su on 2018/9/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//
// 提现记录Model
#import <Foundation/Foundation.h>

@interface XWTransactionListModel : NSObject

/** 金额*/
@property (nonatomic, strong) NSString *price;
/** 时间*/
@property (nonatomic, strong) NSString *createTime;
/** 状态*/
@property (nonatomic, strong) NSString *reviewStatus;

@end
