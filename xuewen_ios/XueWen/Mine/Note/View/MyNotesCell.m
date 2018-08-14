//
//  MyNotesCell.m
//  XueWen
//
//  Created by ShaJin on 2017/12/20.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyNotesCell.h"
#import "CourseNoteModel.h"
@interface MyNotesCell()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end
@implementation MyNotesCell

- (void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
    [self setNeedsDisplay];
}

- (void)setModel:(CourseNoteModel *)model{
    _model = model;
    self.contentLabel.text = model.content;
    self.titleLabel.text = model.courseName;
    self.timeLabel.text = model.creatDate;
    self.timeLabel.sd_layout.widthIs([model.creatDate widthWithSize:10]);
    CGFloat height = [model.content heightWithWidth:kWidth - 30 size:14];
    self.contentLabel.sd_layout.heightIs(MIN(height, [UIFont systemFontOfSize:14].lineHeight * 3));
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        
        self.contentLabel.sd_layout.topSpaceToView(self.contentView,19.5).leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15);
        self.icon.sd_layout.leftSpaceToView(self.contentView,15).bottomSpaceToView(self.contentView,20.5).heightIs(13).widthIs(13);
        self.timeLabel.sd_layout.rightSpaceToView(self.contentView,15).bottomSpaceToView(self.contentView,21.5).heightIs(10);
        self.titleLabel.sd_layout.leftSpaceToView(self.icon,9).bottomSpaceToView(self.contentView,20.5).rightSpaceToView(self.timeLabel,9).heightIs(13);
    }
    return self;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel labelWithTextColor:DefaultTitleAColor size:14];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.image = LoadImage(@"myNoteIcoPen");
    }
    return _icon;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:COLOR(168, 178, 202) size:13];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithTextColor:COLOR(183, 183, 183) size:10];
    }
    return _timeLabel;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (!self.isFirst) {
        //获得处理的上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        //设置线条样式
        CGContextSetLineCap(context, kCGLineCapSquare);
        //设置颜色
        CGContextSetRGBStrokeColor(context, 238 / 255.0, 238 / 255.0, 238 / 255.0, 1.0);
        //设置线条粗细宽度
        CGContextSetLineWidth(context, 0.5);
        //开始一个起始路径
        CGContextBeginPath(context);
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, 0, 0);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, kWidth ,0);
        //连接上面定义的坐标点
        CGContextStrokePath(context);
    }
}
@end
