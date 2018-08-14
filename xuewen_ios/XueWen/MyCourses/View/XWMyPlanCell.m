//
//  XWMyPlanCell.m
//  XueWen
//
//  Created by aaron on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWMyPlanCell.h"
#import "PiechartView.h"
#import "XWNProgressView.h"

@interface XWMyPlanCell()

//我的计划
@property (nonatomic,strong) UILabel * myPlanLabel;

@property (nonatomic,strong) UILabel * nameLabel;

@property (nonatomic,strong) UILabel * timeLabel;

@property (nonatomic,strong) UILabel * oneCoursesLabel;

@property (nonatomic,strong) UILabel * onePercentLabel;

@property (nonatomic,strong) UILabel * twoCoursesLabel;

@property (nonatomic,strong) UILabel * twoPercentLabel;

@property (nonatomic,strong) UILabel * threeCoursesLabel;

@property (nonatomic,strong) UILabel * threePercentLabel;

//@property (strong,nonatomic) PiechartView *chartOne;

@property (nonatomic,strong) UIButton * moreButton;

@property (nonatomic,strong) XWNProgressView * progress;

@property (nonatomic,strong) UIView * maskView;

@end

@implementation XWMyPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(LearningPlanModel *)model {
    
    _model = model;
    [self.maskView removeFromSuperview];
    self.moreButton.hidden = NO;
    self.nameLabel.text = model.palnTitle;
    self.progress.percent = [model.schedule floatValue]/100;
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[NSDate dateFormTimestamp:model.startTime withFormat:@"yyyy.MM.dd"],[NSDate dateFormTimestamp:model.endTime withFormat:@"yyyy.MM.dd"]];
    for (int i = 0; i < model.scheduleInfo.count; i ++) {
        LearningPlanInfoModel * info = model.scheduleInfo[i];
        if (i == 0) {
            
            self.oneCoursesLabel.text = info.courseName;
            self.onePercentLabel.text = [NSString stringWithFormat:@"%@%%",info.progress];
        }else if (i == 1){
            
            self.twoCoursesLabel.text = info.courseName;
            self.twoPercentLabel.text = [NSString stringWithFormat:@"%@%%",info.progress];
        }else if (i == 2){
            
            self.threeCoursesLabel.text = info.courseName;
            self.threePercentLabel.text = [NSString stringWithFormat:@"%@%%",info.progress];
        }
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.myPlanLabel];
    [self addSubview:self.progress];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.oneCoursesLabel];
    [self addSubview:self.twoCoursesLabel];
    [self addSubview:self.threeCoursesLabel];
    [self addSubview:self.onePercentLabel];
    [self addSubview:self.twoPercentLabel];
    [self addSubview:self.threePercentLabel];
    
    [self addSubview:self.moreButton];
    
    [self.myPlanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.mas_top).offset(20);
        make.height.offset(16);
    }];

    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.myPlanLabel.mas_bottom).offset(35);
        make.height.width.offset(109);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.myPlanLabel);
        make.height.offset(16);
        make.width.offset(60);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.progress.mas_bottom).offset(35);
        make.height.offset(16);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.offset(16);
    }];
    
    [self.oneCoursesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(25);
        make.right.equalTo(self.mas_right).offset(-55);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.height.offset(16);
    }];
    
    [self.twoCoursesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(25);
        make.right.equalTo(self.mas_right).offset(-55);
        make.top.equalTo(self.oneCoursesLabel.mas_bottom).offset(5);
        make.height.offset(16);
    }];
    
    [self.threeCoursesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(25);
        make.right.equalTo(self.mas_right).offset(-55);
        make.top.equalTo(self.twoCoursesLabel.mas_bottom).offset(5);
        make.height.offset(16);
    }];
    
    [self.onePercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.oneCoursesLabel);
        make.right.equalTo(self.mas_right).offset(-25);
        make.height.offset(16);
    }];
    
    [self.twoPercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.twoCoursesLabel);
        make.right.equalTo(self.mas_right).offset(-25);
        make.height.offset(16);
    }];
    
    [self.threePercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.threeCoursesLabel);
        make.right.equalTo(self.mas_right).offset(-25);
        make.height.offset(16);
    }];
    
    //蔗罩
    [self addSubview:self.maskView];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.myPlanLabel.mas_bottom);
    }];
}

- (XWNProgressView*)progress {
    
    if (!_progress) {
        XWNProgressView *progress = [[XWNProgressView alloc] initWithFrame:CGRectZero];
        _progress = progress;
        progress.arcFinishColor = [UIColor lightGrayColor];//Color(@"#3699FF");
        
        progress.arcUnfinishColor = Color(@"#FFB016");
        progress.arcTitleColor = Color(@"#666666");
        progress.arcBackColor = [UIColor lightGrayColor];//Color(@"#EAEAEA");
        progress.width = 9;
        progress.percent = 0;
        
        progress.fontSize = 24;
    }
    return _progress;
}

- (UILabel *)myPlanLabel {
    
    if (!_myPlanLabel) {
        UILabel * label = [UILabel createALabelText:@"我的计划" withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#323232")];
        _myPlanLabel = label;
    }
    return _myPlanLabel;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        UILabel * label = [UILabel createALabelText:@"暂无计划" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#323232")];
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#999999")];
        _timeLabel = label;
    }
    return _timeLabel;
}

- (UILabel *)oneCoursesLabel {
    
    if (!_oneCoursesLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#333333")];
        _oneCoursesLabel = label;
        label.tag = 200;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couresClick:)];
        [label addGestureRecognizer:tap];
    }
    return _oneCoursesLabel;
}

- (void)couresClick:(UITapGestureRecognizer *)tap {
    NSLog(@"======");
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tap;
    NSInteger index = singleTap.view.tag;
    switch (index) {
        case 200:
        {
            if (self.model.scheduleInfo.count == 0) {
                return;
            }
            LearningPlanInfoModel * model = self.model.scheduleInfo[0];
            !self.couresDateilClick?:self.couresDateilClick(model.courseID);
        }
            break;
        case 201:
        {
            if (self.model.scheduleInfo.count == 1) {
                return;
            }
            LearningPlanInfoModel * model = self.model.scheduleInfo[1];
            !self.couresDateilClick?:self.couresDateilClick(model.courseID);
        }
            break;
        case 202:
        {
            if (self.model.scheduleInfo.count == 2) {
                return;
            }
            LearningPlanInfoModel * model = self.model.scheduleInfo[2];
            !self.couresDateilClick?:self.couresDateilClick(model.courseID);
        }
            break;
        default:
            break;
    }
}

- (UIView *)maskView {
    
    if (!_maskView) {
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        _maskView = view;
        
        UIImageView * noneImage = [UIImageView new];
        noneImage.image = [UIImage imageNamed:@"nonepage"];
        [view addSubview:noneImage];
        
        UILabel * titleLabel = [UILabel createALabelText:@"你还没有正在进行的计划哟" withFont:[UIFont fontWithName:kMedFont size:12] withColor:Color(@"#DDDDDD")];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleLabel];
        
        [noneImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(view.mas_top).offset(51);
            make.centerX.equalTo(view);
            make.width.height.offset(52);
            
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noneImage.mas_bottom).offset(25);
            make.centerX.equalTo(view);
            make.height.offset(20);
        }];
    }
    return _maskView;
}

- (UILabel *)twoCoursesLabel {
    
    if (!_twoCoursesLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#333333")];
        _twoCoursesLabel = label;
        label.tag = 201;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couresClick:)];
        [label addGestureRecognizer:tap];
    }
    return _twoCoursesLabel;
}

- (UILabel *)threeCoursesLabel {
    
    if (!_threeCoursesLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#333333")];
        _threeCoursesLabel = label;
        label.tag = 202;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couresClick:)];
        [label addGestureRecognizer:tap];
    }
    return _threeCoursesLabel;
}

- (UILabel *)onePercentLabel {
    
    if (!_onePercentLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#333333")];
        _onePercentLabel = label;
    }
    return _onePercentLabel;
}

- (UILabel *)twoPercentLabel {
    
    if (!_twoPercentLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#333333")];
        _twoPercentLabel = label;
    }
    return _twoPercentLabel;
}

- (UILabel *)threePercentLabel {
    
    if (!_threePercentLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#333333")];
        _threePercentLabel = label;
    }
    return _threePercentLabel;
}

- (UIButton *)moreButton {
    
    if (!_moreButton) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton = button;
        button.hidden = YES;
        [button setTitle:@"更多" forState:UIControlStateNormal];
        [button setTitleColor:Color(@"#999999") forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [button setImage:[UIImage imageNamed:@"right_copy"] forState:UIControlStateNormal];
        // 重点位置开始
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, button.currentImage.size.width)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -button.titleLabel.bounds.size.width)];

        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            !self.moreMyPlanClick?:self.moreMyPlanClick();
        }];
    }
    return _moreButton;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
