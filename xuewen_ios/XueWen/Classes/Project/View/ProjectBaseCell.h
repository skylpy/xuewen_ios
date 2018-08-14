//
//  ProjectBaseCell.h
//  XueWen
//
//  Created by ShaJin on 2018/1/24.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"
@interface ProjectBaseCell : UITableViewCell

@property (nonatomic, strong) ProjectModel *model;
@property (nonatomic, assign) CGFloat cellHeight;

@end
