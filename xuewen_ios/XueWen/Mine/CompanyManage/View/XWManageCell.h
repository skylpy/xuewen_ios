//
//  XWManageCell.h
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWManageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XWManageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (nonatomic,strong) XWManageModel * model;

@end

NS_ASSUME_NONNULL_END
