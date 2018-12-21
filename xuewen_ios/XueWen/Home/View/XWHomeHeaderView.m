//
//  XWHomeHeaderView.m
//  XueWen
//
//  Created by Karron Su on 2018/7/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHomeHeaderView.h"

@interface XWHomeHeaderView ()

@property (nonatomic, strong) UIImageView *smallIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIView *topView;

@end

@implementation XWHomeHeaderView

#pragma mark - Getter
- (UIImageView *)smallIcon{
    if (!_smallIcon) {
        _smallIcon = [[UIImageView alloc] init];
        _smallIcon.contentMode = UIViewContentModeCenter;
    }
    return _smallIcon;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = Color(@"#333333");
        _titleLabel.font = [UIFont fontWithName:kMedFont size:17];
    }
    return _titleLabel;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:LoadImage(@"icon_home_right") forState:UIControlStateNormal];
        [_moreBtn setTitle:@"查看全部 " forState:UIControlStateNormal];
        [_moreBtn setTitleColor:Color(@"#B4A695") forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        _moreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        // 重点位置开始
        _moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _moreBtn.titleLabel.width + 60, 0, -_moreBtn.titleLabel.width - 60);
        _moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_moreBtn.currentImage.size.width, 0, _moreBtn.currentImage.size.width);
        // 重点位置结束
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _moreBtn;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = Color(@"#F4F4F4");
    }
    return _topView;
}

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    
    [self addSubview:self.topView];
    [self addSubview:self.smallIcon];
    [self addSubview:self.titleLabel];
    [self addSubview:self.moreBtn];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    [self.smallIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(25);
        make.bottom.mas_equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(54);
        make.centerY.mas_equalTo(self.smallIcon);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-25);
        make.centerY.mas_equalTo(self.smallIcon);
    }];
}

#pragma mark - Methods
- (void)setTitle:(NSString *)title showMoreBtn:(BOOL)show btnAction:(SEL)action target:(id)target iconName:(NSString *)icon{
    self.titleLabel.text = title;
    
    [self.moreBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (show) {
        self.moreBtn.hidden = NO;
    }else{
        self.moreBtn.hidden = YES;
    }
    self.smallIcon.image = LoadImage(icon);
}

@end
