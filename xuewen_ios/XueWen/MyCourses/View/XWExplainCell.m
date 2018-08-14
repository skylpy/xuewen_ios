//
//  XWExplainCell.m
//  XueWen
//
//  Created by aaron on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWExplainCell.h"
#import "XWMyPlanModel.h"

@interface XWExplainCell()

@property (nonatomic,strong) UILabel * studyNumLabel;
//学习
@property (nonatomic,strong) UILabel * studyLabel;

@property (nonatomic,strong) UILabel * examNumLabel;
//
@property (nonatomic,strong) UILabel * examLabel;

@property (nonatomic,strong) UILabel * recordNumLabel;
//
@property (nonatomic,strong) UILabel * recordLabel;

@property (nonatomic,strong) UIView * oneLineView;

@property (nonatomic,strong) UIView * twoLineView;

@property (nonatomic,strong) UIView * threeLineView;

@property (nonatomic,strong) UIButton * histronyButton;

@property (nonatomic,strong) UIButton * noteButton;

@property (nonatomic,strong) UIButton * testButton;
@end

@implementation XWExplainCell

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

- (void)setModel:(XWMyPlanModel *)model {
    _model = model;
    self.studyNumLabel.text = model.sumnotenum;
    self.examNumLabel.text = model.sumtestnum;
    self.recordNumLabel.text = model.sumviewnum;
}

- (void)drawUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.studyNumLabel];
    [self addSubview:self.studyLabel];
    [self addSubview:self.examNumLabel];
    [self addSubview:self.examLabel];
    [self addSubview:self.recordNumLabel];
    [self addSubview:self.recordLabel];
    [self addSubview:self.oneLineView];
    [self addSubview:self.twoLineView];
    [self addSubview:self.histronyButton];
    [self addSubview:self.testButton];
    [self addSubview:self.noteButton];
    
    [self.studyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.offset(16);
    }];
    
    [self.studyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.studyNumLabel.mas_bottom).offset(10);
        make.height.offset(16);
    }];
    
    [self.examNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.studyNumLabel.mas_right).offset(1);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.offset(16);
    }];
    
    [self.examLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.studyLabel.mas_right).offset(1);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.studyNumLabel.mas_bottom).offset(10);
        make.height.offset(16);
    }];
    
    [self.recordNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.examNumLabel.mas_right).offset(1);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.offset(16);
    }];
    
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.examNumLabel.mas_right).offset(1);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.recordNumLabel.mas_bottom).offset(10);
        make.height.offset(16);
    }];
    
    [self.oneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.studyNumLabel.mas_top).offset(5);
        make.left.equalTo(self.studyNumLabel.mas_right);
        make.width.offset(0.5);
        make.height.offset(40);
    }];
    
    [self.twoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.examNumLabel.mas_top).offset(5);
        make.left.equalTo(self.examNumLabel.mas_right);
        make.width.offset(0.5);
        make.height.offset(40);
    }];
    
    [self.histronyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordNumLabel.mas_top);
        make.left.equalTo(self.recordNumLabel.mas_left);
        make.right.equalTo(self.recordNumLabel.mas_right);
        make.bottom.equalTo(self.recordLabel.mas_bottom);
    }];
    
    [self.noteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.studyNumLabel.mas_top);
        make.left.equalTo(self.studyNumLabel.mas_left);
        make.right.equalTo(self.studyNumLabel.mas_right);
        make.bottom.equalTo(self.studyLabel.mas_bottom);
    }];
    
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.examNumLabel.mas_top);
        make.left.equalTo(self.examNumLabel.mas_left);
        make.right.equalTo(self.examNumLabel.mas_right);
        make.bottom.equalTo(self.examLabel.mas_bottom);
    }];
}



- (UILabel *)studyNumLabel {
    
    if (!_studyNumLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:15] withColor:Color(@"#323232")];
        _studyNumLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _studyNumLabel;
}

- (UILabel *)studyLabel {
    
    if (!_studyLabel) {
        UILabel * label = [UILabel createALabelText:@"笔记" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#323232")];
        _studyLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _studyLabel;
}

- (UILabel *)examNumLabel {
    
    if (!_examNumLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:15] withColor:Color(@"#323232")];
        _examNumLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _examNumLabel;
}

- (UILabel *)examLabel {
    
    if (!_examLabel) {
        UILabel * label = [UILabel createALabelText:@"考试" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#323232")];
        _examLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _examLabel;
}

- (UILabel *)recordNumLabel {
    
    if (!_recordNumLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:15] withColor:Color(@"#323232")];
        label.textAlignment = NSTextAlignmentCenter;
        _recordNumLabel = label;
    }
    return _recordNumLabel;
}

- (UILabel *)recordLabel {
    
    if (!_recordLabel) {
        UILabel * label = [UILabel createALabelText:@"历史记录" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#323232")];
        label.textAlignment = NSTextAlignmentCenter;
        _recordLabel = label;
    }
    return _recordLabel;
}

- (UIView *)oneLineView {
    
    if (!_oneLineView) {
        UIView * lineView = [UIView new];
        _oneLineView = lineView;
        lineView.backgroundColor = Color(@"#CCCCCC");
    }
    return _oneLineView;
}

- (UIView *)twoLineView {
    
    if (!_twoLineView) {
        UIView * lineView = [UIView new];
        _twoLineView = lineView;
        lineView.backgroundColor = Color(@"#CCCCCC");
    }
    return _twoLineView;
}

- (UIView *)threeLineView {
    
    if (!_threeLineView) {
        UIView * lineView = [UIView new];
        _threeLineView = lineView;
        lineView.backgroundColor = Color(@"#CCCCCC");
    }
    return _threeLineView;
}

- (UIButton *)histronyButton {
    
    if (!_histronyButton) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        _histronyButton = button;
        button.backgroundColor = [UIColor clearColor];
        
        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            !self.histroyClick?:self.histroyClick();
        }];
    }
    return _histronyButton;
}

- (UIButton *)testButton {
    
    if (!_testButton) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        _testButton = button;
        button.backgroundColor = [UIColor clearColor];
        
        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            !self.testClick?:self.testClick();
        }];
    }
    return _testButton;
}

- (UIButton *)noteButton {
    
    if (!_noteButton) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        _noteButton = button;
        button.backgroundColor = [UIColor clearColor];
        
        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            !self.noteClick?:self.noteClick();
        }];
    }
    return _noteButton;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
