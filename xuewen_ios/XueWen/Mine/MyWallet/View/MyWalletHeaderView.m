//
//  MyWalletHeaderView.m
//  XueWen
//
//  Created by ShaJin on 2017/11/16.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyWalletHeaderView.h"
@interface MyWalletHeaderView()

@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end
@implementation MyWalletHeaderView
- (instancetype)initWithTarget:(id)target backAction:(SEL)backAction detailAction:(SEL)detailAction{
    if (self = [super initWithFrame:CGRectMake(0, 0, kWidth, 100)]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.countLabel];
        
        self.moneyLabel.sd_layout.topSpaceToView(self, 28.5).heightIs(12).leftSpaceToView(self, 15).rightSpaceToView(self, 15);
        self.countLabel.sd_layout.topSpaceToView(self.moneyLabel, 9).heightIs(30).leftSpaceToView(self, 15).rightSpaceToView(self, 15);
    }
    return self;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 106, kWidth, 12)];
        _moneyLabel.font = [UIFont systemFontOfSize:12];
        _moneyLabel.textColor = DefaultTitleCColor;
        _moneyLabel.textAlignment = 1;
        _moneyLabel.text = @"可用余额（元）";
    }
    return _moneyLabel;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 126, kWidth, 30)];
        _countLabel.font = [UIFont systemFontOfSize:30];
        _countLabel.textColor = kThemeColor;
        _countLabel.textAlignment = 1;
        _countLabel.text = @"0";
    }
    return _countLabel;
}

- (void)setMoney:(NSString *)money{
    _money = money;
    self.countLabel.text = money;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
