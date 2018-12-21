//
//  XWOrderDateilCell.m
//  XueWen
//
//  Created by aaron on 2018/12/13.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWOrderDateilCell.h"
#import "CAShapeLayer+XWLayer.h"

@interface XWOrderDateilCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation XWOrderDateilCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = Color(@"#F6F6F6");
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.bgView.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, kWidth-30, 112) withCornerRadius:5 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    [self.coverImage.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, 130, 80) withCornerRadius:2 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
}

- (void)setModel:(XWCompanyOrderModel *)model {
    _model = model;
    
    [self.coverImage setImageWithURL:[NSURL URLWithString:model.coverPhoto] placeholder:DefaultImage];
    self.titleLabel.text = model.courseName;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@",model.price];
    
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
    CGContextMoveToPoint(context, 15, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, kWidth-30 ,0);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
