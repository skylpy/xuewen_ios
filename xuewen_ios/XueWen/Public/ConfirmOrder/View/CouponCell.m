//
//  CouponCell.m
//  XueWen
//
//  Created by ShaJin on 2018/3/5.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "CouponCell.h"
@interface CouponCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLable;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *selectView;

@end
@implementation CouponCell
- (void)setModel:(CouponModel *)model{
    _model = model;

    self.icon.image = LoadImage(model.canUse ? @"couponBgNormal" : @"couponBgAlreadyUsed");
    self.detailLabel.text = model.describe;
    self.titleLabel.text = model.title;
    self.timeLabel.text = @"2017.06.21-2017.06.30";
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.creatTime,model.useTime];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",model.price]];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, 1)];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0f] range:NSMakeRange(1, 3)];
    self.countLable.attributedText = attribute;
    
}

- (void)setHasSelect:(BOOL)hasSelect{
    _hasSelect = hasSelect;
    self.selectView.hidden = !hasSelect;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.backgroundColor = DefaultBgColor;
        [self.contentView addSubview:self.icon];
        [self.icon addSubview:self.countLable];
        [self.icon addSubview:self.detailLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.selectView];

        self.contentView.sd_layout.topSpaceToView(self, 0).leftSpaceToView(self, 15).bottomSpaceToView(self, 0).rightSpaceToView(self, 15);
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.icon.sd_layout.topSpaceToView(self.contentView, 0).leftSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(115);
        self.countLable.sd_layout.topSpaceToView(self.icon, 26).leftSpaceToView(self.icon, 0).rightSpaceToView(self.icon, 0).heightIs(23);
        self.detailLabel.sd_layout.topSpaceToView(self.countLable, 10).leftSpaceToView(self.icon, 0).rightSpaceToView(self.icon, 0).bottomSpaceToView(self.icon, 0);
        self.titleLabel.sd_layout.topSpaceToView(self.contentView, 15).leftSpaceToView(self.icon, 8).rightSpaceToView(self.contentView, 15).heightIs(13);
        self.timeLabel.sd_layout.leftSpaceToView(self.icon, 8).bottomSpaceToView(self.contentView, 19).rightSpaceToView(self.contentView, 80).heightIs(10);
        self.selectView.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, 15).widthIs(15).heightIs(15);
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
        _titleLabel = [UILabel labelWithTextColor:DefaultTitleBColor size:13];
    }
    return _titleLabel;
}

- (UILabel *)countLable{
    if (!_countLable) {
        _countLable = [UILabel labelWithTextColor:[UIColor whiteColor] size:30];
        _countLable.textAlignment = 1;
    }
    return _countLable;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithTextColor:[UIColor whiteColor] size:11];
        _detailLabel.textAlignment = 1 ;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithTextColor:DefaultTitleCColor size:10];
    }
    return _timeLabel;
}

- (UIImageView *)selectView{
    if (!_selectView) {
        _selectView = [[UIImageView alloc] initWithImage:LoadImage(@"couponIcoChoose")];
        _selectView.hidden = YES;
    }
    return _selectView;
}
@end
