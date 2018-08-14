//
//  InvitationHeaderView.m
//  XueWen
//
//  Created by ShaJin on 2018/3/8.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "InvitationHeaderView.h"
#import "InvitationDetailHeaderView.h"
@interface InvitationHeaderView()

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) UILabel *rightTitleLabel;

@end
@implementation InvitationHeaderView
- (void)setCount:(NSInteger)count money:(NSString *)money{
    self.leftTitleLabel.text = [NSString stringWithFormat:@"已成功邀请%d位好友",(int)count];
    self.rightTitleLabel.text = [NSString stringWithFormat:@"共获得%@元奖学金",money];
}

- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, 0, kWidth, 53)]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.leftTitleLabel];
        [self addSubview:self.rightTitleLabel];
        self.leftTitleLabel.sd_layout.topSpaceToView(self, 0).leftSpaceToView(self, 0).heightIs(53).widthIs(self.width / 2.0);
        self.rightTitleLabel.sd_layout.topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(53).widthIs(self.width / 2.0);
        self.leftTitleLabel.text =@"已成功邀请0位好友";
        self.rightTitleLabel.text = @"共获得0元奖学金";
    }
    return self;
}

- (UILabel *)leftTitleLabel{
    if (!_leftTitleLabel) {
        _leftTitleLabel = [UILabel labelWithTextColor:Color(@"#192041") size:14];
        _leftTitleLabel.textAlignment = 1;
    }
    return _leftTitleLabel;
}

- (UILabel *)rightTitleLabel{
    if (!_rightTitleLabel) {
        _rightTitleLabel = [UILabel labelWithTextColor:Color(@"#192041") size:14];
        _rightTitleLabel.textAlignment = 1;
    }
    return _rightTitleLabel;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 153 / 255.0, 153 / 255.0, 153 / 255.0, 1.0);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, self.centerX, 20);
    //设置下一个坐标点
    CGContextAddLineToPoint(context,self.centerX ,33);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, 238 / 255.0, 238 / 255.0, 238 / 255.0, 1.0);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, self.height);
    //设置下一个坐标点
    CGContextAddLineToPoint(context,self.width ,self.height);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}
@end
