//
//  MyCourseHeaderButton.m
//  XueWen
//
//  Created by ShaJin on 2017/12/25.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyCourseHeaderButton.h"

@interface MyCourseHeaderButton()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;

@end
@implementation MyCourseHeaderButton
- (void)setTitle:(NSString *)title{
    _title = title;
    self.label2.text = title;
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.label1.text = content;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.label1];
        [self.backgroundView addSubview:self.label2];
        
        self.backgroundView.sd_layout.centerYEqualToView(self).leftSpaceToView(self,0).rightSpaceToView(self,0).heightIs(35.5);
        self.label1.sd_layout.topSpaceToView(self.backgroundView,0).leftSpaceToView(self.backgroundView,0).rightSpaceToView(self.backgroundView,0).heightIs(14);
        self.label2.sd_layout.bottomSpaceToView(self.backgroundView,0).leftSpaceToView(self.backgroundView,0).rightSpaceToView(self.backgroundView,0).heightIs(14);
        
        self.backgroundView.userInteractionEnabled = NO;
    }
    return self;
}

- (UILabel *)label1{
    if (!_label1) {
        _label1 = [UILabel labelWithTextColor:kThemeColor size:14];
        _label1.textAlignment = 1;
    }
    return _label1;
}

- (UILabel *)label2{
    if (!_label2) {
        _label2 = [UILabel labelWithTextColor:DefaultTitleAColor size:14];
        _label2.textAlignment = 1;
    }
    return _label2;
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [UIView new];
    }
    return _backgroundView;
}
@end
