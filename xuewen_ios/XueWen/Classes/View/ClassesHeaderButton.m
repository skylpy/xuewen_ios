//
//  ClassesHeaderButton.m
//  XueWen
//
//  Created by ShaJin on 2017/11/15.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ClassesHeaderButton.h"

@interface ButtonView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *icon;

@end
@implementation ButtonView

- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, 0, 0, 20)]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.icon];
        self.titleLabel.sd_layout.topSpaceToView(self,0).leftSpaceToView(self,0).bottomSpaceToView(self,0);
        self.icon.sd_layout.topSpaceToView(self,0).rightSpaceToView(self,0).widthIs(20).heightIs(20);
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = COLOR(51, 51, 51);
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.image = LoadImage(@"icoDropDown");
    }
    return _icon;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
    self.titleLabel.width = [title widthWithSize:13];
    self.width = self.titleLabel.width + 20;
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        self.titleLabel.textColor = kThemeColor;
        self.icon.image = LoadImage(@"icoPackUp");
    }else{
        self.titleLabel.textColor = COLOR(51, 51, 51);
        self.icon.image = LoadImage(@"icoDropDown");
    }
}

@end

@interface ClassesHeaderButton()

@property (nonatomic, strong) ButtonView *view;

@end
@implementation ClassesHeaderButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.view];
    }
    return self;
}

- (ButtonView *)view{
    if (!_view) {
        _view = [ButtonView new];
    }
    return _view;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _view.title = title;
    _view.center = CGPointMake(self.width / 2.0, self.height / 2.0);
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    _view.isSelect = isSelect;
}

@end
