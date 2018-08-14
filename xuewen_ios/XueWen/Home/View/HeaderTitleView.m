//
//  HeaderTitleView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/7.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "HeaderTitleView.h"
#import "MoreButton.h"
@interface HeaderTitleView()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) MoreButton *moreButton;

@end
@implementation HeaderTitleView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.title];
        [self addSubview:self.moreButton];
        
        self.icon.sd_layout.leftSpaceToView(self,15).heightIs(10).centerYEqualToView(self);
        self.title.sd_layout.topSpaceToView(self,0).leftSpaceToView(self.icon,5).bottomSpaceToView(self,0);
        self.moreButton.sd_layout.rightSpaceToView(self,15).widthIs(50).centerYEqualToView(self);
    }
    return self;
}

- (void)setTitle:(NSString *)title showIcon:(BOOL)showIcon showMore:(BOOL)show target:(id)target action:(SEL)action{
    self.title.text = title;
    self.icon.sd_layout.widthIs(showIcon ? 10 : 0);
    self.title.sd_layout.leftSpaceToView(self.icon,(showIcon ? 5 : 0)).widthIs([title widthWithSize:16]);
    if ([title isEqualToString:@"在学课程"]) {
        self.moreButton.tag = 100;
    }else if ([title isEqualToString:@"推荐课程"]){
        self.moreButton.tag = 200;
    }else if ([title isEqualToString:@"热门课程"]){
        self.moreButton.tag = 300;
    }else if ([title isEqualToString:@"最近课程"]){
        self.moreButton.tag = 400;
    }else if ([title isEqualToString:@"学习计划"]){
        self.moreButton.tag = 500;
    }
    self.moreButton.hidden = !show;
    [self.moreButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (UILabel *)title{
    if (!_title) {
        _title = [UILabel new];
        _title.textColor = DefaultTitleAColor;
        _title.font = kFontSize(16);
    }
    return _title;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.layer.borderWidth = 2;
        _icon.layer.borderColor = kThemeColor.CGColor;
        ViewRadius(_icon, 5);
    }
    return _icon;
}

- (MoreButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [MoreButton buttonWithType:0];
        _moreButton.frame = CGRectMake(0, 0, 50, 13);
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:DefaultTitleCColor forState:UIControlStateNormal];
        
    }
    return _moreButton;
}

@end
