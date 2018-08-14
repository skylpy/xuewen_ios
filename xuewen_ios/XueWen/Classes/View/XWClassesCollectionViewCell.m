//
//  XWClassesCollectionViewCell.m
//  XueWen
//
//  Created by ShaJin on 2018/1/23.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "XWClassesCollectionViewCell.h"
@interface XWClassesCollectionViewCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation XWClassesCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        self.titleLabel.sd_layout.topSpaceToView(self,0).leftSpaceToView(self,0).bottomSpaceToView(self,0).rightSpaceToView(self,0);
        self.backgroundColor = DefaultBgColor;
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = COLOR(102, 102, 102);
        _titleLabel.textAlignment = 1;
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}
@end
