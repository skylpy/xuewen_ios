//
//  UINavigationController+Extension.h
//  手动录入模块
//
//  Created by Pingzi on 2017/6/12.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extension)

/**
 *  创建导航栏返回按钮
 
 @param imageName 按钮图片名字
 */
- (UIBarButtonItem *)getBackBtnItemWithImgName:(NSString *)imageName;

/**
 *  创建导航栏右侧图标按钮
 
 @param imageName 按钮图片名字
 */
- (UIBarButtonItem *)getRightBtnItemWithImgName:(NSString *)imageName target:(UIViewController *)vc method:(SEL)sel;

/**
 *  创建导航栏右侧文字按钮
 
 */
- (UIBarButtonItem *)getRightBtnItemWithTitle:(NSString *)title target:(UIViewController *)vc method:(SEL)sel;

@end
