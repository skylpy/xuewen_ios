//
//  HomeSectionHeaderView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/4.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "HomeSectionHeaderView.h"
#import "MoreButton.h"

@interface HomeSectionHeaderView()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) MoreButton *moreButton;

@end
@implementation HomeSectionHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.moreButton];
        
        
        self.title.sd_layout.topSpaceToView(self.contentView,15).leftSpaceToView(self.contentView,15).bottomSpaceToView(self.contentView,15);
        self.moreButton.sd_layout.topSpaceToView(self.contentView,17).rightSpaceToView(self.contentView,15).bottomSpaceToView(self.contentView,15).widthIs(50);
    }
    return self;
}

- (void)setTitle:(NSString *)title showMore:(BOOL)show target:(id)target action:(SEL)action{
    self.title.text = title;
    self.title.sd_layout.widthIs([title widthWithSize:16]);
    if ([title isEqualToString:@"在学课程"]) {
        self.moreButton.tag = 100;
    }else if ([title isEqualToString:@"推荐课程"]){
        self.moreButton.tag = 200;
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

- (MoreButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [MoreButton buttonWithType:0];
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:DefaultTitleCColor forState:UIControlStateNormal];
        
    }
    return _moreButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
