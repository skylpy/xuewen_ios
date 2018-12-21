//
//  XWDiscountTableCell.m
//  XueWen
//
//  Created by Karron Su on 2018/12/15.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWDiscountTableCell.h"

@interface XWDiscountTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *choiceIcon;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@end

@implementation XWDiscountTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Setter
- (void)setModel:(XWDiscountModel *)model {
    _model = model;
    self.titleLabel.text = _model.coupon_name;
    NSString *title = [NSString stringWithFormat:@"¥ %@", _model.coupon_amount];
    NSRange range = [title rangeOfString:@"¥"];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    UIFont *font = [UIFont systemFontOfSize:14];
    [attr addAttribute:NSFontAttributeName value:font range:range];
    self.leftLabel.attributedText = attr;
    self.descLabel.text = _model.coupon_desc;
    self.timeLabel.text = [NSString stringWithFormat:@"有效期至: %@", [NSDate dateFormTimestamp:_model.coupon_validity_time withFormat:@"yyyy.MM.dd"]];
    if ([_model.coupon_status isEqualToString:@"3"]) {
        self.leftIcon.image = LoadImage(@"gray553");
    }else {
        self.leftIcon.image = LoadImage(@"leftImage");
    }
    if (_model.isSelect) {
        self.choiceIcon.image = LoadImage(@"Checklist2");
    }else {
        self.choiceIcon.image = nil;
    }
}

@end
