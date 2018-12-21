//
//  MyCourseNewHeaderView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/25.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyCourseNewHeaderView.h"
#import "MyCourseHeaderButton.h"
@interface MyCourseNewHeaderView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIImageView *moreIcon;
@property (nonatomic, strong) UIButton *companyDetailButton;
@property (nonatomic, strong) MyCourseHeaderButton *learningButton; // 在学课程
@property (nonatomic, strong) MyCourseHeaderButton *continueButton; // 坚持学习
@property (nonatomic, strong) MyCourseHeaderButton *totalButton;    // 累计学时

@end

@implementation MyCourseNewHeaderView

#pragma mark- CustomMethod
- (void)refresh{
    XWUserInfo *userInfo = [XWInstance shareInstance].userInfo;
    UIImage *defaultImg = [[UIImage alloc] init];
    if ([userInfo.sex isEqualToString:@"0"]){
        defaultImg = DefaultImageGril;
    }else{
        defaultImg = DefaultImageBoy;
    }
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:userInfo.picture] placeholderImage:defaultImg];
    self.namelabel.text = userInfo.nick_name;
    self.companyLabel.text = userInfo.company.name;
    self.companyLabel.sd_layout.widthIs([userInfo.company.name widthWithSize:self.companyLabel.font.pointSize]);
    self.companyDetailButton.sd_layout.widthIs([userInfo.company.name widthWithSize:self.companyLabel.font.pointSize] + 40);
    
    if ([[XWInstance shareInstance].userInfo.role_id isEqualToString:@"3"]) { // 个人用户
        self.companyLabel.hidden = YES;
        self.moreIcon.hidden = YES;
        self.companyDetailButton.hidden = YES;
    }else{
        self.companyLabel.hidden = NO;
        self.moreIcon.hidden = NO;
        self.companyDetailButton.hidden = NO;
    }
    
    self.learningButton.content = @"0门";
    self.continueButton.content = @"0天";
    self.totalButton.content = @"0分";
    
    self.learningButton.enabled = NO;
    self.continueButton.enabled = NO;
    self.totalButton.enabled = NO;
}

#pragma mark- Setter
#pragma mark- Getter
- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [UIImageView new];
        ViewRadius(_headImage, 55 / 2);
    }
    return _headImage;
}

- (UILabel *)namelabel{
    if (!_namelabel) {
        _namelabel = [UILabel labelWithTextColor:DefaultTitleAColor size:15];
        _namelabel.textAlignment = 1;
    }
    return _namelabel;
}

- (UILabel *)companyLabel{
    if (!_companyLabel) {
        _companyLabel = [UILabel labelWithTextColor:DefaultTitleCColor size:13];
    }
    return _companyLabel;
}

- (UIImageView *)moreIcon{
    if (!_moreIcon) {
        _moreIcon = [UIImageView new];
        _moreIcon.image = LoadImage(@"home_ico_arrow");
    }
    return _moreIcon;
}

- (UIButton *)companyDetailButton{
    if (!_companyDetailButton) {
        _companyDetailButton = [UIButton buttonWithType:0];
    }
    return _companyDetailButton;
}

- (MyCourseHeaderButton *)learningButton{
    if (!_learningButton) {
        _learningButton = [MyCourseHeaderButton buttonWithType:0];
        _learningButton.title = @"在学课程";
    }
    return _learningButton;
}

- (MyCourseHeaderButton *)continueButton{
    if (!_continueButton) {
        _continueButton = [MyCourseHeaderButton buttonWithType:0];
        _continueButton.title = @"坚持学习";
    }
    return _continueButton;
}

- (MyCourseHeaderButton *)totalButton{
    if (!_totalButton) {
        _totalButton = [MyCourseHeaderButton buttonWithType:0];
        _totalButton.title = @"累计学时";
    }
    return _totalButton;
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}

#pragma mark- LifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DefaultBgColor;
        self.userInteractionEnabled = YES;
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.headImage];
        [self.backgroundView addSubview:self.namelabel];
        [self.backgroundView addSubview:self.companyLabel];
        [self.backgroundView addSubview:self.moreIcon];
        [self.backgroundView addSubview:self.companyDetailButton];
        
        // 不能删！！！
//        [self.backgroundView addSubview:self.learningButton];
//        [self.backgroundView addSubview:self.continueButton];
//        [self.backgroundView addSubview:self.totalButton];
        
        self.backgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 10, 0));
        
        self.headImage.sd_layout.centerXEqualToView(self.backgroundView).topSpaceToView(self.backgroundView,30).widthIs(55).heightIs(55);
        self.namelabel.sd_layout.topSpaceToView(self.headImage,9.5).leftSpaceToView(self.backgroundView,15).rightSpaceToView(self.backgroundView,15).heightIs(14.5);
        self.companyLabel.sd_layout.centerXEqualToView(self.backgroundView).topSpaceToView(self.namelabel,11).heightIs(12.5);
        self.moreIcon.sd_layout.centerYEqualToView(self.companyLabel).leftSpaceToView(self.companyLabel,9.5).widthIs(7).heightIs(12);
        self.companyDetailButton.sd_layout.centerXEqualToView(self.backgroundView).topSpaceToView(self.namelabel,0).heightIs(34.5);
        [self bringSubviewToFront:self.companyDetailButton];
        // 不能删！！！
//        self.learningButton.sd_layout.topSpaceToView(self.companyDetailButton,0).bottomSpaceToView(self.backgroundView,0).leftSpaceToView(self.backgroundView,0).widthIs(self.width / 3.0);
//        self.totalButton.sd_layout.topSpaceToView(self.companyDetailButton,0).bottomSpaceToView(self.backgroundView,0).rightSpaceToView(self.backgroundView,0).widthIs(self.width / 3.0);
//        self.continueButton.sd_layout.topSpaceToView(self.companyDetailButton,0).bottomSpaceToView(self.backgroundView,0).leftSpaceToView(self.learningButton,0).rightSpaceToView(self.totalButton,0);
        
    }
    return self;
}

- (void)addTarget:(id)target detailAction:(SEL)detailAction learningAction:(SEL)learningAction continueAction:(SEL)continueAction totalAction:(SEL)totalAction{
    [self.companyDetailButton addTarget:target action:detailAction forControlEvents:UIControlEventTouchUpInside];
    [self.learningButton addTarget:target action:learningAction forControlEvents:UIControlEventTouchUpInside];
    [self.continueButton addTarget:target action:continueAction forControlEvents:UIControlEventTouchUpInside];
    [self.totalButton addTarget:target action:totalAction forControlEvents:UIControlEventTouchUpInside];
}
@end
