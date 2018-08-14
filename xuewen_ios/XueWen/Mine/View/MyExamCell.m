//
//  MyExamCell.m
//  XueWen
//
//  Created by ShaJin on 2017/12/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyExamCell.h"
#import "ExamModel.h"
@interface MyExamCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *scoreLabel;

@end
@implementation MyExamCell

- (void)setModel:(ExamModel *)model{
    _model = model;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld分",(long)model.score];
    self.scoreLabel.sd_layout.widthIs([self.scoreLabel.text widthWithSize:14]);
    self.scoreLabel.textColor = (model.score >= 60) ? COLOR(14, 201, 80) : COLOR(251, 27, 27);
    
    self.titleLabel.text = model.testName;
    self.timeLabel.text = model.creatTime;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.scoreLabel];

        self.scoreLabel.sd_layout.topSpaceToView(self.contentView,19.5).rightSpaceToView(self.contentView,15).heightIs(15);
        self.titleLabel.sd_layout.topSpaceToView(self.contentView,19.5).leftSpaceToView(self.contentView,15).rightSpaceToView(self.scoreLabel,15).heightIs(15);
        self.timeLabel.sd_layout.topSpaceToView(self.titleLabel,10).leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).heightIs(10);
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = kFontSize(14);
        _titleLabel.textColor = DefaultTitleAColor;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = kFontSize(10);
        _timeLabel.textColor = COLOR(183, 183, 183);
    }
    return _timeLabel;
}

- (UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [UILabel new];
        _scoreLabel.font = kFontSize(14);
    }
    return _scoreLabel;
}
@end
