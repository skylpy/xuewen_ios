//
//  LessionProgressCell.m
//  XueWen
//
//  Created by ShaJin on 2017/12/25.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "LessionProgressCell.h"
#import "LearningPlanModel.h"
@interface LessionProgressCell ()

@property (nonatomic, strong) UIView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *progressLabel;

@end
@implementation LessionProgressCell
- (void)setModel:(LearningPlanInfoModel *)model{
    _model = model;
    self.titleLabel.text = model.courseName;
    self.progressLabel.text = [NSString stringWithFormat:@"已学%@%%",model.progress];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.progressLabel];
        NSString *text = @"已学100%";
        self.icon.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView,15).widthIs(6).heightIs(6);
        self.progressLabel.sd_layout.centerYEqualToView(self.icon).rightSpaceToView(self.contentView,14.5).widthIs([text widthWithSize:10]).heightIs(10);
        self.titleLabel.sd_layout.centerYEqualToView(self.icon).leftSpaceToView(self.icon,14.5).rightSpaceToView(self.progressLabel,14.5).heightIs(14);
    }
    return self;
}

- (UIView *)icon{
    if (!_icon) {
        _icon = [UIView new];
        ViewRadius(_icon, 3);
        _icon.layer.borderColor = COLOR(204, 204, 204).CGColor;
        _icon.layer.borderWidth = 1;
    }
    return _icon;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:DefaultTitleAColor size:14];
    }
    return _titleLabel;
}

- (UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [UILabel labelWithTextColor:COLOR(183, 183, 183) size:10];
    }
    return _progressLabel;
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
    CGContextSetLineWidth(context, 0.5);
    //开始一个起始路径
    CGContextBeginPath(context);
    if (!_isFirst) {
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, 18, 0);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, 18 ,10);
    }
    if (!_isLast) {
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, 18, 28);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, 18 ,38);
    }
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    [self setNeedsDisplay];
}

- (void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
    [self setNeedsDisplay];
}
@end
