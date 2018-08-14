//
//  XWNearFutureViewController.h
//  XueWen
//
//  Created by Karron Su on 2018/6/7.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"

typedef enum : NSUInteger {
    ControllerTypeNear,
    ControllerTypeHot,
} ControllerType;

@interface XWNearFutureViewController : XWBaseViewController

@property (nonatomic, assign) ControllerType type;

@end
