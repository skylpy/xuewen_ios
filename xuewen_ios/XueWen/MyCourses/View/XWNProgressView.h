//
//  XWNProgressView.h
//  XueWen
//
//  Created by aaron on 2018/7/29.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWNProgressView : UIView

//中心颜色
@property (strong, nonatomic)UIColor *centerColor;
//圆环背景色
@property (strong, nonatomic)UIColor *arcBackColor;

//圆环色

@property (strong, nonatomic)UIColor *arcFinishColor;
@property (strong, nonatomic)UIColor *arcUnfinishColor;

@property (strong, nonatomic)UIColor *arcTitleColor;
//百分比数值（0-1）
@property (assign, nonatomic)float percent;
//字体
@property (assign, nonatomic)float fontSize;
//圆环宽度
@property (assign, nonatomic)float width;

@end
