//
//  XWManageCell.m
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWManageCell.h"

@interface XWManageCell()

@end

@implementation XWManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.textColor = Color(@"#151A1F");
    self.title.font = [UIFont fontWithName:kMedFont size:15];
}

- (void)setModel:(XWManageModel *)model {
    _model = model;
    self.imageIcon.image = [UIImage imageNamed:model.imageStr];
    self.title.text = model.title;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 238 / 255.0, 238 / 255.0, 238 / 255.0, 1.0);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 50, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, kWidth ,0);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
