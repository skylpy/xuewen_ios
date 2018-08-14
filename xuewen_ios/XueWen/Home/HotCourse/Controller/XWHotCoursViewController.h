//
//  XWHotCoursViewController.h
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
@interface XWHotCoursViewController : XWBaseViewController

@property (nonatomic, assign) RankControllerType type;

@end
