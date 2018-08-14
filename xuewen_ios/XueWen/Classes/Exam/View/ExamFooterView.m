//
//  ExamFooterView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/12.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ExamFooterView.h"
@interface ExamFooterView()

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation ExamFooterView
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        self.titleLabel.sd_layout.bottomSpaceToView(self,0).rightSpaceToView(self,20).leftSpaceToView(self,20).heightIs(15);
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [ UILabel new];
        _titleLabel.font = kFontSize(15);
        _titleLabel.textColor = DefaultTitleAColor;
    }
    return _titleLabel;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 221 / 255.0, 221 / 255.0, 221 / 255.0, 1.0);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 20, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.width - 20 ,0);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}
@end
