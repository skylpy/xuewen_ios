//
//  PayViewCell.m
//  XueWen
//
//  Created by ShaJin on 2017/12/8.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "PayViewCell.h"
@interface PayViewCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *selectImg;

@end
@implementation PayViewCell

- (void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
    [self setNeedsDisplay];
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    self.selectImg.image = isSelect ? LoadImage(@"purseIcoChooseSelected") : LoadImage(@"purseIcoChooseNormal");
}

- (void)setCanSelect:(BOOL)canSelect{
    _canSelect = canSelect;
    self.titleLabel.textColor = canSelect ? DefaultTitleBColor : DefaultTitleDColor;
    self.contentLabel.textColor = canSelect ? DefaultTitleCColor : DefaultTitleDColor;
}

- (void)setTitle:(NSString *)title content:(NSString *)content icon:(UIImage *)icon{
    self.icon.image = icon;
    self.titleLabel.text = title;
    self.titleLabel.sd_layout.widthIs([title widthWithSize:15]);
    self.contentLabel.text = content;
    self.contentLabel.sd_layout.widthIs([content widthWithSize:10]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.selectImg];
        
        self.icon.sd_layout.topSpaceToView(self.contentView,15).leftSpaceToView(self.contentView,15).widthIs(30).heightIs(30);
        self.titleLabel.sd_layout.topSpaceToView(self.contentView,17.5).leftSpaceToView(self.icon,16).bottomSpaceToView(self.contentView,29);
        self.contentLabel.sd_layout.topSpaceToView(self.titleLabel,4.5).leftSpaceToView(self.icon,16).bottomSpaceToView(self.contentView,14);
        self.selectImg.sd_layout.topSpaceToView(self.contentView,22).rightSpaceToView(self.contentView,15).widthIs(16).heightIs(16);
    }
    return self;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
    }
    return _icon;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = kFontSize(15);
        _titleLabel.textColor = DefaultTitleBColor;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = kFontSize(10);
        _contentLabel.textColor = DefaultTitleCColor;
    }
    return _contentLabel;
}

- (UIImageView *)selectImg{
    if (!_selectImg) {
        _selectImg = [UIImageView new];
        _selectImg.image = LoadImage(@"purseIcoChooseNormal");
    }
    return _selectImg;
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
