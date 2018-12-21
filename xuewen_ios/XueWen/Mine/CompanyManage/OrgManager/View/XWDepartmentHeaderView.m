//
//  XWDepartmentHeaderView.m
//  XueWen
//
//  Created by Karron Su on 2018/12/11.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWDepartmentHeaderView.h"

@interface XWDepartmentHeaderView ()

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation XWDepartmentHeaderView

#pragma mark - Getter
- (UIImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc] init];
        [_headIcon rounded:20];
    }
    return _headIcon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel creatLabelWithFontName:@"PingFang-SC-Bold" TextColor:Color(@"#333333") FontSize:17 Text:@""];
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel creatLabelWithFontName:kMedFont TextColor:Color(@"#999999") FontSize:14 Text:@""];
    }
    return _countLabel;
}

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headIcon];
    [self addSubview:self.titleLabel];
    [self addSubview:self.countLabel];
    
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.headIcon.mas_right).offset(10);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-15);
    }];
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:kUserInfo.company.co_picture_all] placeholderImage:LoadImage(@"default_company")];
    self.titleLabel.text = kUserInfo.company.name;
    
    
}

#pragma mark - Setter
- (void)setNums:(NSString *)nums {
    _nums = nums;
    self.countLabel.text = [NSString stringWithFormat:@"%@人", _nums];
}

@end
