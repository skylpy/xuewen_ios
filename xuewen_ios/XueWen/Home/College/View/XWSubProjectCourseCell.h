//
//  XWSubProjectCourseCell.h
//  XueWen
//
//  Created by Karron Su on 2018/8/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

@interface XWSubProjectCourseCell : UITableViewCell

@property (nonatomic, strong) CourseModel *model;
@property (nonatomic, assign) BOOL buy;

@end
