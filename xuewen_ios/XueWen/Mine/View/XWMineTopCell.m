//
//  XWMineTopCell.m
//  XueWen
//
//  Created by Karron Su on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWMineTopCell.h"
#import "MyWalletViewController.h"
#import "XWIncomeViewController.h"

@interface XWMineTopCell ()

@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletLabel;
@property (weak, nonatomic) IBOutlet UIButton *incomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *walletBtn;


@end

@implementation XWMineTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.walletLabel.text = [NSString stringWithFormat:@"￥%@",[XWInstance shareInstance].userInfo.gold];
    self.incomeLabel.text = [NSString stringWithFormat:@"￥%@", [XWInstance shareInstance].userInfo.earnings_price];
    [self addNotificationWithName:PersonalInformationUpdate selector:@selector(setheaderViewInfo)];
}
- (IBAction)incomeClick:(UIButton *)sender {
    [self.navigationController pushViewController:[XWIncomeViewController new] animated:YES];
}

- (IBAction)walletBtnClick:(id)sender {
    [self.navigationController pushViewController:[MyWalletViewController new] animated:YES];
}

- (void)setheaderViewInfo{
    self.walletLabel.text = [NSString stringWithFormat:@"￥%@",[XWInstance shareInstance].userInfo.gold];
    self.incomeLabel.text = [NSString stringWithFormat:@"￥%@", [XWInstance shareInstance].userInfo.earnings_price];
}

- (void)dealloc{
    [self removeNotification];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
