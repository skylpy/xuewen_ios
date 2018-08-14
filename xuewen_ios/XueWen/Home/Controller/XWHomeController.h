//
//  XWHomeController.h
//  XueWen
//
//  Created by Karron Su on 2018/7/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "YNPageViewController.h"
//#import "SPCoverController.h"

@interface XWHomeController : YNPageViewController
//@interface XWHomeController : SPCoverController

+ (instancetype)homePageVC;

+ (instancetype)homePageVCWithConfig:(YNPageConfigration *)config;

- (void)tabbarDoubleClick;

@end
