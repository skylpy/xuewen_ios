//
//  XWPlanDateilViewController.h
//  XueWen
//
//  Created by aaron on 2018/7/29.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"
#import "LearningPlanModel.h"

@interface XWPlanDateilViewController : XWBaseViewController

@property (nonatomic,strong) LearningPlanModel * model;

@end

@interface XWPlanSectorCell : UITableViewCell

@property (nonatomic,strong) LearningPlanModel * model;

@end
