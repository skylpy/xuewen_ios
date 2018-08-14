//
//  XWStudyHeaderView.m
//  XueWen
//
//  Created by Karron Su on 2018/7/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWStudyHeaderView.h"

@interface XWStudyHeaderView ()

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *bmLabel;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *zanImgView;
@property (nonatomic, strong) UILabel *zanLabel;
@property (nonatomic, strong) UIButton *zanBtn;

@end

@implementation XWStudyHeaderView

#pragma mark - Getter
- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image = DefaultImage;
        [_headImgView rounded:67/2];
    }
    return _headImgView;
}

- (UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
//        _nickLabel.text = @"刘德华";
        _nickLabel.textColor = [UIColor whiteColor];
        _nickLabel.font = [UIFont fontWithName:kMedFont size:14];
    }
    return _nickLabel;
}

- (UILabel *)bmLabel{
    if (!_bmLabel) {
        _bmLabel = [[UILabel alloc] init];
        _bmLabel.textColor = [UIColor whiteColor];
//        _bmLabel.text = @"业务部";
        _bmLabel.font = [UIFont fontWithName:kMedFont size:10];
        _bmLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bmLabel;
}

- (UILabel *)rankLabel{
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = [UIColor whiteColor];
//        _rankLabel.text = @"本周排名：11";
        _rankLabel.font = [UIFont fontWithName:kMedFont size:10];
        _rankLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rankLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
//        _timeLabel.text = @"学习时长：88分钟";
        _timeLabel.font = [UIFont fontWithName:kMedFont size:11];
    }
    return _timeLabel;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = Color(@"#3399FF");
    }
    return _bgView;
}

- (UILabel *)zanLabel{
    if (!_zanLabel) {
        _zanLabel = [[UILabel alloc] init];
//        _zanLabel.text = @"50";
        _zanLabel.textColor = Color(@"#FEFEFE");
        _zanLabel.font = [UIFont fontWithName:kRegFont size:12];
    }
    return _zanLabel;
}

- (UIImageView *)zanImgView{
    if (!_zanImgView) {
        _zanImgView = [[UIImageView alloc] initWithImage:LoadImage(@"icon_dianzan")];
    }
    return _zanImgView;
}

- (UIButton *)zanBtn{
    if (!_zanBtn) {
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        @weakify(self)
        [[_zanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            NSString *userId = [[NSString alloc] init];
            NSString *fabulous = [[NSString alloc] init];
            if (self.rankModel == nil && self.goalModel != nil) { // 目标排名
                userId = self.goalModel.userId;
                fabulous = @"1";
            }else if (self.rankModel != nil && self.goalModel == nil){ // 学习排名
                userId = [XWInstance shareInstance].userInfo.oid;
                fabulous = @"2";
            }
            [self fabulousClickWith:userId fabulous:fabulous];
        }];
    }
    return _zanBtn;
}

#pragma mark - Setter
- (void)setRankModel:(XWCountPlayTimeModel *)rankModel{
    _rankModel = rankModel;
    if (_rankModel.departmentName == nil) {
        _rankModel.departmentName = @"默认部门";
    }
    self.nickLabel.text = _rankModel.name;
    self.bmLabel.text = _rankModel.departmentName;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_rankModel.coverPictureAll] placeholderImage:DefaultImage];
    self.zanLabel.text = _rankModel.praise;
    if ([_rankModel.fabulousType isEqualToString:@"1"]) { // 已点赞
        self.zanImgView.image = LoadImage(@"icon_dianzan");
    }else{
        self.zanImgView.image = LoadImage(@"icon_zan");
    }
    if (_rankModel.totalTime == nil) {
        _rankModel.totalTime = @"0";
    }
    if (_rankModel.ranking == nil) {
        _rankModel.ranking = @"0";
    }
    self.rankLabel.text = [NSString stringWithFormat:@"本周排名: %@", _rankModel.ranking];
    self.timeLabel.text = [NSString stringWithFormat:@"学习时长: %@分钟", _rankModel.totalTime];
    NSRange range1 = [self.timeLabel.text rangeOfString:_rankModel.totalTime];
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:self.timeLabel.text];
    [attr1 addAttribute:NSForegroundColorAttributeName value:Color(@"#FFCC00") range:range1];
    [attr1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kMedFont size:10] range:range1];
    self.timeLabel.attributedText = attr1;
    
    NSRange range2 = [self.rankLabel.text rangeOfString:_rankModel.ranking];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:self.rankLabel.text];
    [attr2 addAttribute:NSForegroundColorAttributeName value:Color(@"#FFCC00") range:range2];
    [attr2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kMedFont size:16] range:range2];
    self.rankLabel.attributedText = attr2;
    
    
}

- (void)setGoalModel:(XWTargetRankModel *)goalModel{
    _goalModel = goalModel;
    self.nickLabel.text = _goalModel.name;
    if (_goalModel.count == nil) {
        _goalModel.count = @"0";
    }
    if (_goalModel.completion == nil) {
        _goalModel.completion = @"0";
    }
    if (_goalModel.ranking == nil) {
        _goalModel.ranking = @"0";
    }
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_goalModel.pictureAll] placeholderImage:DefaultImage];
    self.bmLabel.text = [NSString stringWithFormat:@"完成计划：%@", _goalModel.count];
    self.timeLabel.text = [NSString stringWithFormat:@"达成率：%@%%", _goalModel.completion];
    self.rankLabel.text = [NSString stringWithFormat:@"本周排名：%@", _goalModel.ranking];
    self.zanLabel.text = _goalModel.fabulous;
    if ([_goalModel.fabulousType isEqualToString:@"1"]) { // 已点赞
        self.zanImgView.image = LoadImage(@"icon_dianzan");
    }else{
        self.zanImgView.image = LoadImage(@"icon_zan");
    }
    
    
    NSRange range1 = [self.bmLabel.text rangeOfString:_goalModel.count];
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:self.bmLabel.text];
    [attr1 addAttribute:NSForegroundColorAttributeName value:Color(@"#FFCC00") range:range1];
    [attr1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kMedFont size:10] range:range1];
    self.bmLabel.attributedText = attr1;
    
    NSRange range2 = [self.timeLabel.text rangeOfString:[NSString stringWithFormat:@"%@%%", _goalModel.completion]];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:self.timeLabel.text];
    [attr2 addAttribute:NSForegroundColorAttributeName value:Color(@"#FDA61D") range:range2];
    [attr2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kMedFont size:10] range:range2];
    self.timeLabel.attributedText = attr2;
    
    NSRange range3 = [self.rankLabel.text rangeOfString:_goalModel.ranking];
    NSMutableAttributedString *attr3 = [[NSMutableAttributedString alloc] initWithString:self.rankLabel.text];
    [attr3 addAttribute:NSForegroundColorAttributeName value:Color(@"#FDA61D") range:range3];
    [attr3 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kMedFont size:16] range:range3];
    self.rankLabel.attributedText = attr3;
}

#pragma mark - Custom Action
- (void)fabulousClickWith:(NSString *)userId fabulous:(NSString *)fabulous{
    
    [XWHttpTool postFabulousWithUserID:userId fabulous:fabulous success:^{
        [MBProgressHUD showTipMessageInWindow:@"点赞成功"];
        self.zanImgView.image = LoadImage(@"icon_dianzan");
        if (self.rankModel == nil && self.goalModel != nil) { // 目标排名
            NSInteger count = [self.goalModel.fabulous integerValue];
            self.zanLabel.text = [NSString stringWithFormat:@"%ld", count+1];
        }else if (self.rankModel != nil && self.goalModel == nil){ // 学习排名
            NSInteger count = [self.rankModel.praise integerValue];
            self.zanLabel.text = [NSString stringWithFormat:@"%ld", count+1];
        }
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showTipMessageInWindow:errorInfo];
    }];
}

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    
    self.backgroundColor = Color(@"#ffffff");
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.headImgView];
    [self.bgView addSubview:self.nickLabel];
    [self.bgView addSubview:self.bmLabel];
    [self.bgView addSubview:self.rankLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.zanImgView];
    [self.bgView addSubview:self.zanLabel];
    [self.bgView addSubview:self.zanBtn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.top.mas_equalTo(7);
    }];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(25);
        make.centerY.mas_equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(67, 67));
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImgView.mas_right).offset(16);
        make.top.mas_equalTo(self.bgView).offset(20);
    }];
    
    [self.bmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView).offset(-90);
        make.top.mas_equalTo(self.bgView).offset(25);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImgView.mas_right).offset(16);
        make.bottom.mas_equalTo(self.bgView).offset(-18);
    }];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bmLabel.mas_left);
        make.bottom.mas_equalTo(self.timeLabel.mas_bottom);
    }];
    
    [self.zanImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 16));
        make.top.mas_equalTo(self.bgView).offset(26);
        make.right.mas_equalTo(self.bgView).offset(-25);
    }];
    
    [self.zanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.zanImgView);
        make.top.mas_equalTo(self.zanImgView.mas_bottom).offset(6);
    }];
    
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.zanImgView);
        make.right.mas_equalTo(self.zanImgView);
        make.top.mas_equalTo(self.zanImgView);
        make.bottom.mas_equalTo(self.zanLabel);
    }];
    
}

@end
