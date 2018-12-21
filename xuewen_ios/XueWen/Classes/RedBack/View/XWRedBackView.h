//
//  XWRedBackView.h
//  XueWen
//
//  Created by aaron on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWRedPakModel.h"

@interface XWRedBackView : UIView

+ (instancetype)shareRedBackView;

- (void)showFromView:(UIView *)superView withMoney:(NSString *)money withTestClick:(void (^)(RedBackType type))goSeeClick ;

@end
