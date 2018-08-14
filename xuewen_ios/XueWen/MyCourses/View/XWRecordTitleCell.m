//
//  XWRecordTitleCell.m
//  XueWen
//
//  Created by aaron on 2018/7/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRecordTitleCell.h"

@interface XWRecordTitleCell()

@property (nonatomic,strong) UILabel * timeLabel;

@property (nonatomic,strong) UILabel * titleLabel;

@end

@implementation XWRecordTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawUI];
    }
    return self;
}

- (void)setModel:(CourseModel *)model {
    _model = model;
    
    self.titleLabel.text = model.courseName;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 学了",[NSDate dateFormTimestamp:[NSString stringWithFormat:@"%@",model.learningTime] withFormat:@"hh:mm"]];
}

- (void)drawUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.timeLabel];
    [self addSubview:self.titleLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.offset(16);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.offset(18);
    }];
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        UILabel * label = [UILabel createALabelText:@"08:58 学了" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#999999")];
        _timeLabel = label;

    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        UILabel * label = [UILabel createALabelText:@"课程标题课程标题课程标题课程标题" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"##343434")];
        _titleLabel = label;

    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
