//
//  ClassesListViewController.h
//  XueWen
//
//  Created by ShaJin on 2017/11/15.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWListViewController.h"
@class CourseLabelModel;
@interface ClassesListViewController : XWListViewController

- (instancetype)initWithCourseMode:(CourseLabelModel *)model;
/** 从外部设置排序 */
- (void)externalSetOrderTtpe:(NSString *)orderType;
@end
