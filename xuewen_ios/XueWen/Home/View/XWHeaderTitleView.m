//
//  XWHeaderTitleView.m
//  XueWen
//
//  Created by Karron Su on 2018/4/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHeaderTitleView.h"

@interface XWHeaderTitleView ()
/** 标题*/
@property (nonatomic, strong) UILabel *titleLab;
/** 更多btn*/
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation XWHeaderTitleView

#pragma mark - lazy / Getter
- (UILabel *)titleLab{
    if (!_titleLab) {
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = Color(@"#333333");
        lab.font = XWFont(kHeaFont, 18);
        _titleLab = lab;
    }
    return _titleLab;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"更多 >" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:Color(@"#b7b7b7") forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = XWFont(kRegFont, 12);
        _moreBtn.backgroundColor = [UIColor clearColor];
    }
    return _moreBtn;
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

- (void)drawUI{
    [self addSubview:self.titleLab];
    [self addSubview:self.moreBtn];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(19);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-10);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 24));
    }];
}

#pragma mark - Methods
- (void)setTitle:(NSString *)title showMoreBtn:(BOOL)show btnAction:(SEL)action target:(id)target{
    self.titleLab.text = title;
    
    [self.moreBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (show) {
        self.moreBtn.hidden = NO;
    }else{
        self.moreBtn.hidden = YES;
    }
}

@end
