//
//  XWHotCoursTableCell.h
//  XueWen
//
//  Created by Karron Su on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCourseIndexModel.h"

@interface XWHotCoursTableCell : UITableViewCell

@property (nonatomic, assign) BOOL isLast;

@property (nonatomic, strong) XWCourseIndexModel *model;

@property (nonatomic, assign) NSInteger idx;

@end
