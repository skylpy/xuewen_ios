//
//  UINavigationController+Extension.m
//  手动录入模块
//
//  Created by Pingzi on 2017/6/12.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import "UINavigationController+Extension.h"

@implementation UINavigationController (Extension)

/**
 *  创建导航栏返回按钮
 
 @param imageName 按钮图片名字
 */
- (UIBarButtonItem *)getBackBtnItemWithImgName:(NSString *)imageName
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

/**
 *  pop控制器
 */
- (void)backClick
{
    [self popViewControllerAnimated:YES];
}

/**
 *  创建右侧导航栏图标按钮
 
 @param imageName 按钮图片名字
 */
- (UIBarButtonItem *)getRightBtnItemWithImgName:(NSString *)imageName target:(UIViewController *)vc method:(SEL)sel
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [backBtn addTarget:vc action:sel forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}


/**
 *  创建右侧导航栏文字按钮
 
 */
- (UIBarButtonItem *)getRightBtnItemWithTitle:(NSString *)title target:(UIViewController *)vc method:(SEL)sel
{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [Btn setTitle:title forState:UIControlStateNormal];
    [Btn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
    Btn.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
    [Btn sizeToFit];
    [Btn addTarget:vc action:sel forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:Btn];
}

@end
