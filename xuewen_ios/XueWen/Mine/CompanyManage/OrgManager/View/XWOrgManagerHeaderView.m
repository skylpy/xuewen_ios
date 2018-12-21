//
//  XWOrgManagerHeaderView.m
//  XueWen
//
//  Created by Karron Su on 2018/12/11.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWOrgManagerHeaderView.h"
#import "XWDepartmentManagerViewController.h"

@interface XWOrgManagerHeaderView ()

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *managerBtn;

@end

@implementation XWOrgManagerHeaderView

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

- (UIButton *)managerBtn {
    if (!_managerBtn) {
        _managerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_managerBtn setImage:LoadImage(@"adminico") forState:UIControlStateNormal];
        [_managerBtn setTitle:@" 部门管理" forState:UIControlStateNormal];
        [_managerBtn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateNormal];
        _managerBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:14];
        [_managerBtn addTarget:self action:@selector(managerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _managerBtn;
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
    [self addSubview:self.managerBtn];
    
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.headIcon.mas_right).offset(10);
    }];
    
    [self.managerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-15);
    }];
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:kUserInfo.company.co_picture_all] placeholderImage:LoadImage(@"default_company")];
    self.titleLabel.text = kUserInfo.company.name;
    
    
}

- (void)managerBtnClick {
    [self.navigationController pushViewController:[XWDepartmentManagerViewController new] animated:YES];
}

@end
