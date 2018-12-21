//
//  XWStudyRankCell.m
//  XueWen
//
//  Created by Karron Su on 2018/7/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWStudyRankCell.h"

@interface XWStudyRankCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zanImgView;
@property (weak, nonatomic) IBOutlet UILabel *zanCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeTagLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rLayoutConstraint;


@end

@implementation XWStudyRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImgView rounded:22.5];
    self.lineView.backgroundColor = Color(@"#EBEAEA");
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = Color(@"#7EBDFF");
}

#pragma mark - Setter
- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    self.lineView.hidden = _isLast;
}

- (void)setModel:(XWCountPlayTimeModel *)model{
    _model = model;
    UIImage *defaultImg = [[UIImage alloc] init];
    if ([_model.sex isEqualToString:@"0"]){
        defaultImg = DefaultImageGril;
    }else{
        defaultImg = DefaultImageBoy;
    }
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_model.coverPictureAll] placeholderImage:defaultImg];
    self.nickLabel.text = _model.name;
    self.bmLabel.text = _model.departmentName;
    self.timeLabel.text = [NSString stringWithFormat:@"%@分钟", _model.totalTime];
    self.zanCountLabel.text = _model.praise;
    if ([_model.fabulousType isEqualToString:@"1"]) { // 已点赞
        self.zanImgView.image = LoadImage(@"icon_dianzan");
    }else{
        self.zanImgView.image = LoadImage(@"icon_zan");
    }
    NSRange range1 = [self.timeLabel.text rangeOfString:_model.totalTime];
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:self.timeLabel.text];
    [attr1 addAttribute:NSForegroundColorAttributeName value:Color(@"#FDA61D") range:range1];
    [attr1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kMedFont size:15] range:range1];
    self.timeLabel.attributedText = attr1;
}

- (void)setTargetModel:(XWTargetRankModel *)targetModel{
    _targetModel = targetModel;
    UIImage *defaultImg = [[UIImage alloc] init];
    if ([_targetModel.sex isEqualToString:@"0"]){
        defaultImg = DefaultImageGril;
    }else{
        defaultImg = DefaultImageBoy;
    }
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_targetModel.pictureAll] placeholderImage:defaultImg];
    self.nickLabel.text = _targetModel.name;
    self.bmLabel.text = _targetModel.departmentName;
    self.timeLabel.text = [NSString stringWithFormat:@"达成率：%@%%", _targetModel.completion];
    self.timeTagLabel.text = [NSString stringWithFormat:@"完成计划：%@", _targetModel.count];
    self.zanCountLabel.text = _targetModel.fabulous;
    if ([_targetModel.fabulousType isEqualToString:@"1"]) { // 已点赞
        self.zanImgView.image = LoadImage(@"icon_dianzan");
    }else{
        self.zanImgView.image = LoadImage(@"icon_zan");
    }
    
    NSRange range1 = [self.timeLabel.text rangeOfString:[NSString stringWithFormat:@"%@%%", _targetModel.completion]];
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:self.timeLabel.text];
    [attr1 addAttribute:NSForegroundColorAttributeName value:Color(@"#FDA61D") range:range1];
    [attr1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kMedFont size:15] range:range1];
    self.timeLabel.attributedText = attr1;
    
    NSRange range2 = [self.timeTagLabel.text rangeOfString:_targetModel.count];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:self.timeTagLabel.text];
    [attr2 addAttribute:NSForegroundColorAttributeName value:Color(@"#FDA61D") range:range2];
    [attr2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kMedFont size:15] range:range2];
    self.timeTagLabel.attributedText = attr2;
}

- (void)setIdx:(NSInteger)idx{
    _idx = idx;
    self.rankLabel.text = [NSString stringWithFormat:@"%ld", _idx+1];
}

- (void)setIsMyCompany:(BOOL)isMyCompany{
    _isMyCompany = isMyCompany;
    if (_isMyCompany) {
        self.zanBtn.hidden = NO;
        self.zanImgView.hidden = NO;
        self.zanCountLabel.hidden = NO;
        self.rLayoutConstraint.constant = 50;
    }else{
        self.zanCountLabel.hidden = YES;
        self.zanImgView.hidden = YES;
        self.zanBtn.hidden = YES;
        self.rLayoutConstraint.constant = 20;
    }
}

- (IBAction)fabulousAction:(UIButton *)sender {
    NSString *userId = [[NSString alloc] init];
    NSString *fabulous = [[NSString alloc] init];
    if (self.targetModel == nil && self.model != nil) { // 学习排名界面
        userId = self.model.userId;
        fabulous = @"2";
        
    }else if (self.model == nil && self.targetModel != nil) { // 目标排名界面
        userId = self.targetModel.userId;
        fabulous = @"1";
        
    }
    [self fabulousClickWith:userId fabulous:fabulous];
}

- (void)fabulousClickWith:(NSString *)userId fabulous:(NSString *)fabulous{
    
    [XWHttpTool postFabulousWithUserID:userId fabulous:fabulous success:^{
        [MBProgressHUD showTipMessageInWindow:@"点赞成功"];
        self.zanImgView.image = LoadImage(@"icon_dianzan");
        if (self.targetModel == nil && self.model != nil) { // 学习排名界面
            NSInteger count = [self.model.praise integerValue];
            self.zanCountLabel.text = [NSString stringWithFormat:@"%ld", count+1];
        }else if (self.model == nil && self.targetModel != nil) { // 目标排名界面
            NSInteger count = [self.targetModel.fabulous integerValue];
            self.zanCountLabel.text = [NSString stringWithFormat:@"%ld", count+1];
        }
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showTipMessageInWindow:errorInfo];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
