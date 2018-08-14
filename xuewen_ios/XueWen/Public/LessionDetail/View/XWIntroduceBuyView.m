//
//  XWIntroduceBuyView.m
//  XueWen
//
//  Created by ShaJin on 2018/1/10.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "XWIntroduceBuyView.h"
//#import "AlertConfirmView.h"
#import <objc/message.h>
@interface XWIntroduceBuyView ()

@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *learnButton;
@property (nonatomic, strong) UILabel  *priceLabel;
@property (nonatomic, assign) SEL      buyAction;
@property (nonatomic, weak) id         target;

@end
@implementation XWIntroduceBuyView
- (void)buy{
    objc_msgSend(self.target, self.buyAction);
}

- (instancetype)initWithTarget:(id)target buyAction:(SEL)buyAction learnAction:(SEL)learnAction{
    if (self = [super initWithFrame:CGRectMake(0, 0, kWidth, 49)]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.buyButton];
        [self addSubview:self.learnButton];
        [self addSubview:self.priceLabel];
        self.learnButton.hidden = YES;
        [self.buyButton addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
        [self.learnButton addTarget:target action:learnAction forControlEvents:UIControlEventTouchUpInside];
        self.buyAction = buyAction;
        self.target = target;
        self.layer.shadowColor = COLOR(204, 208, 225).CGColor;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(0, -2.5);
        
    }
    return self;
}

- (void)setPrice:(NSString *)price{
    _price = price;
    if ([price floatValue] > 0) {
        self.learnButton.hidden = YES;
        self.buyButton.hidden = NO;
        self.priceLabel.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"%@元",price];
    }else{
        self.learnButton.hidden = NO;
        self.buyButton.hidden = YES;
        self.priceLabel.hidden = YES;
    }
}

- (UIButton *)buyButton{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:0];
        _buyButton.frame = CGRectMake(kWidth / 3.0, 0, kWidth / 3.0 * 2, 49);
        [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        _buyButton.titleLabel.font = kFontSize(16);
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyButton setTitleColor:DefaultTitleDColor forState:UIControlStateHighlighted];
        [_buyButton setBackgroundColor:COLOR(252, 101, 30)];
    }
    return _buyButton;
}

- (UIButton *)learnButton{
    if (!_learnButton) {
        _learnButton = [UIButton buttonWithType:0];
        _learnButton.frame = CGRectMake(0, 0, kWidth, 49);
        [_learnButton setTitle:@"开始学习" forState:UIControlStateNormal];
        [_learnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_learnButton setTitleColor:DefaultTitleDColor forState:UIControlStateHighlighted];
        [_learnButton setBackgroundColor:kThemeColor];
        _learnButton.titleLabel.font = kFontSize(16);
    }
    return _learnButton;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth / 3.0, 49)];
        _priceLabel.textAlignment = 1;
        //        _priceLabel.text = @"**";
        _priceLabel.font = kFontSize(15);
        _priceLabel.textColor = COLOR(252, 101, 30);
    }
    return _priceLabel;
}

+ (instancetype)buyViewWithTarget:(id)target buyAction:(SEL)buyAction learnAction:(SEL)learnAction{
    return [[XWIntroduceBuyView alloc] initWithTarget:target buyAction:buyAction learnAction:learnAction];
}
@end
