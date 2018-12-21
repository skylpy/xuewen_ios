//
//  XWNoneRedPakeView.h
//  XueWen
//
//  Created by aaron on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWRedPakModel.h"

//定义枚举类型
typedef enum {
    InvitationType  = 0,
    goodType = 1,
    refushType = 2,
    errorType = 4000,
    noneType 
} NoneRedType;


@interface XWNoneRedPakeView : UIView

+ (instancetype)shareNoneRedPakeView;
- (void)showFromView:(UIView *)superView withState:(NSString *)state withGoSeeClick:(void (^)(NoneRedType type,RedBackType rtype))goSeeClick ;

@end
