//
//  KKChartView.h
//  KKChartView
//
//  Created by lk on 2017/5/9.
//  Copyright © 2017年 lukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKChartView : UIView

@property(nonatomic, assign)CGFloat marginX;
@property(nonatomic, assign)CGFloat marginY;
@property(nonatomic, strong)UIColor *lineColor;
@property(nonatomic, strong)UIColor *coordinateColor;//坐标颜色
@property(nonatomic, assign)NSInteger lineWidth;
@property(nonatomic, copy)NSArray *dataAry;
@property(nonatomic, copy)NSArray *dateArray;
@property(nonatomic, assign)BOOL isShowGradient;//是否现象渐变图层
@property(nonatomic, copy)NSString *gradientColor;

@property(nonatomic, assign) BOOL isCell;

-(void)setDataAry:(NSArray *)dataAry withDateArray:(NSArray *)dateArray;
@end
