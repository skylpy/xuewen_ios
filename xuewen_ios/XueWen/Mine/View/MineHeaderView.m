//
//  MineHeaderView.m
//  XueWen
//
//  Created by Pingzi on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MineHeaderView.h"
@interface MineHeaderView()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *signLabel;
@property (nonatomic, strong) UIButton *setButton;
@property (nonatomic, strong) UIImageView *bgImgView;

@end
@implementation MineHeaderView
- (void)refresh{
    XWUserInfo *userInfo = [XWInstance shareInstance].userInfo;
    UIImage *defaultImg = [[UIImage alloc] init];
    if ([userInfo.sex isEqualToString:@"0"]){
        defaultImg = DefaultImageGril;
    }else{
        defaultImg = DefaultImageBoy;
    }
    [self.icon sd_setImageWithURL:[NSURL URLWithString:userInfo.picture] placeholderImage:defaultImg];
    self.nameLabel.text = userInfo.nick_name;
    self.signLabel.text = (userInfo.introduction.length > 0) ? userInfo.introduction : @"我很懒，什么也没写";
}

- (instancetype)initWithFrame:(CGRect)frame target:(id)target infoAction:(SEL)infoAction setAction:(SEL)setAction{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        /** 如需改成新版,打开注释*/
//        [self addSubview:self.bgImgView];
        [self addSubview:self.icon];
        [self addSubview:self.nameLabel];
        [self addSubview:self.signLabel];
        /** 如需改成新版,打开注释*/
//        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.bottom.mas_equalTo(self);
//        }];
        
        self.icon.sd_layout.topSpaceToView(self,31).centerXEqualToView(self).widthIs(55).heightIs(55);
        self.nameLabel.sd_layout.topSpaceToView(self.icon,18).leftSpaceToView(self,15).rightSpaceToView(self,15).heightIs(16);
        self.signLabel.sd_layout.topSpaceToView(self.nameLabel,10).leftSpaceToView(self,15).rightSpaceToView(self,15).heightIs(13);
        self.setButton.sd_layout.topSpaceToView(self,IsIPhoneX ? 44 : 20).rightSpaceToView(self,2).widthIs(44).heightIs(44);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:infoAction];
        [self.icon addGestureRecognizer:tap];
        [self.setButton addTarget:target action:@selector(setAction:) forControlEvents:UIControlEventTouchUpInside];
        [self refresh];
    }
    return self;
}

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:LoadImage(@"background")];
    }
    return _bgImgView;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.userInteractionEnabled = YES;
        ViewRadius(_icon, 55 / 2.0);
    }
    return _icon;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = DefaultTitleAColor;
        /** 如需改成新版,打开注释,*/
//        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont fontWithName:kRegFont size:16];
        _nameLabel.textAlignment = 1 ;
    }
    return _nameLabel;
}

- (UILabel *)signLabel{
    if (!_signLabel) {
        _signLabel = [UILabel new];
        _signLabel.font = [UIFont fontWithName:kRegFont size:12];
        _signLabel.textAlignment = 1;
        _signLabel.textColor = DefaultTitleAColor;
        /** 如需改成新版,打开注释,*/
//        _signLabel.textColor = [UIColor whiteColor];
        
    }
    return _signLabel;
}

- (UIButton *)setButton{
    if (!_setButton) {
        _setButton = [UIButton buttonWithType:0];
        [_setButton setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
        [_setButton setImage:LoadImage(@"icoSetUp") forState:UIControlStateNormal];
    }
    return _setButton;
}
@end
