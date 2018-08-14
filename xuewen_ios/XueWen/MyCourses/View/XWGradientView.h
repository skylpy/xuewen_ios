//
//  XWGradientView.h
//  XueWen
//
//  Created by Pingzi on 2017/11/14.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWGradientView : UIView

@property (nonatomic, strong) NSArray *gradientColors;
@property (nonatomic, strong) UIView *shawdowBGView;

- (id)initWithFrame:(CGRect)frame GradientColors:(NSArray *)gradientColors;


@end
