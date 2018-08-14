//
//  UIViewController+BackButtonHandler.m
//  happyselling
//
//  Created by Pingzi on 2017/8/3.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import "UIViewController+BackButtonHandler.h"

@implementation UIViewController (BackButtonHandler)

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [UIViewController getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

//获取除了UIAlertController的最顶层的VC
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    //    if ([rootVC presentedViewController]) {
    //        // 视图是被presented出来的
    //
    //        rootVC = [rootVC presentedViewController];
    //    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [UIViewController getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        
        XWNSLog(@"%@",[(UINavigationController *)rootVC topViewController]);
        
        // 根视图为UINavigationController
        if ([[(UINavigationController *)rootVC topViewController] isKindOfClass:[UIAlertController class]]) {
            UINavigationController *naviVC = (UINavigationController *)rootVC;
            currentVC = naviVC.viewControllers[naviVC.viewControllers.count - 2];
        }
        else
        {
            currentVC = [UIViewController getCurrentVCFrom:[(UINavigationController *)rootVC topViewController]];
        }
        
        
    }
    else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    return currentVC;
}
@end

@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // 取消 pop 后，复原返回按钮的状态
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}

@end
