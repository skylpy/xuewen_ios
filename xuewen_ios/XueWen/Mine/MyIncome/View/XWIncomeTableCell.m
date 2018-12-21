//
//  XWIncomeTableCell.m
//  XueWen
//
//  Created by Karron Su on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWIncomeTableCell.h"

@interface XWIncomeTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;


@end

@implementation XWIncomeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImg rounded:18];
    self.separatorInset = UIEdgeInsetsMake(0, 26, 0, 25);
}

- (void)setModel:(XWIncomeModel *)model{
    _model = model;
    UIImage *defaultImg;
    if ([_model.sex isEqualToString:@"0"]) {
        defaultImg = DefaultImageGril;
    }else{
        defaultImg = DefaultImageBoy;
    }
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:_model.pictureAll] placeholderImage:defaultImg];
    self.phoneLabel.text = _model.phone;
    self.dateLabel.text = [_model.createTime stringWithDataFormatter:@"yyyy.MM.dd"];
    if (_model.commissionPrice == nil && _model.orderPrice == nil) { // 红包收益
        self.incomeLabel.text = [NSString stringWithFormat:@"+%@元", _model.price];
        self.midLabel.text = [NSString stringWithFormat:@"摇到%@元", _model.price];
    }else{
        self.incomeLabel.text = [NSString stringWithFormat:@"+%@元", _model.commissionPrice];
        self.midLabel.text = _model.orderPrice;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
