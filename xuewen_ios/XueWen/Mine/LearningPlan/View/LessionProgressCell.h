//
//  LessionProgressCell.h
//  XueWen
//
//  Created by ShaJin on 2017/12/25.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LearningPlanInfoModel;
@interface LessionProgressCell : UITableViewCell

@property (nonatomic, strong) LearningPlanInfoModel *model;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isLast;

@end
