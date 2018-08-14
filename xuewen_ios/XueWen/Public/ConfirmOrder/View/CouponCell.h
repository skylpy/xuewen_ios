//
//  CouponCell.h
//  XueWen
//
//  Created by ShaJin on 2018/3/5.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CouponModel;
@interface CouponCell : UITableViewCell

@property (nonatomic, strong) CouponModel *model;
@property (nonatomic, assign) BOOL hasSelect;

@end
