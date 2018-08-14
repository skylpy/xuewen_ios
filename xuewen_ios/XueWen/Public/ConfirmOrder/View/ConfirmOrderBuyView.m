//
//  ConfirmOrderBuyView.m
//  XueWen
//
//  Created by ShaJin on 2018/3/7.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ConfirmOrderBuyView.h"
@interface ConfirmOrderBuyView ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *buyButton;

@end
@implementation ConfirmOrderBuyView
- (void)setCanBuy:(BOOL)canBuy price:(NSString *)price{
    self.hidden = NO;
    if (canBuy) {
        self.buyButton.sd_layout.topSpaceToView(self, 0).bottomSpaceToView(self, 0).rightSpaceToView(self, 0).widthIs(120);
        [self.buyButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [self.buyButton setBackgroundColor:kThemeColor];
        
        self.contentLabel.sd_layout.topSpaceToView(self, 0).leftSpaceToView(self, 15).bottomSpaceToView(self, 0).rightSpaceToView(self.buyButton, 15);
        self.contentLabel.font = kFontSize(14);
        self.contentLabel.textColor = COLOR(252, 101, 30);
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"应付金额：￥%@",price]];
        [attribute addAttribute:NSForegroundColorAttributeName value:DefaultTitleAColor range:NSMakeRange(0, 5)];
        self.contentLabel.attributedText = attribute;
        self.contentLabel.hidden = NO;
    }else{
        self.buyButton.sd_layout.topSpaceToView(self, 0).widthIs(kWidth).bottomSpaceToView(self, 0).rightSpaceToView(self, 0);
        [self.buyButton setBackgroundColor:COLOR(252, 101, 30)];
        [self.buyButton setTitle:@"去充值" forState:UIControlStateNormal];
        self.contentLabel.hidden = YES;
    }
}

- (instancetype)initWithTarget:(id)target action:(SEL)action{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentLabel];
        [self addSubview:self.buyButton];
        [self.buyButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        self.hidden = YES;
    }
    return self;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    return _contentLabel;
}

- (UIButton *)buyButton{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:0];
    }
    return _buyButton;
}
@end
