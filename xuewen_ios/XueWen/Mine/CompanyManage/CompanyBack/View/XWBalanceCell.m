//
//  XWBalanceCell.m
//  XueWen
//
//  Created by aaron on 2018/12/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBalanceCell.h"

@interface XWBalanceCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation XWBalanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.stateLabel.textColor = Color(@"#FF3030");
    self.moneyLabel.textColor = Color(@"#FF3030");
}

- (void)setModel:(XWRecordModel *)model {
    _model = model;
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单编号：%@",model.orderID];
    self.timeLabel.text = [model.createTime stringWithDataFormatter:@"yyyy-MM-dd mm:ss"];
    self.balanceLabel.text = [NSString stringWithFormat:@"余额：¥%@",model.userGold];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.payLabel.text = [NSString stringWithFormat:@"交易方式：%@",model.payTypeName];
    self.stateLabel.text = [NSString stringWithFormat:@"交易状态：%@",[model.state isEqualToString:@"0"]?@"成功":[model.state isEqualToString:@"0"]?@"失败":@"取消"];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 238 / 255.0, 238 / 255.0, 238 / 255.0, 1.0);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, kWidth ,0);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
