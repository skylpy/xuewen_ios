//
//  HomeHeaderView.m
//  XueWen
//
//  Created by Pingzi on 2017/11/14.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "HomeHeaderView.h"

@implementation HomeHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}

- (void)layoutSubviews
{
    self.gradientView = [[XWGradientView alloc]initWithFrame:CGRectMake(0, 0, kWidth - 30, self.bgView.height) GradientColors:@[kThemeColor, COLOR(71, 88, 225)]];
    ViewRadius(self.gradientView, 2);
    [self.bgView insertSubview:self.gradientView atIndex:0];
    self.bgView.layer.shadowColor = COLOR(198, 207, 241).CGColor;//设置阴影的颜色
    
    self.bgView.layer.shadowOpacity = 1.0f; //设置阴影的透明度
    
    self.bgView.layer.shadowOffset = CGSizeMake(0, 4);//设置阴影的偏移量
    
    self.bgView.layer.shadowRadius = 3;//设置阴影的圆角
}
    

@end
