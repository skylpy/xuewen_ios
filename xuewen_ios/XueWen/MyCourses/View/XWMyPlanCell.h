//
//  XWMyPlanCell.h
//  XueWen
//
//  Created by aaron on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearningPlanModel.h"

@interface XWMyPlanCell : UITableViewCell

@property (nonatomic,strong) LearningPlanModel * model;

@property (nonatomic,copy) void (^moreMyPlanClick)(void);

@property (nonatomic,copy) void (^couresDateilClick)(NSString * cid);

@end
