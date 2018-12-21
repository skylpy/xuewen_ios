//
//  XWRedRandCell.h
//  XueWen
//
//  Created by aaron on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWRedPakModel.h"
@interface XWRedRandCell : UITableViewCell

@property (nonatomic,strong) XWRedPakListModel * model;
@property (nonatomic,strong) NSIndexPath * indexPath;

@end
