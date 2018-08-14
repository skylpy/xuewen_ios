//
//  UIViewController+BackButtonHandler.h
//  happyselling
//
//  Created by Pingzi on 2017/8/3.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
- (BOOL)navigationShouldPopOnBackButton;
@end


@interface UIViewController (BackButtonHandler)<BackButtonHandlerProtocol>



//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

//-(void)setRight

@end
