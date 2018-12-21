//
//  XWCompanyBackView.m
//  XueWen
//
//  Created by aaron on 2018/12/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWComBackView.h"

@interface XWComBackView ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;

@end

@implementation XWComBackView

+ (instancetype)shareCompanyBackView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"XWComBackView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = Color(@"#2866E1");
    ViewRadius(self.rechargeBtn, 5);
    
    self.moneyLabel.text = [XWInstance shareInstance].userInfo.company_gold;
    
    @weakify(self)
    [[self.rechargeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.rechargeClick?:self.rechargeClick();
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:applePaySucceed object:nil] throttle:1] subscribeNext:^(NSNotification * _Nullable x) {
        
        self.moneyLabel.text = [XWInstance shareInstance].userInfo.company_gold;
    }];
}

@end
