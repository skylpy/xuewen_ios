//
//  XWOrderManagerCell.m
//  XueWen
//
//  Created by aaron on 2018/12/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWOrderManagerCell.h"
#import "CAShapeLayer+XWLayer.h"

@interface XWOrderManagerCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *ordernumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *canceButton;

@end

@implementation XWOrderManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = Color(@"#F9F9F9");
    [self.coverImage.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, 130, 80) withCornerRadius:2 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    [self.bgView.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, kWidth-30, 200) withCornerRadius:3 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    [self.payButton.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, 70, 30) withCornerRadius:2 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    self.payButton.layer.borderWidth = 1;
    self.payButton.layer.borderColor = Color(@"#E63835").CGColor;
    
    self.ordernumberLabel.textColor = Color(@"#999999");
    self.orderStateLabel.textColor = Color(@"#FF3030");
    self.dateLabel.textColor = Color(@"#999999");
    
    @weakify(self)
    [[self.payButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.payButtonClick?:self.payButtonClick(self.model);
    }];
    [[self.canceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.canceButtonClick?:self.canceButtonClick(self.model);
    }];
}

- (void)setModel:(XWCompanyOrderModel *)model {
    _model = model;
    [self.coverImage setImageWithURL:[NSURL URLWithString:model.coverPhoto] placeholder:DefaultImage];
    self.titleLabel.text = model.courseName;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.orderPrice];
    self.dateLabel.text = [model.creatTime stringWithDataFormatter:@"yyyy-MM-dd"];
    self.ordernumberLabel.text = [NSString stringWithFormat:@"订单编号：%@",model.orderID];
    self.orderStateLabel.text = [model.status isEqualToString:@"0"]?@"订单状态：待支付":[model.status isEqualToString:@"1"]?@"订单状态：已完成":@"订单状态：已取消";
    self.payButton.hidden = [model.status isEqualToString:@"0"]?NO:YES;
    self.canceButton.hidden = [model.status isEqualToString:@"0"]?NO:YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
