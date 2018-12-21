//
//  ClassesInfoCell.h
//  XueWen
//
//  Created by ShaJin on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CourseModel;
@class ProjectModel;
@interface ClassesInfoCell : UITableViewCell

@property (nonatomic, strong) CourseModel *model;
@property (nonatomic, assign) BOOL showPrograss;
/** 设置我的订单页面cell的内容，只能设置课程或项目的其中一个，另一个传nil。两个同时传显示课程的内容 */
- (void)setCourse:(CourseModel *)course project:(ProjectModel *)project superOrg:(CourseModel *)superOrg price:(NSString *)price;

@end
