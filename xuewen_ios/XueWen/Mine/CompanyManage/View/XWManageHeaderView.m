//
//  XWManageHeaderView.m
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWManageHeaderView.h"
#import "XWEnterpriseInfoViewController.h"

@interface XWManageHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation XWManageHeaderView

+ (instancetype)shareManageHeaderView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"XWManageHeaderView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor = COLOR(18, 88, 238);
    self.iconImage.userInteractionEnabled = YES;
    self.iconImage.layer.borderWidth = 2;
    self.iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    ViewRadius(self.iconImage, 64 / 2.0);
    [self.iconImage setImageWithURL:[NSURL URLWithString:[XWInstance shareInstance].userInfo.company.co_picture_all] placeholder:LoadImage(@"default_company")];
    self.titleLabel.text = [XWInstance shareInstance].userInfo.company.name;
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextPageBtnClick:(UIButton *)sender {
    [self.navigationController pushViewController:[XWEnterpriseInfoViewController new] animated:YES];
}

- (void)update {
    [self.iconImage setImageWithURL:[NSURL URLWithString:[XWInstance shareInstance].userInfo.company.co_picture_all] placeholder:LoadImage(@"default_company")];
    self.titleLabel.text = [XWInstance shareInstance].userInfo.company.name;
}


@end
