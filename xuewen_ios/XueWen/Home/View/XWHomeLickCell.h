//
//  XWHomeLickCell.h
//  XueWen
//
//  Created by Karron Su on 2018/7/20.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCourseIndexModel.h"

@interface XWHomeLickCell : UITableViewCell

@property (nonatomic, strong) XWCourseIndexModel *model;

@property (nonatomic, assign) BOOL hideLine;

@end
