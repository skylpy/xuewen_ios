//
//  ClassesInfoHeaderView.m
//  XueWen
//
//  Created by ShaJin on 2017/11/15.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ClassesInfoHeaderView.h"
@interface ClassesInfoHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation ClassesInfoHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setCount:(NSInteger)count{
    _count = count;
    if (count >= 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"共找到%ld门课程",(long)count];
    }
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 10)];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = COLOR(153, 153, 153);
    }
    return _titleLabel;
}
@end
