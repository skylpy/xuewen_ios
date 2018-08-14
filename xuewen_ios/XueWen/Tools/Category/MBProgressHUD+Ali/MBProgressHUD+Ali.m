//
//  MBProgressHUD+Ali.m
//  intelMeeting
//
//  Created by Mr.Aaron on 2018/1/18.
//  Copyright © 2018年 张子恒. All rights reserved.
//

#import "MBProgressHUD+Ali.h"
#import "UIViewController+BackButtonHandler.h"


@implementation MBProgressHUD (Ali)

+ (MBProgressHUD*)createMBProgressHUDviewTitle:(NSString * )title WithMessage:(NSString*)message isWindiw:(BOOL)isWindow {
    
    UIView  *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:[UIViewController getCurrentVC].view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text=title?title:@"加载中.....";
    hud.label.numberOfLines = 0;
    hud.detailsLabel.text = message?message:@"";
    hud.label.font=[UIFont fontWithName:kRegFont size:15];
    hud.label.textColor = [UIColor whiteColor];
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    //修改样式，否则等待框背景色将为半透明
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //设置等待框背景色为黑色
    hud.bezelView.backgroundColor = [UIColor blackColor];
    //设置菊花的颜色
    hud.activityIndicatorColor = [UIColor whiteColor];
    //设置文本颜色属性
    hud.contentColor = [UIColor whiteColor];
    
    return hud;
}

#pragma mark-------------------- show Tip----------------------------

+ (void)showTipMessageInWindow:(NSString*)message {
    
    [self showTipMessage:message isWindow:true timer:1.0];
}

+ (void)showTipMessageInView:(NSString*)message {
    
    [self showTipMessage:message isWindow:false timer:1.0];
}

+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer {
    
    [self showTipMessage:message isWindow:true timer:aTimer];
}

+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer completionBlock:(void(^)(void))comBlock{
    
    [self showTipMessage:message isWindow:true timer:aTimer completionBlock:^{
        !comBlock?:comBlock();
    }];
}

+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer {
    
    [self showTipMessage:message isWindow:false timer:aTimer];
}

+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer completionBlock:(void(^)(void))comBlock{
    
    [self showTipMessage:message isWindow:false timer:aTimer completionBlock:^{
        !comBlock?:comBlock();
    }];
}

+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer {

    MBProgressHUD *hud = [self createMBProgressHUDviewTitle:message WithMessage:nil isWindiw:isWindow];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:1];
}

+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer completionBlock:(void(^)(void))comBlock
{
    
    MBProgressHUD *hud = [self createMBProgressHUDviewTitle:message WithMessage:nil isWindiw:isWindow];
    hud.completionBlock = ^{
        !comBlock?:comBlock();
    };
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:aTimer];
}



#pragma mark-------------------- show two Tip----------------------------

+ (void)showTipMessageInWindowTitle:(NSString*)title withMessage:(NSString *)message {
    
    [self showTipTitle:title withMessage:message isWindow:true timer:1.0];
}

+ (void)showTipMessageInViewTitle:(NSString*)title withMessage:(NSString *)message {
    
    [self showTipTitle:title withMessage:message isWindow:false timer:1.0];
}

+ (void)showTipMessageInWindowTitle:(NSString*)title withMessage:(NSString *)message timer:(int)aTimer {
    
    [self showTipTitle:title withMessage:message isWindow:true timer:aTimer];
}

+ (MBProgressHUD *)showTipMessageInViewTitle:(NSString*)title withMessage:(NSString *)message timer:(int)aTimer {
    
   return [self showTipTitle:title withMessage:message isWindow:false timer:aTimer];
}

+ (MBProgressHUD *)showTipTitle:(NSString*)title withMessage:(NSString *)message isWindow:(BOOL)isWindow timer:(int)aTimer {

    MBProgressHUD *hud = [self createMBProgressHUDviewTitle:title WithMessage:message isWindiw:isWindow];
    hud.mode = MBProgressHUDModeText;
    
    [hud hideAnimated:YES afterDelay:1];
    return hud;
}

+ (void)showTipMessageInWindowTitle:(NSString*)title withMessage:(NSString *)message timer:(int)aTimer completionBlock:(void(^)(void))comBlock{
    
    [self showTipTitle:title withMessage:message isWindow:true timer:aTimer completionBlock:^{
        !comBlock?:comBlock();
    }];
}

+ (MBProgressHUD *)showTipMessageInViewTitle:(NSString*)title withMessage:(NSString *)message timer:(int)aTimer completionBlock:(void(^)(void))comBlock{
    
    return [self showTipTitle:title withMessage:message isWindow:false timer:aTimer completionBlock:^{
        !comBlock?:comBlock();
    }];
}

+ (MBProgressHUD *)showTipTitle:(NSString*)title withMessage:(NSString *)message isWindow:(BOOL)isWindow timer:(int)aTimer completionBlock:(void(^)(void))comBlock{
    
    MBProgressHUD *hud = [self createMBProgressHUDviewTitle:title WithMessage:message isWindiw:isWindow];
    hud.mode = MBProgressHUDModeText;
    hud.completionBlock = ^{
        !comBlock?:comBlock();
    };
    
    [hud hideAnimated:YES afterDelay:1];
    return hud;
}

#pragma mark-------------------- show Activity----------------------------

+ (void)showActivityMessageInWindow:(NSString*)message {
    
    [self showActivityMessage:message isWindow:true timer:0];
}

+ (void)showActivityMessageInView:(NSString*)message {
    
    [self showActivityMessage:message isWindow:false timer:0];
}

+ (void)showActivityMessageInWindow:(NSString*)message timer:(int)aTimer {
    
    [self showActivityMessage:message isWindow:true timer:aTimer];
}

+ (void)showActivityMessageInView:(NSString*)message timer:(int)aTimer {
    
    [self showActivityMessage:message isWindow:false timer:aTimer];
}

+ (void)showActivityMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer {

    MBProgressHUD *hud  =  [self createMBProgressHUDviewTitle:message WithMessage:nil isWindiw:isWindow];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    if (aTimer>0) {
        [hud hideAnimated:YES afterDelay:aTimer];
    }
}

#pragma mark-------------------- show Image----------------------------

+ (void)showSuccessMessage:(NSString *)Message {
    
    [self showCustomIconInWindow:@"MBHUD_Success" message:Message];
}

//+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow {
//    
//    MBProgressHUD *hud  =  [self createMBProgressHUDviewTitle:message WithMessage:nil isWindiw:isWindow];
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"Resource.bundle/Contents/Resources/" stringByAppendingPathComponent:iconName]]];
//    hud.mode = MBProgressHUDModeCustomView;
//    
//    [hud hideAnimated:YES afterDelay:1.5f];
//}

+ (void)showErrorMessage:(NSString *)Message {
    
    [self showCustomIconInWindow:@"MBHUD_Error" message:Message];
}

+ (void)showInfoMessage:(NSString *)Message {
    
    [self showCustomIconInWindow:@"MBHUD_Info" message:Message];
}

+ (void)showWarnMessage:(NSString *)Message {
    
    [self showCustomIconInWindow:@"MBHUD_Warn" message:Message];
}

+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message {
    
    [self showCustomIcon:iconName message:message isWindow:true];
    
}

+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message {
    
    [self showCustomIcon:iconName message:message isWindow:false];
}

+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow {
    
    MBProgressHUD *hud  =  [self createMBProgressHUDviewTitle:message WithMessage:nil isWindiw:isWindow];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"Resource.bundle/Contents/Resources/" stringByAppendingPathComponent:iconName]]];
    hud.mode = MBProgressHUDModeCustomView;
    
    [hud hideAnimated:YES afterDelay:1.5f];
}

+ (void)hideHUD {
    
    UIView  *winView =(UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideAllHUDsForView:winView animated:YES];
    [self hideAllHUDsForView:[UIViewController getCurrentVC].view animated:YES];
}

/*** BLOCK ***/

+ (void)showSuccessMessage:(NSString *)Message completionBlock:(void(^)(void))comBlock{
    
    [self showCustomIconInWindow:@"MBHUD_Success" message:Message completionBlock:^{
        !comBlock?:comBlock();
    }];
}

+ (void)showErrorMessage:(NSString *)Message completionBlock:(void(^)(void))comBlock{
    
    [self showCustomIconInWindow:@"MBHUD_Error" message:Message completionBlock:^{
        !comBlock?:comBlock();
    }];
}

+ (void)showInfoMessage:(NSString *)Message completionBlock:(void(^)(void))comBlock{
    
    [self showCustomIconInWindow:@"MBHUD_Info" message:Message completionBlock:^{
        !comBlock?:comBlock();
    }];
}

+ (void)showWarnMessage:(NSString *)Message completionBlock:(void(^)(void))comBlock{
    
    [self showCustomIconInWindow:@"MBHUD_Warn" message:Message completionBlock:^{
        !comBlock?:comBlock();
    }];
}

+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message completionBlock:(void(^)(void))comBlock{
    
    [self showCustomIcon:iconName message:message isWindow:true completionBlock:^{
        !comBlock?:comBlock();
    }];
    
}

+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message completionBlock:(void(^)(void))comBlock{
    
    [self showCustomIcon:iconName message:message isWindow:false completionBlock:^{
        !comBlock?:comBlock();
    }];
}

+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow completionBlock:(void(^)(void))comBlock{

    MBProgressHUD *hud  =  [self createMBProgressHUDviewTitle:message WithMessage:nil isWindiw:isWindow];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"Resource.bundle/Contents/Resources/" stringByAppendingPathComponent:iconName]]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.completionBlock = ^{
        !comBlock?:comBlock();
    };
    [hud hideAnimated:YES afterDelay:1.5f];
}




//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentWindowVC {
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows) {
            
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        
        result = nextResponder;
    } else {
        
        result = window.rootViewController;
    }
    return  result;
}

+ (UIViewController *)getCurrentUIVC {
    
    UIViewController  *superVC = [[self class]  getCurrentWindowVC ];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
        
    }else if ([superVC isKindOfClass:[UINavigationController class]]) {
        
        return ((UINavigationController*)superVC).viewControllers.lastObject;  
    }
    return superVC;
}

@end
