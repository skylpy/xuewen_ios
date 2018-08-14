//
//  BaseAlertView.m
//  XueWen
//
//  Created by ShaJin on 2017/11/17.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "BaseAlertView.h"
@interface BaseAlertView()
@property(nonatomic,strong)UIView *backgroungView;
@end
@implementation BaseAlertView

#pragma mark- CustomMethod
- (void)setDefaultSettings{
    self.dismissOnTouchOutside = YES;
    self.cornerRadius = 5.0;
    self.isShowShadow = YES;
    // 背景色
    self.backgroundColor = [UIColor whiteColor];
    self.duration = 0.25;
}

- (void)show{
    CGRect oriFrame = self.frame;
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroungView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    switch (_animationType) {
        case kAnimationBottom:{
            self.y = kHeight;
            [UIView animateWithDuration: self.duration animations:^{
                self.frame = oriFrame;
                self.alpha = 1;
                self.backgroungView.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }break;
        case kAnimationRight:{
            // TODU:
            self.x = kWidth;
            [UIView animateWithDuration:self.duration animations:^{
                self.frame = oriFrame;
                self.alpha = 1;
                self.backgroungView.alpha = 1;
            }];
        }break;
        default:{
            
            self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
            self.alpha = 0;
            [UIView animateWithDuration: self.duration animations:^{
                self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
                self.alpha = 1;
                self.backgroungView.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }break;
    }
}

- (void)dismiss{
    CGRect oriFrame = self.frame;
    switch (_animationType) {
        case kAnimationBottom:{
            [UIView animateWithDuration: self.duration animations:^{
                self.y = kHeight;
                self.backgroungView.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [self.backgroungView removeFromSuperview];
                self.frame = oriFrame;
            }];
        }break;
        case kAnimationRight:{
            [UIView animateWithDuration:self.duration animations:^{
                self.x = kWidth;
                self.backgroungView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [self.backgroungView removeFromSuperview];
                self.frame = oriFrame;
            }];
        }break;
        default:{
            [UIView animateWithDuration: self.duration animations:^{
                self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
                self.alpha = 0;
                self.backgroungView.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [self.backgroungView removeFromSuperview];
                self.frame = oriFrame;
            }];
        }break;
    }
}

- (void)touchOutSide{
    if (_dismissOnTouchOutside) {
        [self dismiss];
    }
}

#pragma mark- Setter
- (void)setCornerRadius:(CGFloat)cornerRadius{
    if (cornerRadius >= 0) {
        ViewRadius(self, cornerRadius);
        _cornerRadius = cornerRadius;
    }
}

- (void)setIsShowShadow:(BOOL)isShowShadow{
    _isShowShadow = isShowShadow;
    self.layer.shadowOpacity = isShowShadow ? 0.5 : 0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = isShowShadow ? 2.0 : 0;
}

#pragma mark- Getter
- (UIView *)backgroungView{
    if (!_backgroungView) {
        _backgroungView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _backgroungView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _backgroungView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide)];
        [_backgroungView addGestureRecognizer: tap];
    }
    return _backgroungView;
}
#pragma mark- 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setDefaultSettings];
    }
    return self;
}

@end
