//
//  MyCourseInfoCell.m
//  XueWen
//
//  Created by ShaJin on 2017/12/11.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyCourseInfoCell.h"
#import "CourseModel.h"
@interface MyCourseInfoCell()

@property (nonatomic, strong) UIImageView *requireIcon;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end
@implementation MyCourseInfoCell
#pragma mark- CustomMethod
- (void)initUI{
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.progressLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.priceLabel];
   
    self.icon.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).widthIs(120).heightIs(74);
    self.icon.layer.cornerRadius = 3;
    self.icon.clipsToBounds = YES;
    self.requireIcon.sd_layout.topSpaceToView(self.icon,0).leftSpaceToView(self.icon,0).widthIs(30).heightIs(30);
    self.titleLabel.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.icon,10).rightSpaceToView(self.contentView,0);
    self.progressLabel.sd_layout.leftSpaceToView(self.icon,10).bottomSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,0).heightIs(12);
    self.priceLabel.sd_layout.leftSpaceToView(self.icon,9.5).bottomSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).heightIs(self.priceLabel.font.lineHeight);
    self.countLabel.sd_layout.leftSpaceToView(self.icon,9.5).bottomSpaceToView(self.priceLabel,5).rightSpaceToView(self.contentView,0).heightIs(self.countLabel.font.lineHeight);
}

#pragma mark- Setter
- (void)setModel:(CourseModel *)model showProgress:(BOOL)show{
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.coverPhoto] placeholderImage:LoadImage(@"default_cover")];
    self.titleLabel.text = model.courseName;
    self.titleLabel.sd_layout.heightIs([model.courseName heightWithWidth:self.titleLabel.width size:14]);
    self.requireIcon.hidden = model.isOptional;
    if (show) {
        self.progressLabel.hidden = NO;
        self.countLabel.hidden = YES;
        self.priceLabel.hidden = YES;
        self.progressLabel.text = [NSString stringWithFormat:@"已学%ld%%",(long)model.percentage];
    }else{
        self.progressLabel.hidden = YES;
        self.countLabel.hidden = NO;
        self.priceLabel.hidden = NO;
        self.countLabel.text = [NSString stringWithFormat:@"%d人学习",(int)model.total];
        self.priceLabel.text = ([model.price floatValue] > 0) ? [NSString stringWithFormat:@"￥%@",model.price] : @"免费";
        self.priceLabel.textColor = ([model.price floatValue] > 0) ? COLOR(252, 101, 30) : COLOR(14, 201, 80);
    }
}

- (void)setModel:(CourseModel *)model{

    /** 之前是用setModel方法设置model的，现在需要用setModel：showProgress方法，所以在这里直接调用这个方法兼容以前的代码，有时间全部改成 2018.01.15 */
    [self setModel:model showProgress:YES];
}

#pragma mark- Getter
- (UIImageView *)requireIcon{
    if (!_requireIcon) {
        _requireIcon = [UIImageView new];
        _requireIcon.image = LoadImage(@"requiredCorner");
        _requireIcon.hidden = YES;
    }
    return _requireIcon;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.clipsToBounds = YES;
    }
    return _icon;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = DefaultTitleAColor;
        _titleLabel.font = kFontSize(14);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [UILabel new];
        _progressLabel.textColor = kThemeColor;
        _progressLabel.font = kFontSize(12);
    }
    return _progressLabel;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [UILabel labelWithTextColor:DefaultTitleCColor size:10];
    }
    return _countLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithTextColor:COLOR(14, 201, 80) size:12];
    }
    return _priceLabel;
}

#pragma mark- LifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
@end
