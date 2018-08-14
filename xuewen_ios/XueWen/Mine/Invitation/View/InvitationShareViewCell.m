//
//  InvitationShareViewCell.m
//  XueWen
//
//  Created by ShaJin on 2018/3/9.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "InvitationShareViewCell.h"
@interface InvitationShareViewCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation InvitationShareViewCell
- (void)setIcon:(NSString *)icon title:(NSString *)title{
    self.icon.image = LoadImage(icon);
    self.titleLabel.text = title;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleLabel];
        
        self.icon.sd_layout.topSpaceToView(self.contentView, 0).centerXEqualToView(self.contentView).widthIs(25).heightIs(25);
        
        self.titleLabel.sd_layout.topSpaceToView(self.icon, 10).leftSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0);
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
        _titleLabel = [UILabel labelWithTextColor:DefaultTitleBColor size:12];
        _titleLabel.textAlignment = 1;
    }
    return _titleLabel;
}

@end
