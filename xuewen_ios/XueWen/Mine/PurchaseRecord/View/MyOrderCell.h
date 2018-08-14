//
//  MyOrderCell.h
//  XueWen
//
//  Created by ShaJin on 2017/12/19.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@protocol MyOrderCellDelegate <NSObject>

- (void)payOrder:(OrderModel *)model;

- (void)cancelOrder:(OrderModel *)model;

@end
@interface MyOrderCell : UITableViewCell

@property (nonatomic, strong) OrderModel *model;
@property (nonatomic, weak) id<MyOrderCellDelegate> delegate;

@end
