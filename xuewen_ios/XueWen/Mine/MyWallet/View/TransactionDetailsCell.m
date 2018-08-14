//
//  TransactionDetailsCell.m
//  XueWen
//
//  Created by ShaJin on 2017/11/16.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "TransactionDetailsCell.h"
#import "TransactionModel.h"
@interface TransactionDetailsCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end
@implementation TransactionDetailsCell
- (void)setModel:(TransactionModel *)model{
    _model = model;
    NSString *title = model.title;
    NSString *time = [NSString stringWithTimeInterval:model.creatTime useDateFormatter:nil];
    NSString *price = [NSString stringWithFormat:@"%@%@",(model.type == 0 || model.type == 4) ? @"+" : @"-",model.price];
    if (model.type == 0) {
        self.priceLabel.textColor = COLOR(14, 201, 80);
    }else{
        self.priceLabel.textColor = DefaultTitleAColor;
    }
    self.titleLabel.text = title;
    
    self.timeLabel.text = time;
    self.timeLabel.sd_layout.widthIs([time widthWithSize:12]);
    
    self.priceLabel.text = price;
    self.priceLabel.sd_layout.widthIs([price widthWithSize:17]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self addSubview:self.titleLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.priceLabel];
        
        
        self.priceLabel.sd_layout.topSpaceToView(self,0).bottomSpaceToView(self,0).rightSpaceToView(self,15);
        self.titleLabel.sd_layout.topSpaceToView(self,17).leftSpaceToView(self,15).rightSpaceToView(self.priceLabel,8).heightIs(15);
        self.timeLabel.sd_layout.topSpaceToView(self.titleLabel,10).leftSpaceToView(self,15).heightIs(12);
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = COLOR(51, 51, 51);
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = COLOR(153, 153, 153);
    }
    return _timeLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont systemFontOfSize:17];
    }
    return _priceLabel;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (!self.isFirst) {
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
        CGContextMoveToPoint(context, 15, 0);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, kWidth ,0);
        //连接上面定义的坐标点
        CGContextStrokePath(context);
    }
}
@end
