//
//  XWScholarShipCell.m
//  XueWen
//
//  Created by aaron on 2018/12/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWScholarShipCell.h"
#import "NSMutableAttributedString+XWUtil.h"

@interface XWScholarShipCell()
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation XWScholarShipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = Color(@"#F9F9F9");
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImage *limage = [UIImage imageNamed:@"leftImage"];
    self.leftView.layer.contents = (id) limage.CGImage;
    // 如果需要背景透明加上下面这句
    self.leftView.layer.backgroundColor = [UIColor clearColor].CGColor;

    UIImage *rimage = [UIImage imageNamed:@"rightImage"];
    self.rightView.layer.contents = (id) rimage.CGImage;
    // 如果需要背景透明加上下面这句
    self.rightView.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    self.moneyLabel.textColor = Color(@"#FFFFFF");
    self.titleLabel.textColor = Color(@"#333333");
    self.desLabel.textColor = Color(@"#999999");
    self.dateLabel.textColor = Color(@"#999999");
    
    
}

- (void)setModel:(CouponModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.moneyLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"¥%@",model.price] rangeText:model.price textFont:[UIFont fontWithName:kMedFont size:21] textColor:Color(@"#FFFFFF")];
    self.desLabel.text = model.describe;
    self.dateLabel.text = model.useTime;
    self.selectButton.selected = model.isSelect;
    
    if (model.canUse) {
        UIImage *limage = [UIImage imageNamed:@"leftImage"];
        self.leftView.layer.contents = (id) limage.CGImage;
        // 如果需要背景透明加上下面这句
        self.leftView.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.moneyLabel.textColor = Color(@"#FFFFFF");
        self.titleLabel.textColor = Color(@"#333333");
        self.desLabel.textColor = Color(@"#999999");
        self.dateLabel.textColor = Color(@"#999999");
    }else {
        UIImage *limage = [UIImage imageNamed:@"gray553"];
        self.leftView.layer.contents = (id) limage.CGImage;
        // 如果需要背景透明加上下面这句
        self.leftView.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.moneyLabel.textColor = Color(@"#FFFFFF");
        self.titleLabel.textColor = Color(@"#999999");
        self.desLabel.textColor = Color(@"#999999");
        self.dateLabel.textColor = Color(@"#999999");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
