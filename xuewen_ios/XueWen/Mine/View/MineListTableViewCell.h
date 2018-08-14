//
//  MineListTableViewCell.h
//  XueWen
//
//  Created by Pingzi on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCellModel.h"

@interface MineListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVLading;
@property (weak, nonatomic) IBOutlet UIImageView *imgVWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLBToImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLBToRight;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) BaseCellModel *model;

@end
