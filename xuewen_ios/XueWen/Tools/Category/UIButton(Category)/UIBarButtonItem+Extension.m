//
//  UIBarButtonItem+Extension.m
//  happyselling
//
//  Created by charles on 2017/10/26.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

 + (UIBarButtonItem *)itemWithImageName:(NSString *)ImageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action{
     //自定义UIView
    UIButton *btn=[[UIButton alloc]init];
    
    //设置按钮的背景图片（默认/高亮）
    [btn setBackgroundImage:[UIImage imageNamed:ImageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    
    //设置按钮的尺寸和图片一样大，使用了UIImage的分类
    btn.size=btn.currentBackgroundImage.size;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}


@end
