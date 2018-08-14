//
//  TransactionDetailsCell.h
//  XueWen
//
//  Created by ShaJin on 2017/11/16.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TransactionModel;
@interface TransactionDetailsCell : UITableViewCell

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) TransactionModel *model;

@end
