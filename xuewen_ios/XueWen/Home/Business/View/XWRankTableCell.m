//
//  XWRankTableCell.m
//  XueWen
//
//  Created by Karron Su on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRankTableCell.h"

@interface XWRankTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zenImgView;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet UILabel *timeTagLabel;



@end

@implementation XWRankTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImgView rounded:33];
    self.lineView.backgroundColor = Color(@"#EBEAEA");
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Setter
- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    if (_isLast) {
        self.leftConstraint.constant = 0;
        self.rightConstraint.constant = 0;
    }else{
        self.leftConstraint.constant = 25;
        self.rightConstraint.constant = 12;
    }
}

- (void)setModel:(XWCountPlayTimeModel *)model{
    _model = model;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_model.coverPictureAll] placeholderImage:DefaultImage];
    self.nickLabel.text = _model.name;
    self.bmLabel.text = _model.departmentName;
    self.timeLabel.text = [NSString stringWithFormat:@"%@分钟", _model.totalTime];
    self.zanLabel.text = _model.praise;
    if ([_model.fabulousType isEqualToString:@"1"]) { // 已点赞
        self.zenImgView.image = LoadImage(@"icon_dianzan");
    }else{
        self.zenImgView.image = LoadImage(@"icon_zan");
    }
    NSRange range1 = [self.timeLabel.text rangeOfString:_model.totalTime];
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:self.timeLabel.text];
    [attr1 addAttribute:NSForegroundColorAttributeName value:Color(@"#FDA61D") range:range1];
    [attr1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kMedFont size:15] range:range1];
    self.timeLabel.attributedText = attr1;
}

- (void)setTargetModel:(XWTargetRankModel *)targetModel{
    _targetModel = targetModel;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_targetModel.pictureAll] placeholderImage:DefaultImage];
    self.nickLabel.text = _targetModel.name;
    self.bmLabel.text = _targetModel.departmentName;
    self.timeLabel.text = [NSString stringWithFormat:@"达成率：%@%%", _targetModel.completion];
    self.timeTagLabel.text = [NSString stringWithFormat:@"完成计划：%@", _targetModel.count];
    self.zanLabel.text = _targetModel.fabulous;
    if ([_targetModel.fabulousType isEqualToString:@"1"]) { // 已点赞
        self.zenImgView.image = LoadImage(@"icon_dianzan");
    }else{
        self.zenImgView.image = LoadImage(@"icon_zan");
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
    if (_idx == 0) {
        self.bgImgView.image = LoadImage(@"icon_first");
    }else if (_idx == 1){
        self.bgImgView.image = LoadImage(@"icon_second");
    }else{
        self.bgImgView.image = LoadImage(@"icon_third");
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
        self.zenImgView.image = LoadImage(@"icon_dianzan");
        if (self.targetModel == nil && self.model != nil) { // 学习排名界面
            NSInteger count = [self.model.praise integerValue];
            self.zanLabel.text = [NSString stringWithFormat:@"%ld", count+1];
        }else if (self.model == nil && self.targetModel != nil) { // 目标排名界面
            NSInteger count = [self.targetModel.fabulous integerValue];
            self.zanLabel.text = [NSString stringWithFormat:@"%ld", count+1];
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
