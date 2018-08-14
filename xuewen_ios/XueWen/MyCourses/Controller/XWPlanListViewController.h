//
//  XWPlanListViewController.h
//  XueWen
//
//  Created by aaron on 2018/7/29.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"

typedef enum : NSUInteger {
    executionType = 1,//执行中
    finishType = 2,//已完成
    overdueType = 3,//已过期
} PlanStatusType;

@interface XWPlanListViewController : XWBaseViewController

@end

@interface XWPlanListHeaderView :UIView

@property (copy,nonatomic) void (^planListHeaderClick)(PlanStatusType type);

- (void)executionNum:(NSString *)exe withFinish:(NSString *)fis withOverdue:(NSString *)over;

@end
