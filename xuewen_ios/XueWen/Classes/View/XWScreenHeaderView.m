//
//  XWScreenHeaderView.m
//  XueWen
//
//  Created by ShaJin on 2018/1/15.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "XWScreenHeaderView.h"
@interface XWScreenHeaderView()

@property (nonatomic, strong) UILabel *titleLable;

@end
@implementation XWScreenHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLable];
        self.titleLable.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 15, 0, 15));
    }
    return self;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [UILabel labelWithTextColor:DefaultTitleAColor size:15];
    }
    return _titleLable;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLable.text = title;
}
@end
