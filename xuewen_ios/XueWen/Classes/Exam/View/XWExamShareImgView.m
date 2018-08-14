//
//  XWExamShareImgView.m
//  XueWen
//
//  Created by Karron Su on 2018/7/4.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWExamShareImgView.h"

@interface XWExamShareImgView ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIImageView *bottomImgView;
@property (nonatomic, strong) UIImageView *QRImgView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UILabel *scoreLabel;

@end

@implementation XWExamShareImgView

#pragma mark - Getter
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight-(150*KScale), kWidth, 150*KScale)];
        _bottomView.backgroundColor = Color(@"#deeff9");
    }
    return _bottomView;
}

- (UIImageView *)headImg{
    if (!_headImg) {
        _headImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[XWInstance shareInstance].userInfo.picture]]];
        [_headImg rounded:30*KScale];
    }
    return _headImg;
}

- (UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nickLabel.textColor = Color(@"#303C6D");
        _nickLabel.font = [UIFont fontWithName:kSemFont size:15];
        _nickLabel.text = [XWInstance shareInstance].userInfo.nick_name;
        _nickLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nickLabel;
}

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImgView.image = LoadImage(@"icon_exam_share_xj");
    }
    return _bgImgView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = Color(@"#5B6DAD");
        _contentLabel.font = [UIFont fontWithName:kSemFont size:12];
        _contentLabel.text = @"在周佳丽老师\n《如何快速销售》的课程考试中获得了";
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomLabel.text = @"邀请你和我一起学习";
        _bottomLabel.textColor = Color(@"#303C6D");
        _bottomLabel.font = [UIFont fontWithName:kSemFont size:15];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}

- (UIImageView *)bottomImgView{
    if (!_bottomImgView) {
        _bottomImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bottomImgView.image = LoadImage(@"icon_exam_share_wz");
    }
    return _bottomImgView;
}

- (UIImageView *)QRImgView{
    if (!_QRImgView) {
        _QRImgView = [[UIImageView alloc] initWithFrame:CGRectMake(237, 24, 63, 63)];
    }
    return _QRImgView;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(227, 100, 100, 10)];
        _tipsLabel.text = @"长按识别 注册学习";
        _tipsLabel.textColor = Color(@"#3C4768");
        _tipsLabel.font = [UIFont fontWithName:kRegFont size:10];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

- (UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _scoreLabel.text = @"100";
        _scoreLabel.textColor = Color(@"#FFC74F");
        _scoreLabel.font = [UIFont fontWithName:@"HYGangYiTiJ" size:25];
        _scoreLabel.textAlignment = NSTextAlignmentRight;
    }
    return _scoreLabel;
}

#pragma mark - Setter
- (void)setQRImage:(UIImage *)QRImage{
    _QRImage = QRImage;
    self.QRImgView.image = _QRImage;
}

- (void)setScore:(NSInteger)score{
    _score = score;
    /*
     100分 状元 旷世奇才
     90-99 榜眼 学富五车
     80-89 探花 栋梁之材
     70-79 进士 国士无双
     60-69 举人 才高八斗
     0-59 秀才 卧虎藏龙
     */
//    _score = 100;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", _score];
    if (_score == 100) {
        self.bgImgView.image = LoadImage(@"icon_exam_share_zy");
    }else if (_score >= 90 && _score < 100){
        self.bgImgView.image = LoadImage(@"icon_exam_share_by");
    }else if (_score >= 80 && _score < 90){
        self.bgImgView.image = LoadImage(@"icon_exam_share_th");
    }else if (_score >= 70 && _score < 80){
        self.bgImgView.image = LoadImage(@"icon_exam_share_js");
    }else if (_score >= 60 && _score < 70){
        self.bgImgView.image = LoadImage(@"icon_exam_share_jr");
    }else {
        self.bgImgView.image = LoadImage(@"icon_exam_share_xj");
    }
    
}

- (void)setModel:(XWExamShareInfoModel *)model{
    _model = model;
    self.contentLabel.text = [NSString stringWithFormat:@"我参与了%@老师\n《%@》\n的课程考试", _model.teacherName, _model.courseName];
    
    NSString *str = [NSString stringWithFormat:@"《%@》", _model.courseName];
    
    NSRange range1 = [self.contentLabel.text rangeOfString:str];
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
    [attr1 addAttribute:NSForegroundColorAttributeName value:Color(@"#303C6D") range:range1];
    [attr1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:16] range:range1];
    self.contentLabel.attributedText = attr1;
}



#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
    }
    return self;
}

#pragma mark - Custom Methods
- (void)drawUI{
    self.backgroundColor = Color(@"#eff8fe");
    
    [self addSubview:self.bottomView];
    [self addSubview:self.bgImgView];
    [self addSubview:self.headImg];
    [self addSubview:self.nickLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.bottomLabel];
    [self.bottomView addSubview:self.bottomImgView];
    [self.bottomView addSubview:self.QRImgView];
    [self.bottomView addSubview:self.tipsLabel];
    [self addSubview:self.scoreLabel];
    self.bgImgView.sd_layout.widthIs((kWidth-15)).heightIs((kWidth-15)).centerXEqualToView(self).topSpaceToView(self, 100*KScale);
    
    self.headImg.sd_layout.topSpaceToView(self, 65*KScale).centerXEqualToView(self).heightIs(60*KScale).widthIs(60*KScale);
    self.nickLabel.sd_layout.topSpaceToView(self, 130*KScale).centerXEqualToView(self).widthIs(kWidth-55).heightIs(25);
    self.contentLabel.sd_layout.widthIs(kWidth-20).heightIs(65).centerXEqualToView(self).bottomSpaceToView(self.bottomView, 53*KScale);
    
    self.bottomLabel.sd_layout.widthIs(kWidth).heightIs(35).centerXEqualToView(self).bottomSpaceToView(self.bottomView, 20*KScale);
    
    self.scoreLabel.sd_layout.widthIs(80).heightIs(30).centerYIs(130*KScale + (kWidth-15-30)/2).centerXIs((kWidth-80)/2 + 20*KScale);
    
    self.bottomImgView.sd_layout.widthIs(102*KScale).heightIs(67*KScale).centerYEqualToView(self.bottomView).leftSpaceToView(self.bottomView, 60*KScale);
    


    self.QRImgView.sd_layout.widthIs(63*KScale).heightIs(63*KScale).topSpaceToView(self.bottomView, 24*KScale).rightSpaceToView(self.bottomView, 76*KScale);
    
    self.tipsLabel.sd_layout.widthIs(100).heightIs(10).topSpaceToView(self.bottomView, 100*KScale).centerXEqualToView(self.QRImgView);
}









@end
