//
//  ProjectBuyView.m
//  XueWen
//
//  Created by ShaJin on 2018/1/25.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ProjectBuyView.h"
@interface ProjectBuyView ()

@property (nonatomic, strong) UIButton *buyButton;

@end
@implementation ProjectBuyView
- (instancetype)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.buyButton];
        self.buyButton.sd_layout.spaceToSuperView(UIEdgeInsetsMake(20, 15, 15, 11));
        [self.buyButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (UIButton *)buyButton{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:0];
        _buyButton.backgroundColor = kThemeColor;
        ViewRadius(_buyButton, 2);
        [_buyButton setTitle:@"优惠价:￥188.66\n立即购买" forState:UIControlStateNormal];
        UILabel *titleLable = _buyButton.titleLabel;
        titleLable.font = kFontSize(14);
        titleLable.numberOfLines = 0;
        titleLable.textAlignment = 1;
    }
    return _buyButton;
}

- (void)setPrice:(NSString *)price{
    _price = price;
    [_buyButton setTitle:[NSString stringWithFormat:@"优惠价:￥%@\n立即购买",price] forState:UIControlStateNormal];
}

- (void)setOriginalPrice:(NSString *)originalPrice{
    _originalPrice = originalPrice;
    NSString *priceStr = [NSString stringWithFormat:@"¥%@  ¥%@\n立即购买", self.price, _originalPrice];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange range1 = [priceStr rangeOfString:[NSString stringWithFormat:@"¥%@", _originalPrice]];
    [attr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range1];
    [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:10] range:range1];
    NSRange range2 = [priceStr rangeOfString:[NSString stringWithFormat:@"¥%@", self.price]];
    [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kMedFont size:18] range:range2];
    [attr addAttribute:NSForegroundColorAttributeName value:Color(@"#FF854C") range:range2];
    [_buyButton setAttributedTitle:attr forState:UIControlStateNormal];
    
}
@end
