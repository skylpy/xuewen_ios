//
//  XWCourseCell.h
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCourseManageModel.h"
#import "CAShapeLayer+XWLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface XWCourseTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;
@property (weak, nonatomic) IBOutlet UIView *maskView;
//已购
@property (nonatomic,strong) XWCourseManageModel * model;
//收藏
@property (nonatomic,strong) XWCourseManageModel * cmodel;
//课程库
@property (nonatomic,strong) XWCourseManageModel * libmodel;

@property (nonatomic,copy) void (^functionClick)(void);
@property (nonatomic,copy) void (^hideBtnClick)(NSString * cid);

@end

NS_ASSUME_NONNULL_END
