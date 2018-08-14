//
//  XWPlanDateilCell.m
//  XueWen
//
//  Created by aaron on 2018/7/29.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWPlanDateilCell.h"
#import "LXCalender.h"
#import "XWNProgressView.h"
#import "CAShapeLayer+XWLayer.h"

@interface XWPlanDateilCell()

@property (nonatomic,strong) UILabel * planLabel;
@property(nonatomic,strong)LXCalendarView *calenderView;

@end

@implementation XWPlanDateilCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(LearningPlanModel *)model {
    
    _model = model;
    
    self.calenderView.endDay = model.endTime;
    self.calenderView.startDay = model.startTime;
    
    [self.calenderView dealData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.planLabel];
    
    [self.planLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.mas_top).offset(25);
        make.height.offset(16);
    }];
    
    self.calenderView =[[LXCalendarView alloc] initWithFrame:CGRectMake(20, 40, kWidth - 40, 0)];
    
    self.calenderView.currentMonthTitleColor =Color(@"#2c2c2c");
    self.calenderView.lastMonthTitleColor =Color(@"#8a8a8a");
    self.calenderView.nextMonthTitleColor =Color(@"#8a8a8a");
    
    self.calenderView.isHaveAnimation = YES;
    
    self.calenderView.isCanScroll = YES;
    
    self.calenderView.isShowLastAndNextBtn = YES;
    
    self.calenderView.isShowLastAndNextDate = NO;
    
    self.calenderView.todayTitleColor =[UIColor whiteColor];
    
    self.calenderView.selectBackColor =[UIColor blueColor];
    
    self.calenderView.backgroundColor =[UIColor whiteColor];
    
    
//    [self.calenderView dealData];
    
    [self addSubview:self.calenderView];
    
    
    
    self.calenderView.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day) {
        NSLog(@"%ld年 - %ld月 - %ld日",year,month,day);
    };
}

- (UILabel *)planLabel {
    
    if (!_planLabel) {
        UILabel * label = [UILabel createALabelText:@"计划周期" withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#323232")];
        _planLabel = label;
    }
    return _planLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end

@interface XWPlanProgressCell ()

@property (strong,nonatomic) UIImageView * headImageView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * dateLabel;
@property (nonatomic,strong) UILabel * learnedLabel;
@property (nonatomic,strong) XWNProgressView *progress;
@end

@implementation XWPlanProgressCell

- (void)setModel:(LearningPlanInfoModel *)model {
    _model = model;
    
    self.progress.percent = [model.progress floatValue]/100;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.coverPhotoAll] placeholderImage:DefaultImage];
    self.titleLabel.text = model.courseName;
    self.nameLabel.text = model.tchOrg;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawUI];
        
    }
    return self;
}

- (void)drawUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.progress];
    [self addSubview:self.headImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.dateLabel];
    
    [self addSubview:self.learnedLabel];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.centerY.equalTo(self).offset(-10);
        make.width.height.offset(38);
        
    }];

    [self.learnedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progress);
        make.top.equalTo(self.progress.mas_bottom).offset(3);
        
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.offset(100);
        make.height.offset(62);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(25);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.progress.mas_left).offset(-15);
        make.height.offset(18);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(25);
        make.bottom.equalTo(self.headImageView.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-60);
        make.height.offset(18);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.headImageView.mas_bottom);
        make.right.equalTo(self.progress.mas_left).offset(-15);
        make.height.offset(18);
    }];
    
}

- (XWNProgressView*)progress {
    
    if (!_progress) {
        XWNProgressView *progress = [[XWNProgressView alloc] initWithFrame:CGRectZero];
        self.progress = progress;
        progress.arcFinishColor = Color(@"#3699FF");
        
        progress.arcUnfinishColor = Color(@"#3699FF");
        progress.arcTitleColor = Color(@"#3699FF");
        progress.arcBackColor = Color(@"#EAEAEA");
        progress.width = 2;
        progress.percent = 0.8;
        
        progress.fontSize = 11;
    }
    return _progress;
}

- (UIImageView *)headImageView {
    
    if (!_headImageView) {
        UIImageView * imageView = [UIImageView new];
        _headImageView = imageView;
        imageView.layer.cornerRadius = 3;
        imageView.clipsToBounds = YES;
        
    }
    return _headImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        UILabel * label = [UILabel createALabelText:@"这是一条课程标题这是一条....." withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#333333")];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        UILabel * label = [UILabel createALabelText:@"王小明" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#333333")];
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:11] withColor:Color(@"#999999")];
        _dateLabel = label;
    }
    return _dateLabel;
}

- (UILabel *)learnedLabel {
    
    if (!_learnedLabel) {
        UILabel * label = [UILabel createALabelText:@"已学" withFont:[UIFont fontWithName:kRegFont size:11] withColor:Color(@"#3699FF")];
        _learnedLabel = label;
    }
    return _learnedLabel;
}


@end
