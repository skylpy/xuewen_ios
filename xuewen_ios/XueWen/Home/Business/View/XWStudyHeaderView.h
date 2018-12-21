//
//  XWStudyHeaderView.h
//  XueWen
//
//  Created by Karron Su on 2018/7/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCountPlayTimeModel.h"
#import "XWTargetRankModel.h"
#import "XWRankViewController.h"

@interface XWStudyHeaderView : UIView

@property (nonatomic, strong) XWCountPlayTimeModel *rankModel;

@property (nonatomic, strong) XWTargetRankModel *goalModel;
@property (nonatomic, assign) RankControllerType type;

@end
