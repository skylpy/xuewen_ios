//
//  XWRankViewController.h
//  XueWen
//
//  Created by Karron Su on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"

typedef enum : NSUInteger {
    ControllerTypeWeek,
    ControllerTypeMonth,
    ControllerTypeAll,
} RankControllerType;
@interface XWRankViewController : XWBaseViewController

@property (nonatomic, assign) RankControllerType type;
/** 0 为学习排名 1 为目标排名*/
@property (nonatomic, assign) NSInteger index;

@end
