//
//  PageTitleView.m
//  XueWen
//
//  Created by ShaJin on 2018/1/25.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "PageTitleView.h"
@interface PageTitleView()

@property (nonatomic, strong) UIView *backgrountView;
@property (nonatomic, strong) UIImageView *arrow;

@end
@implementation PageTitleView
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames{
    if (self = [super initWithFrame:frame delegate:delegate titleNames:titleNames]) {
        self.backgroundColor = [UIColor whiteColor];
        self.backgrountView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 5);
        [self insertSubview:self.backgrountView atIndex:0];
        self.titleColorStateNormal = COLOR(204, 208, 225);
        self.titleColorStateSelected = [UIColor whiteColor];
        self.indicatorColor = [UIColor whiteColor];
        self.indicatorLengthStyle = SGIndicatorLengthTypeEqual;
        self.indicatorHeight = 5;
        [self.indicatorView addSubview:self.arrow];
        self.arrow.sd_layout.centerXEqualToView(self.indicatorView).topSpaceToView(self.indicatorView, 0).widthIs(8.5).heightIs(5);
    }
    return self;
}

- (UIView *)backgrountView{
    if (!_backgrountView) {
        _backgrountView = [UIView new];
        _backgrountView.backgroundColor = DefaultTitleAColor;
    }
    return _backgrountView;
}

- (UIImageView *)arrow{
    if (!_arrow) {
        _arrow = [[UIImageView alloc] initWithImage:LoadImage(@"specialIcoTriangle")];
    }
    return _arrow;
}
@end
