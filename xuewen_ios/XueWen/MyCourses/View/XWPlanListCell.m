//
//  XWPlanListCell.m
//  XueWen
//
//  Created by aaron on 2018/7/29.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWPlanListCell.h"
#import "XWNProgressView.h"

@interface XWPlanListCell()
@property (nonatomic,strong) UILabel * planNameLabel;
@property (nonatomic,strong) XWNProgressView * progress;
@property (nonatomic,strong) UILabel * planNumLabel;
@property (nonatomic,strong) UILabel * planCycleLabel;
@property (nonatomic,strong) UILabel * courseNumLabel;
@property (nonatomic,strong) UILabel * courseLabel;
@property (nonatomic,strong) UILabel * finishNumLabel;
@property (nonatomic,strong) UILabel * finishLabel;

@property (nonatomic,strong) UILabel * stateLabel;

@end

@implementation XWPlanListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawUI];
    }
    return self;
}

- (void)setModel:(LearningPlanModel *)model {
    
    _model = model;
    self.planNameLabel.text = model.palnTitle;
    self.progress.percent = [model.schedule floatValue]/100;
    self.courseNumLabel.text = model.courseCount;
    self.planNumLabel.text = model.planningCycle;
    self.finishNumLabel.text = model.completeCourse;
}

- (void)drawUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.planNameLabel];
    [self addSubview:self.progress];
    [self addSubview:self.planNumLabel];
    [self addSubview:self.planCycleLabel];
    [self addSubview:self.courseNumLabel];
    [self addSubview:self.courseLabel];
    [self addSubview:self.finishNumLabel];
    [self addSubview:self.finishLabel];
    [self addSubview:self.stateLabel];
    
    [self.planNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.mas_top).offset(25);
        make.height.offset(18);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(25);
        make.height.offset(16);
        make.width.offset(60);
    }];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.planNameLabel.mas_bottom).offset(25);
        make.height.width.offset(81);
    }];
    
    [self.planNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(115);
        make.top.equalTo(self.progress.mas_top).offset(15);
        make.width.offset((kWidth-130)/3);
        make.height.offset(18);
    }];
    
    [self.planCycleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(115);
        make.bottom.equalTo(self.progress.mas_bottom).offset(-15);
        make.width.offset((kWidth-130)/3);
        make.height.offset(18);
    }];
    
    [self.courseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.planNumLabel.mas_right);
        make.top.equalTo(self.progress.mas_top).offset(15);
        make.width.offset((kWidth-130)/3);
        make.height.offset(18);
    }];
    
    [self.courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.planCycleLabel.mas_right);
        make.bottom.equalTo(self.progress.mas_bottom).offset(-15);
        make.width.offset((kWidth-130)/3);
        make.height.offset(18);
    }];
    
    [self.finishNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.courseNumLabel.mas_right);
        make.top.equalTo(self.progress.mas_top).offset(15);
        make.width.offset((kWidth-130)/3);
        make.height.offset(18);
    }];
    
    [self.finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.courseLabel.mas_right);
        make.bottom.equalTo(self.progress.mas_bottom).offset(-15);
        make.width.offset((kWidth-130)/3);
        make.height.offset(18);
    }];
}
- (UILabel *)stateLabel {
    
    if (!_stateLabel) {
        UILabel * label = [UILabel createALabelText:@"查看详情" withFont:[UIFont fontWithName:kRegFont size:11] withColor:Color(@"#323232")];
        _stateLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderWidth = 0.5;
        label.layer.cornerRadius = 2;
        label.clipsToBounds = YES;
        label.layer.borderColor = Color(@"#C4C4C4").CGColor;
    }
    return _stateLabel;
}

- (UILabel *)planNameLabel {
    
    if (!_planNameLabel) {
        UILabel * label = [UILabel createALabelText:@"计划名称" withFont:[UIFont fontWithName:kMedFont size:14] withColor:Color(@"#323232")];
        _planNameLabel = label;
    }
    return _planNameLabel;
}

- (XWNProgressView*)progress {
    
    if (!_progress) {
        XWNProgressView *progress = [[XWNProgressView alloc] initWithFrame:CGRectZero];
        self.progress = progress;
        progress.arcFinishColor = Color(@"#3699FF");
        
        progress.arcUnfinishColor = Color(@"#3699FF");
        progress.arcTitleColor = Color(@"#3699FF");
        progress.arcBackColor = Color(@"#EAEAEA");
        progress.width = 4;
        progress.percent = 0.8;
        
        progress.fontSize = 20;
    }
    return _progress;
}

- (UILabel *)planNumLabel {
    
    if (!_planNumLabel) {
        UILabel * label = [UILabel createALabelText:@"8" withFont:[UIFont fontWithName:kMedFont size:14] withColor:Color(@"#323232")];
        _planNumLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _planNumLabel;
}

- (UILabel *)planCycleLabel {
    
    if (!_planCycleLabel) {
        UILabel * label = [UILabel createALabelText:@"计划周期" withFont:[UIFont fontWithName:kMedFont size:13] withColor:Color(@"#323232")];
        _planCycleLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _planCycleLabel;
}

- (UILabel *)courseNumLabel {
    
    if (!_courseNumLabel) {
        UILabel * label = [UILabel createALabelText:@"8" withFont:[UIFont fontWithName:kMedFont size:13] withColor:Color(@"#323232")];
        _courseNumLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _courseNumLabel;
}

- (UILabel *)courseLabel {
    
    if (!_courseLabel) {
        UILabel * label = [UILabel createALabelText:@"课程数" withFont:[UIFont fontWithName:kMedFont size:13] withColor:Color(@"#323232")];
        _courseLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _courseLabel;
}

- (UILabel *)finishNumLabel {
    
    if (!_finishNumLabel) {
        UILabel * label = [UILabel createALabelText:@"8" withFont:[UIFont fontWithName:kMedFont size:13] withColor:Color(@"#323232")];
        _finishNumLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _finishNumLabel;
}

- (UILabel *)finishLabel {
    
    if (!_finishLabel) {
        UILabel * label = [UILabel createALabelText:@"完成课程" withFont:[UIFont fontWithName:kMedFont size:13] withColor:Color(@"#323232")];
        _finishLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _finishLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end

#pragma XWNoneTableCell

@interface XWNoneTableCell()

@property (nonatomic,strong) UIImageView * iconImage;
@property (nonatomic,strong) UILabel * titleLabel;

@end

@implementation XWNoneTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.iconImage];
        [self addSubview:self.titleLabel];
        
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(51);
            make.centerX.equalTo(self);
            make.width.height.offset(52);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImage.mas_bottom).offset(25);
            make.centerX.equalTo(self);
            make.height.offset(20);
        }];
    }
    return self;
}

- (UIImageView *)iconImage {
    
    if (!_iconImage) {
        UIImageView * icon = [UIImageView new];
        _iconImage = icon;
        icon.image = [UIImage imageNamed:@"nonepage"];
    }
    return _iconImage;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel createALabelText:@"暂无相关计划:)" withFont:[UIFont fontWithName:kMedFont size:13] withColor:Color(@"#DDDDDD")];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleLabel;
}

@end
