//
//  XWCoursesHeaderCell.m
//  XueWen
//
//  Created by aaron on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCoursesHeaderCell.h"
#import "NSMutableAttributedString+XWUtil.h"
#import "XWMyPlanModel.h"

@interface XWCoursesHeaderCell()

//总时长
@property (nonatomic,strong) UILabel * allTimeLabel;
//昵称
@property (nonatomic,strong) UILabel * nickLabel;
//今日学习时间
@property (nonatomic,strong) UILabel * toTimeLabel;
//今日学习
@property (nonatomic,strong) UILabel * toDayLabel;
//今日考试次数
@property (nonatomic,strong) UILabel * toNumLabel;
//今日考试
@property (nonatomic,strong) UILabel * toExamLabel;

@property (nonatomic,strong) UIView * lineView;

@end

@implementation XWCoursesHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawUI];
    }
    return self;
}

- (void)setModel:(XWMyPlanModel *)model {
    _model = model;
//
    self.allTimeLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"总学习时长 %@ 小时",model.sumlearningtime] rangeText:model.sumlearningtime textFont:[UIFont fontWithName:kMedFont size:19] textColor:Color(@"#F1A218")];
    self.toTimeLabel.text = [NSString stringWithFormat:@"%@分钟",model.todaylearningtime];
    self.toNumLabel.text = [NSString stringWithFormat:@"%@次",model.todaytestnum];
    self.nickLabel.text = [XWInstance shareInstance].userInfo.nick_name;
}

- (void)drawUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.allTimeLabel];
    [self addSubview:self.nickLabel];
    [self addSubview:self.toTimeLabel];
    [self addSubview:self.toDayLabel];
    [self addSubview:self.toNumLabel];
    [self addSubview:self.toExamLabel];
    [self addSubview:self.lineView];
    
    [self.allTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(25);
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(25);
        make.height.offset(16);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allTimeLabel.mas_bottom).offset(25);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.offset(16);
    }];
    
    [self.toTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nickLabel.mas_bottom).offset(40);
        make.left.equalTo(self.mas_left);
        make.width.offset(kWidth/2-1);
        make.height.offset(16);
    }];
    
    [self.toDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.toTimeLabel.mas_bottom).offset(3);
        make.left.equalTo(self.mas_left);
        make.width.offset(kWidth/2-1);
        make.height.offset(16);
    }];
    
    [self.toNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.toTimeLabel);
        make.left.equalTo(self.toTimeLabel.mas_right).offset(2);
        make.width.offset(kWidth/2-1);
        make.height.offset(16);
    }];
    
    [self.toExamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.toDayLabel);
        make.left.equalTo(self.toDayLabel.mas_right).offset(2);
        make.width.offset(kWidth/2-1);
        make.height.offset(16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.toTimeLabel.mas_top);
        make.centerX.equalTo(self);
        make.width.offset(1);
        make.height.offset(32);
    }];
}

- (UILabel *)allTimeLabel {
    
    if (!_allTimeLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#323232")];
        _allTimeLabel = label;
    }
    return _allTimeLabel;
}

- (UILabel *)nickLabel {
    
    if (!_nickLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:15] withColor:Color(@"#323232")];
        _nickLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _nickLabel;
}


- (UILabel *)toTimeLabel {
    
    if (!_toTimeLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#323232")];
        _toTimeLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _toTimeLabel;
}

- (UILabel *)toDayLabel {
    
    if (!_toDayLabel) {
        UILabel * label = [UILabel createALabelText:@"今日学习" withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#323232")];
        _toDayLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _toDayLabel;
}


- (UILabel *)toNumLabel {
    
    if (!_toNumLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#323232")];
        _toNumLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _toNumLabel;
}

- (UILabel *)toExamLabel {
    
    if (!_toExamLabel) {
        UILabel * label = [UILabel createALabelText:@"今日考试" withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#323232")];
        _toExamLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _toExamLabel;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        UIView * lineView = [UIView new];
        _lineView = lineView;
        lineView.backgroundColor = Color(@"#CCCCCC");
    }
    return _lineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
