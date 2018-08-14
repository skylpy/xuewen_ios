//
//  UIAlertController+Util.h
//  happyselling
//
//  Created by 金蓝盟 on 2018/1/6.
//  Copyright © 2018年 iOS李鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Util)


//自定义弹框(两个option)

/**
 自定义弹框(两个option)

 @param controller 控制器
 @param title 标题
 @param message 内容
 @param confirm 确定按钮
 @param cancel 取消按钮
 @param actConfirm 点击确定的返回
 @param actCancel 点击缺席的返回
 */
+ (void)alertControllerTwo:(UIViewController *)controller
             withTitle:(NSString *)title
           withMessage:(NSString *)message
           withConfirm:(NSString *)confirm
            withCancel:(NSString *)cancel
         actionConfirm:(void(^)())actConfirm
          actionCancel:(void(^)())actCancel;

/**
 *  自定义弹框
 *  confirm传入空的时候只有一个蓝色的按钮
 */
+ (void)alertController:(UIViewController *)controller
             withTitle:(NSString *)title
           withMessage:(NSString *)message
      withConfirmColor:(UIColor *)confirmcolor
       withCancelColor:(UIColor *)cancelcolor
           withConfirm:(NSString *)confirm
            withCancel:(NSString *)cancel
         actionConfirm:(void(^)())actConfirm
          actionCancel:(void(^)())actCancel;

//只有确认按钮

/**
 只有确认按钮

 @param controller 控制器
 @param title 标题
 @param message 内容
 @param confirm 确认按钮
 @param actConfirm 点击确认的返回
 */
+ (void)alertControllerSingle:(UIViewController *)controller
             withTitle:(NSString *)title
           withMessage:(NSString *)message
           withConfirm:(NSString *)confirm
         actionConfirm:(void(^)())actConfirm;

/**
 *  confirm传入空的时候只有一个蓝色的按钮
 *  可以定制UIAlertControllerStyle
 */
+ (void)alertController:(UIViewController *)controller
             withTitle:(NSString *)title
           withMessage:(NSString *)message
      withConfirmColor:(UIColor *)confirmcolor
       withCancelColor:(UIColor *)cancelcolor
           withConfirm:(NSString *)confirm
            withCancel:(NSString *)cancel
         actionConfirm:(void(^)())actConfirm
                 style:(UIAlertControllerStyle)stye
          actionCancel:(void(^)())actCancel;

@end
