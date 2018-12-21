//
//  XWFirmOrderCell.h
//  XueWen
//
//  Created by aaron on 2018/12/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCourseManageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XWFirmOrderCell : UITableViewCell

@property (nonatomic,strong) XWCourseManageModel * model;
@property (nonatomic,copy) void (^CourseManageClick)(XWCourseManageModel * cmodel);



@end

NS_ASSUME_NONNULL_END
