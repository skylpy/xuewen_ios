//
//  MyOrderCell.m
//  XueWen
//
//  Created by ShaJin on 2017/12/19.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyOrderCell.h"
#import "OrderModel.h"
@interface MyOrderCell()

@property (nonatomic, strong) UILabel *orderNumber;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *statusLabel;

@end
@implementation MyOrderCell
#pragma mark- CustomMethod
- (void)payAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(payOrder:)]) {
        [self.delegate payOrder:self.model];
    }
}

- (void)cancelAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(cancelOrder:)]) {
        [self.delegate cancelOrder:self.model];
    }
}

#pragma mark- Setter
- (void)setModel:(OrderModel *)model{
    _model = model;
    self.orderNumber.text = [NSString stringWithFormat:@"订单号：%@",model.orderID];
    self.timeLabel.text = model.creatTime;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.coverPhoto] placeholderImage:LoadImage(@"default_cover")];
    self.titleLabel.text = model.courseName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.orderPrice];
    NSString *text = [NSString stringWithFormat:@"实付：￥%@",model.price];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:text];
    [attributed addAttribute:NSForegroundColorAttributeName value:COLOR(51, 51, 51) range:NSMakeRange(0, 3)];
    self.moneyLable.attributedText = attributed;
    self.timeLabel.sd_layout.widthIs([self.timeLabel.text widthWithSize:11]);
    if ([model.status isEqualToString:@"0"]) {
        self.payButton.hidden = NO;
        self.cancelButton.hidden = NO;
        self.statusLabel.hidden = YES;
    }else{
        self.payButton.hidden = YES;
        self.cancelButton.hidden = YES;
        self.statusLabel.hidden = NO;
        self.statusLabel.text = ([model.status isEqualToString:@"1"]) ? @"已完成" : @"已关闭";
    }
}

#pragma mark- Getter
- (UILabel *)orderNumber{
    if (!_orderNumber) {
        _orderNumber = [UILabel new];
        _orderNumber.font = kFontSize(13);
        _orderNumber.textColor = DefaultTitleAColor;
    }
    return _orderNumber;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = kFontSize(11);
        _timeLabel.textColor = DefaultTitleCColor;
    }
    return _timeLabel;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
    }
    return _icon;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:DefaultTitleBColor size:14];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithTextColor:DefaultTitleBColor size:12];
    }
    return _priceLabel;
}

- (UILabel *)moneyLable{
    if (!_moneyLable) {
        _moneyLable = [UILabel new];
        _moneyLable.font = kFontSize(13);
        _moneyLable.textColor = COLOR(252, 101, 30);
    }
    return _moneyLable;
}

- (UIButton *)payButton{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:0];
        _payButton.titleLabel.font = kFontSize(13);
        [_payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        _payButton.layer.borderColor = kThemeColor.CGColor;
        _payButton.layer.borderWidth = 1;
        [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    }
    return _payButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:0];
        _cancelButton.titleLabel.font = kFontSize(13);
        [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:DefaultTitleBColor forState:UIControlStateNormal];
        _cancelButton.layer.borderColor = COLOR(204, 204, 204).CGColor;
        _cancelButton.layer.borderWidth = 1;
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [UILabel labelWithTextColor:DefaultTitleBColor size:13];
        _statusLabel.textAlignment = 2;
    }
    return _statusLabel;
}

#pragma mark- LifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = 0;
        [self.contentView addSubview:self.orderNumber];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.moneyLable];
        [self.contentView addSubview:self.payButton];
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.cancelButton];
        
        self.timeLabel.sd_layout.topSpaceToView(self.contentView,17).rightSpaceToView(self.contentView,15.5).heightIs(11);
        self.orderNumber.sd_layout.topSpaceToView(self.contentView,15).leftSpaceToView(self.contentView,15.5).rightSpaceToView(self.timeLabel,15).heightIs(13);
        self.icon.sd_layout.self.topSpaceToView(self.contentView,57.5).leftSpaceToView(self.contentView,15.5).widthIs(110).heightIs(68);
        self.icon.layer.cornerRadius = 3;
        self.icon.clipsToBounds = YES;
        self.titleLabel.sd_layout.topSpaceToView(self.contentView,62.5).leftSpaceToView(self.icon,10).rightSpaceToView(self.contentView,15.5).heightIs(11);
        self.priceLabel.sd_layout.topSpaceToView(self.titleLabel,33.5).leftSpaceToView(self.icon,10).rightSpaceToView(self.contentView,15.5).heightIs(12);
        self.cancelButton.sd_layout.topSpaceToView(self.contentView,156).rightSpaceToView(self.contentView,15).widthIs(80).heightIs(25);
        self.payButton.sd_layout.topSpaceToView(self.contentView,156).rightSpaceToView(self.cancelButton,10).widthIs(80).heightIs(25);
        self.moneyLable.sd_layout.topSpaceToView(self.icon,37).leftSpaceToView(self.contentView,19).rightSpaceToView(self.payButton,15).heightIs(13);
        self.statusLabel.sd_layout.topSpaceToView(self.contentView,156).rightSpaceToView(self.contentView,15).widthIs(80).heightIs(25);
    }
    return self;
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
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 42);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, kWidth ,42);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 140.5);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, kWidth ,140.5);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}
@end
