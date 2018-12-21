//
//  XWOrderDateilTopCell.m
//  XueWen
//
//  Created by aaron on 2018/12/13.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWOrderDateilTopCell.h"
#import "CAShapeLayer+XWLayer.h"
#import "NSMutableAttributedString+XWUtil.h"

@interface XWOrderDateilTopCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation XWOrderDateilTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = Color(@"#F6F6F6");
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.bgView.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, kWidth-30, 259) withCornerRadius:5 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    self.orderLabel.textColor = Color(@"#666666");
    self.startTimeLabel.textColor = Color(@"#666666");
    self.endTimeLabel.textColor = Color(@"#666666");
    self.orderMoneyLabel.textColor = Color(@"#666666");
    self.discountLabel.textColor = Color(@"#666666");
    self.stateLabel.textColor = Color(@"#666666");
}

- (void)setModel:(XWCompanyOrderModel *)model {
    _model = model;
    self.orderLabel.attributedText = [NSMutableAttributedString setupAttributeString:[self attributedText:@"订单编号：" with:model.orderID] rangeText:model.orderID textFont:[UIFont fontWithName:kRegFont size:14] textColor:Color(@"#333333")];
    
    self.startTimeLabel.attributedText = [NSMutableAttributedString setupAttributeString:[self attributedText:@"订单时间：" with:[model.creatTime stringWithDataFormatter:@"yyyy-MM-dd hh:mm:ss"]] rangeText:[model.creatTime stringWithDataFormatter:@"yyyy-MM-dd hh:mm:ss"] textFont:[UIFont fontWithName:kRegFont size:14] textColor:Color(@"#333333")];
    
    self.endTimeLabel.attributedText = [NSMutableAttributedString setupAttributeString:[self attributedText:@"到期时间：" with:[model.updateTime stringWithDataFormatter:@"yyyy-MM-dd hh:mm:ss"]] rangeText:[model.updateTime stringWithDataFormatter:@"yyyy-MM-dd hh:mm:ss"] textFont:[UIFont fontWithName:kRegFont size:14] textColor:Color(@"#333333")];
    
    self.orderMoneyLabel.attributedText = [NSMutableAttributedString setupAttributeString:[self attributedText:@"订单金额：" with:[NSString stringWithFormat:@"¥ %@",model.price]] rangeText:[NSString stringWithFormat:@"¥ %@",model.price] textFont:[UIFont fontWithName:kRegFont size:14] textColor:Color(@"#F25553")];
    
    self.discountLabel.attributedText = [NSMutableAttributedString setupAttributeString:[self attributedText:@"优惠金额：" with:[NSString stringWithFormat:@"¥ %@",model.orderAmount]] rangeText:[NSString stringWithFormat:@"¥ %@",model.orderAmount] textFont:[UIFont fontWithName:kRegFont size:14] textColor:Color(@"#F25553")];
    
    self.stateLabel.text = [model.status isEqualToString:@"0"]?@"订单状态：待支付":[model.status isEqualToString:@"1"]?@"订单状态：   已完成":@"订单状态：   已取消";
    
}

- (NSString *)attributedText:(NSString *)as with:(NSString *)de {
    
    return [NSString stringWithFormat:@"%@   %@",as,de];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
