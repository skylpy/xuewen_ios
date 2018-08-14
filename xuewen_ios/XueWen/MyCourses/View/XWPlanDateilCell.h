//
//  XWPlanDateilCell.h
//  XueWen
//
//  Created by aaron on 2018/7/29.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearningPlanModel.h"

@interface XWPlanDateilCell : UITableViewCell

@property (nonatomic,strong) LearningPlanModel * model;

@end

@interface XWPlanProgressCell : UITableViewCell

@property (nonatomic,strong) LearningPlanInfoModel * model;

@end
