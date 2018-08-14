//
//  UIAlertController+Util.m
//  happyselling
//
//  Created by 金蓝盟 on 2018/1/6.
//  Copyright © 2018年 iOS李鹏. All rights reserved.
//

#import "UIAlertController+Util.h"

@implementation UIAlertController (Util)

+ (void)alertControllerTwo:(UIViewController *)controller
             withTitle:(NSString *)title
           withMessage:(NSString *)message
           withConfirm:(NSString *)confirm
            withCancel:(NSString *)cancel
         actionConfirm:(void(^)())actConfirm
          actionCancel:(void(^)())actCancel {
    
    [self alertController:controller withTitle:title withMessage:message withConfirmColor:nil withCancelColor:nil withConfirm:confirm withCancel:cancel actionConfirm:actConfirm actionCancel:actCancel];
}

/**
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
          actionCancel:(void(^)())actCancel
{
    [self alertController:controller withTitle:title withMessage:message withConfirmColor:confirmcolor withCancelColor:cancelcolor withConfirm:confirm withCancel:cancel actionConfirm:actConfirm style:UIAlertControllerStyleAlert actionCancel:actCancel];
    
}

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
          actionCancel:(void(^)())actCancel
{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:stye];
    
    if (!IsEmptyString(title))
    {
        //修改title
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:DefaultAlertColor range:NSMakeRange(0, title.length)];
        [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kSemFont size:17] range:NSMakeRange(0, title.length)];
        [alertVC setValue:alertControllerStr forKey:@"attributedTitle"];
    }
    
    if (!IsEmptyString(message))
    {
        //修改message
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:DefaultAlertColor range:NSMakeRange(0, message.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:13] range:NSMakeRange(0, message.length)];
        [alertVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    }
    
    
    if (!IsEmptyString(cancel))
    {
        
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            !actConfirm?:actConfirm();
        }];
        [actionConfirm setValue:confirmcolor?confirmcolor:DefaultAlertColor forKey:@"_titleTextColor"];
        [alertVC addAction:actionConfirm];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            !actCancel?:actCancel();
        }];
        [actionCancel setValue:cancelcolor?cancelcolor:DefaultAlertColor forKey:@"_titleTextColor"];
        [alertVC addAction:actionCancel];
        
    }
    //只有一个按钮
    else
    {
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                        {
                                            !actConfirm?:actConfirm();
                                        }];
        [actionConfirm setValue:confirmcolor?confirmcolor:DefaultAlertColor forKey:@"_titleTextColor"];
        
        [alertVC addAction:actionConfirm];
        
    }
    
    if (stye == 0)
    {
        UIAlertAction *cancelForSheet = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [cancelForSheet setValue:confirmcolor?confirmcolor:DefaultAlertColor forKey:@"_titleTextColor"];
        [alertVC addAction:cancelForSheet];
    }
    [controller presentViewController:alertVC animated:YES completion:nil];
    
}

//只有确认按钮
+ (void)alertControllerSingle:(UIViewController *)controller
              withTitle:(NSString *)title
            withMessage:(NSString *)message
            withConfirm:(NSString *)confirm
          actionConfirm:(void(^)())actConfirm {
    
    [self alertController:controller withTitle:title withMessage:message withConfirmColor:nil withCancelColor:nil withConfirm:confirm withCancel:nil actionConfirm:actConfirm actionCancel:nil];
}



@end
