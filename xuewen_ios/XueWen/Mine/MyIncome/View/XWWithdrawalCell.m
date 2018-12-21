//
//  XWWithdrawalCell.m
//  XueWen
//
//  Created by Karron Su on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWWithdrawalCell.h"

@interface XWWithdrawalCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end

@implementation XWWithdrawalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.separatorInset = UIEdgeInsetsMake(0, 18, 0, 17);
}

- (void)setModel:(XWTransactionListModel *)model{
    _model = model;
    self.dateLabel.text = [_model.createTime transTimeWithDateFormatter:@"yyyy.MM.dd"];
    self.amountLabel.text = [NSString stringWithFormat:@"¥%@", _model.price];
    self.statusLabel.text = _model.reviewStatus;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
