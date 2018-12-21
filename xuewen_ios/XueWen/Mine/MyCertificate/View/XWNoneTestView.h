//
//  XWNoneTestView.h
//  XueWen
//
//  Created by aaron on 2018/8/20.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWNoneTestView : UIView

+ (instancetype)shareNoneTestView;
- (void)showFromView:(UIView *)superView withTestClick:(void (^)(void))testClick;


@end
