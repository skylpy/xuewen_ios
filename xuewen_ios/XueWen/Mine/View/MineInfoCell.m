//
//  MineInfoCell.m
//  XueWen
//
//  Created by ShaJin on 2017/11/16.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MineInfoCell.h"
@interface MineInfoCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *contentLabel;

@end
@implementation MineInfoCell
- (void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
    [self setNeedsDisplay];
}

- (void)setHeaderImage:(UIImage *)image{
    self.headImage.image = image;
}

- (void)setContent:(NSString *)content{
    self.contentLabel.text = content;
}

- (void)setTitle:(NSString *)title content:(NSString *)content type:(NSInteger)type canEdit:(BOOL)canEdit{
    if (canEdit) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    self.titleLabel.sd_layout.widthIs([title widthWithSize:14]);
    self.titleLabel.text = title;
    switch (type) {
        case 0:{
            self.contentLabel.hidden = YES;
            self.headImage.hidden = NO;
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:content] placeholderImage:LoadImage(@"default_head")];
        }break;
        case 1:{
            self.contentLabel.hidden = NO;
            self.headImage.hidden = YES;
            self.contentLabel.text = content;
        }break;
        case 2:{
            self.headImage.hidden = YES;
            self.contentLabel.hidden = YES;
        }break;
        case 3:{
            self.contentLabel.hidden = NO;
            self.headImage.hidden = YES;
            NSString *text = [NSString stringWithFormat:@"*%@",title];
            NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:text];
            [attribute addAttribute:NSForegroundColorAttributeName value:COLOR(251, 27, 27) range: NSMakeRange(0, 1)];
            self.titleLabel.attributedText = attribute;
            self.titleLabel.sd_layout.widthIs([text widthWithSize:14]);
            self.contentLabel.text = content;
        }break;
        default:
            break;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.headImage];
        [self addSubview:self.contentLabel];
        
        self.titleLabel.sd_layout.topSpaceToView(self,0).bottomSpaceToView(self,0).leftSpaceToView(self,15);
        self.headImage.sd_layout.topSpaceToView(self,15).rightSpaceToView(self,32).widthIs(50).heightIs(50);
        self.contentLabel.sd_layout.topSpaceToView(self,0).bottomSpaceToView(self,0).rightSpaceToView(self,32).leftSpaceToView(self.titleLabel,15);
        
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = COLOR(51, 51, 51);
    }
    return _titleLabel;
}

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [UIImageView new];
        ViewRadius(_headImage, 25);
    }
    return _headImage;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = COLOR(153, 153, 153);
        _contentLabel.textAlignment = 2;
    }
    return _contentLabel;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (!_isFirst) {
        //获得处理的上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        //设置线条样式
        CGContextSetLineCap(context, kCGLineCapSquare);
        //设置颜色
        CGContextSetRGBStrokeColor(context, 204 / 255.0, 208 / 255.0, 225 / 255.0, 0.2);
        //设置线条粗细宽度
        CGContextSetLineWidth(context, 1);
        //开始一个起始路径
        CGContextBeginPath(context);
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, 15, 0);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, kWidth ,0);
        //连接上面定义的坐标点
        CGContextStrokePath(context);
    }
}
@end
