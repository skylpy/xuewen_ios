//
//  MBProgressHUD+Ali.h
//  intelMeeting
//
//  Created by Mr.Aaron on 2018/1/18.
//  Copyright © 2018年 张子恒. All rights reserved.
//

#import "MBProgressHUD.h"


@interface MBProgressHUD (Ali)

//单提示
+ (void)showTipMessageInWindow:(NSString*)message; //默认1.0秒
+ (void)showTipMessageInView:(NSString*)message; //默认1.0秒
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer;
+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer;
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer completionBlock:(void(^)(void))comBlock;
+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer completionBlock:(void(^)(void))comBlock;

//双提示
+ (void)showTipMessageInWindowTitle:(NSString*)title withMessage:(NSString *)message;
+ (void)showTipMessageInViewTitle:(NSString*)title withMessage:(NSString *)message;
+ (void)showTipMessageInWindowTitle:(NSString*)title withMessage:(NSString *)message timer:(int)aTimer;
+ (MBProgressHUD *)showTipMessageInViewTitle:(NSString*)title withMessage:(NSString *)message timer:(int)aTimer;
+ (void)showTipMessageInWindowTitle:(NSString*)title withMessage:(NSString *)message timer:(int)aTimer completionBlock:(void(^)(void))comBlock;
+ (MBProgressHUD *)showTipMessageInViewTitle:(NSString*)title withMessage:(NSString *)message timer:(int)aTimer completionBlock:(void(^)(void))comBlock;
+ (MBProgressHUD *)showTipTitle:(NSString*)title withMessage:(NSString *)message isWindow:(BOOL)isWindow timer:(int)aTimer completionBlock:(void(^)(void))comBlock;

//菊花状
+ (void)showActivityMessageInWindow:(NSString*)message;
+ (void)showActivityMessageInView:(NSString*)message;
+ (void)showActivityMessageInWindow:(NSString*)message timer:(int)aTimer;
+ (void)showActivityMessageInView:(NSString*)message timer:(int)aTimer;

//四种状态
+ (void)showSuccessMessage:(NSString *)Message;
+ (void)showErrorMessage:(NSString *)Message;
+ (void)showInfoMessage:(NSString *)Message;
+ (void)showWarnMessage:(NSString *)Message;

+ (void)showSuccessMessage:(NSString *)Message completionBlock:(void(^)(void))comBlock;
+ (void)showErrorMessage:(NSString *)Message completionBlock:(void(^)(void))comBlock;
+ (void)showInfoMessage:(NSString *)Message completionBlock:(void(^)(void))comBlock;
+ (void)showWarnMessage:(NSString *)Message completionBlock:(void(^)(void))comBlock;

//自定义
+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message;
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message;
+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message completionBlock:(void(^)(void))comBlock;
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message completionBlock:(void(^)(void))comBlock;

//隐藏
+ (void)hideHUD;

@end
