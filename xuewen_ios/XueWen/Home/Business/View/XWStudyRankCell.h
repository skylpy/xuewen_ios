//
//  XWStudyRankCell.h
//  XueWen
//
//  Created by Karron Su on 2018/7/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCountPlayTimeModel.h"
#import "XWTargetRankModel.h"


@interface XWStudyRankCell : UITableViewCell

@property (nonatomic, assign) BOOL isLast;

@property (nonatomic, strong) XWCountPlayTimeModel *model;

@property (nonatomic, strong) XWTargetRankModel *targetModel;

@property (nonatomic, assign) NSInteger idx;


@end
