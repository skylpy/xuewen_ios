//
//  XWTitleDateilCell.m
//  XueWen
//
//  Created by aaron on 2018/7/24.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWTitleDateilCell.h"

@interface XWTitleDateilCell()

@property (nonatomic,strong) UILabel * titleLabel;

@property (nonatomic,strong) UIImageView * timeImage;
@property (nonatomic,strong) UILabel * timeLabel;

@property (nonatomic,strong) UIImageView * presonImage;
@property (nonatomic,strong) UILabel * presonLabel;

@property (nonatomic,strong) UIButton * examButton;

@end

@implementation XWTitleDateilCell

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        UILabel * titlelabel = [UILabel new];
        _titleLabel = titlelabel;
        titlelabel.text = @"这是一个课程标题这是一个课程标题这是一个课程标";
        titlelabel.textColor = Color(@"#333333");
        titlelabel.font = [UIFont fontWithName:kRegFont size:15];
        
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        UILabel * timeLabel = [UILabel new];
        _timeLabel = timeLabel;
        timeLabel.text = @"10课时";
        timeLabel.textColor = Color(@"#999999");
        timeLabel.font = [UIFont fontWithName:kRegFont size:11];
        
    }
    return _timeLabel;
}

- (UILabel *)presonLabel {
    
    if (!_presonLabel) {
        UILabel * presonLabel = [UILabel new];
        _presonLabel = presonLabel;
        presonLabel.text = @"535人学习";
        presonLabel.textColor = Color(@"#999999");
        presonLabel.font = [UIFont fontWithName:kRegFont size:11];
        
    }
    return _presonLabel;
}

#pragma mark - Custom Methods
- (void)testBtnClick{
    [XWTitleDateilCell postNotificationWithName:NotiExamAction];
}

- (UIImageView *)timeImage {
    
    if (!_timeImage) {
        UIImageView * timeImage = [UIImageView new];
        timeImage.image = [UIImage imageNamed:@"ico_class_hour"];
        _timeImage = timeImage;
        
    }
    return _timeImage;
}

- (UIImageView *)presonImage {
    
    if (!_presonImage) {
        UIImageView * presonImage = [UIImageView new];
        presonImage.image = [UIImage imageNamed:@"ico_member"];
        _presonImage = presonImage;
        
    }
    return _presonImage;
}

- (UIButton *)examButton {
    
    if (!_examButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        _examButton = button;
        button.backgroundColor = Color(@"#476EFF");
        [button setTitle:@"考试" forState:UIControlStateNormal];
        [button setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:kRegFont size:12];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 12;
        button.hidden = YES;
        [button addTarget:self action:@selector(testBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _examButton;
}

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

- (void)drawUI {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeImage];
    [self addSubview:self.timeLabel];
    [self addSubview:self.presonImage];
    [self addSubview:self.presonLabel];
    [self addSubview:self.examButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        
    }];
    
    [self.timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.height.offset(11);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.timeImage);
        make.left.equalTo(self.timeImage.mas_right).offset(5);
    }];
    
    [self.presonImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.left.equalTo(self.timeLabel.mas_right).offset(25);
        make.width.height.offset(11);
    }];
    
    [self.presonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeImage);
        make.left.equalTo(self.presonImage.mas_right).offset(5);
    }];
    
    [self.examButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeImage);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.offset(55);
        make.height.offset(24);
    }];
    
}

#pragma mark - Setter
- (void)setModel:(XWCoursModel *)model{
    _model = model;
    if (![_model.testid isEqualToString:@"0"]) {
        self.examButton.hidden = NO;
    }else{
        self.examButton.hidden = YES;
    }
    self.titleLabel.text = _model.courseName;
    self.presonLabel.text = [NSString stringWithFormat:@"%@人学习",_model.total];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
