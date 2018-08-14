//
//  MyCoursesHeaderView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/11.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyCoursesHeaderView.h"
#import "XWGradientView.h"
@interface MyCoursesHeaderView ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView *backshadowView;
@property (nonatomic, strong) XWGradientView *backgroundView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIImageView *moreView;

@end
@implementation MyCoursesHeaderView
#pragma mark- CustomMethod
- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backshadowView];
    [self.backshadowView addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.icon];
    [self.backgroundView addSubview:self.nameLabel];
    [self.backgroundView addSubview:self.companyLabel];
    [self.backgroundView addSubview:self.moreView];
    
    self.backshadowView.sd_layout.leftSpaceToView(self,15).rightSpaceToView(self,15).bottomSpaceToView(self,0).heightIs(85);
    self.backgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.icon.sd_layout.topSpaceToView(self.backgroundView,15).leftSpaceToView(self.backgroundView,25).widthIs(55).heightIs(55);
    ViewRadius(self.icon, 55 / 2.0);
    self.nameLabel.sd_layout.topSpaceToView(self.backgroundView,23).leftSpaceToView(self.icon,14.5).heightIs(14);
    self.companyLabel.sd_layout.topSpaceToView(self.nameLabel,10.5).leftSpaceToView(self.icon,14.5).heightIs(16).rightSpaceToView(self.backgroundView,27);
    self.moreView.sd_layout.centerYIs(self.backgroundView.height / 2.0).rightSpaceToView(self.backgroundView,15).widthIs(12).heightIs(12);
}

- (void)refresh{
    XWUserInfo *userInfo = [XWInstance shareInstance].userInfo;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:userInfo.picture] placeholderImage:LoadImage(@"timg")];
    self.nameLabel.text = userInfo.nick_name;
    self.companyLabel.text = userInfo.company.name;
}
#pragma mark- Setter
#pragma mark- Getter
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
    }
    return _icon;
}

- (UIView *)backshadowView{
    if (!_backshadowView) {
        _backshadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth - 30, 85)];
        _backshadowView.layer.shadowColor = COLOR(198, 207, 241).CGColor;//设置阴影的颜色
        _backshadowView.layer.shadowOpacity = 1.0f;//设置阴影的透明度
        _backshadowView.layer.shadowOffset = CGSizeMake(0, 4);//设置阴影的偏移量
        _backshadowView.layer.shadowRadius = 3;//设置阴影的圆角
    }
    return _backshadowView;
}

- (XWGradientView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[XWGradientView alloc] initWithFrame:CGRectMake(0, 0, kWidth - 30, 85) GradientColors:@[kThemeColor, COLOR(71, 88, 225)]];
        ViewRadius(_backgroundView, 5);
    }
    return _backgroundView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = kFontSize(14);
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)companyLabel{
    if (!_companyLabel) {
        _companyLabel = [UILabel new];
        _companyLabel.font = kFontSize(16);
        _companyLabel.textColor = [UIColor whiteColor];
        
        NSLog(@"size = %f",_companyLabel.font.pointSize);
    }
    return _companyLabel;
}

- (UIImageView *)moreView{
    if (!_moreView) {
        _moreView = [UIImageView new];
        _moreView.image = LoadImage(@"右");
    }
    return _moreView;
}
#pragma mark- LifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
@end
