//
//  XWBalanceView.m
//  XueWen
//
//  Created by aaron on 2018/12/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBalancesView.h"

@interface XWBalancesView ()

@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet UIButton *consumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *giveBtn;

@end

@implementation XWBalancesView

+ (instancetype)shareBalanceView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"XWBalancesView" owner:self options:nil].firstObject;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.rechargeBtn.selected = YES;
    [self.rechargeBtn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
    [self.rechargeBtn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateSelected];
    self.rechargeBtn.titleLabel.font = [UIFont fontWithName:kMedFont size:15];
    [self.rechargeBtn setTitle:@"充值记录" forState:UIControlStateNormal];
    
    [self.consumeBtn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
    [self.consumeBtn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateSelected];
    self.consumeBtn.titleLabel.font = [UIFont fontWithName:kMedFont size:15];
    [self.consumeBtn setTitle:@"消费记录" forState:UIControlStateNormal];
    
    [self.giveBtn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
    [self.giveBtn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateSelected];
    self.giveBtn.titleLabel.font = [UIFont fontWithName:kMedFont size:15];
    [self.giveBtn setTitle:@"赠送记录" forState:UIControlStateNormal];
    
    @weakify(self)
    [[self.rechargeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self actionButtonClick:x];
    }];
    [[self.consumeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self actionButtonClick:x];
    }];
    [[self.giveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self actionButtonClick:x];
    }];
}

- (void)actionButtonClick:(UIButton *)sender {
    
    for (int i = 1000; i < 1003; i ++) {
        UIButton * button = [self viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
    NSString * oid = @"0";
    if (sender.tag == 1000) {
        oid = @"0";
    }else if (sender.tag == 1001){
        oid = @"1";
    }else {
        oid = @"2";
    }
    !self.balancesClick?:self.balancesClick(oid);
}


@end
