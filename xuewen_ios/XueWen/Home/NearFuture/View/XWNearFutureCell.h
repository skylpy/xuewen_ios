//
//  XWNearFutureCell.h
//  XueWen
//
//  Created by Karron Su on 2018/6/7.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCourseIndexModel.h"

@interface XWNearFutureCell : UITableViewCell

@property (nonatomic, strong) XWCourseIndexModel *model;

@property (nonatomic, assign) BOOL isLast;

@end
