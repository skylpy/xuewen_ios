//
//  MineListTableViewCell.m
//  XueWen
//
//  Created by Pingzi on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MineListTableViewCell.h"

@implementation MineListTableViewCell
- (void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
}


- (void)setModel:(BaseCellModel *)model
{
    
    self.imgV.image = LoadImage(model.imgUrl);
    self.titleLB.text = model.LeftTitle;
    
    if ([model.LeftTitle isEqualToString:@"我的钱包"])
    {
        if (!IsEmptyString(model.rightDetail)) {
            self.detailLB.text = [NSString stringWithFormat:@"￥%@",model.rightDetail];
        }
        else
        {
            self.detailLB.text = @"￥0";
        }
        
        self.detailLB.hidden = NO;
    }
    else
    {
        self.detailLB.hidden = YES;
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (!_isFirst) {
        //获得处理的上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        //设置线条样式
        CGContextSetLineCap(context, kCGLineCapSquare);
        //设置颜色
        CGContextSetRGBStrokeColor(context, 238 / 255.0, 238 / 255.0, 238 / 255.0, 1.0);
        //设置线条粗细宽度
        CGContextSetLineWidth(context, 0.5);
        //开始一个起始路径
        CGContextBeginPath(context);
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, 50, 0);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, kWidth ,0);
        //连接上面定义的坐标点
        CGContextStrokePath(context);
    }
}
@end
