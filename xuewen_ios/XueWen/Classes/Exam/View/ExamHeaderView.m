//
//  ExamHeaderView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/12.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ExamHeaderView.h"
@interface ExamHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation ExamHeaderView
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
    self.titleLabel.sd_layout.heightIs([title heightWithWidth:kWidth - 40 size:16]);
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.sd_layout.leftSpaceToView(self,20).rightSpaceToView(self,20).topSpaceToView(self,30);
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = DefaultTitleAColor;
        _titleLabel.font = kFontSize(16);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
@end
