//
//  XWScreenCell.m
//  XueWen
//
//  Created by ShaJin on 2018/1/15.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "XWScreenCell.h"
@interface XWScreenCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *icon;

@end
@implementation XWScreenCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.icon];
        self.titleLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        self.icon.sd_layout.bottomSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).widthIs(14.5).heightIs(14.5);
        self.layer.borderWidth = 0.5;
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:DefaultTitleBColor size:12];
        _titleLabel.textAlignment = 1;
    }
    return _titleLabel;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.image = LoadImage(@"sortSelected");
    }
    return _icon;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    _icon.hidden = !isSelect;
    self.layer.borderColor = isSelect ? kThemeColor.CGColor : COLOR(221, 221, 221).CGColor;
    self.titleLabel.textColor = isSelect ? kThemeColor : DefaultTitleBColor;
}

@end
