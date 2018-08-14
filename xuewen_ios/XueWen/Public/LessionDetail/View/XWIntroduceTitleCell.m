//
//  XWIntroduceTitleCell.m
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWIntroduceTitleCell.h"

@interface XWIntroduceTitleCell () <UIWebViewDelegate>

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UIButton *testBtn;
@property (nonatomic, strong) UILabel *intronctionLabel;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation XWIntroduceTitleCell

#pragma mark - Getter / Lzay
- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        [_headImgView rounded:19.5];
    }
    return _headImgView;
}

- (UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.textColor = Color(@"#333333");
        _nickLabel.textAlignment = NSTextAlignmentLeft;
        _nickLabel.font = [UIFont fontWithName:kHeaFont size:14];
    }
    return _nickLabel;
}

- (UIButton *)testBtn {
    if (!_testBtn) {
        _testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testBtn setTitle:@"考试" forState:UIControlStateNormal];
        _testBtn.backgroundColor = [UIColor blackColor];
        [_testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _testBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [_testBtn rounded:10.5];
        [_testBtn addTarget:self action:@selector(testBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _testBtn.hidden = YES;
    }
    return _testBtn;
}

- (UILabel *)intronctionLabel {
    if (!_intronctionLabel) {
        _intronctionLabel = [[UILabel alloc] init];
        _intronctionLabel.textColor = Color(@"#333333");
        _intronctionLabel.numberOfLines = 0;
    }
    return _intronctionLabel;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"展开更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:Color(@"#57A2FF") forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:13];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}




#pragma mark - InitUI
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.backgroundColor = Color(@"#847855");
    [self addSubview:self.headImgView];
    [self addSubview:self.nickLabel];
    [self addSubview:self.testBtn];
    [self addSubview:self.intronctionLabel];
    [self addSubview:self.moreBtn];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(29);
        make.top.mas_equalTo(self).offset(18);
        make.size.mas_equalTo(CGSizeMake(39, 39));
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImgView.mas_right).offset(19);
        make.centerY.mas_equalTo(self.headImgView);
    }];
    
    [self.testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-34);
        make.top.mas_equalTo(self).offset(29);
        make.size.mas_equalTo(CGSizeMake(50, 21));
    }];
    
    [self.intronctionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(30);
        make.right.mas_equalTo(self).offset(-23);
        make.top.mas_equalTo(self).offset(72);
        make.bottom.mas_equalTo(self).offset(-20);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    
}

#pragma mark - Setter
- (void)setModel:(XWCoursModel *)model{
    _model = model;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_model.tchOrgPhotoAll]];
    self.nickLabel.text = _model.tchOrg;
//    if (![_model.testid isEqualToString:@"0"]) {
//        self.testBtn.hidden = NO;
//    }else{
//        self.testBtn.hidden = YES;
//    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithData:[_model.tchOrgIntroduction dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSFontAttributeName : [UIFont fontWithName:kRegFont size:13]} documentAttributes:nil error:nil];
    
    self.intronctionLabel.attributedText = attrString;
}

#pragma mark - Custom Methods
- (void)testBtnClick{
    [XWIntroduceTitleCell postNotificationWithName:NotiExamAction];
}

- (void)moreBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        NSLog(@"点击了展开");
        [self postNotificationWithName:@"SHOWALLINTRODCETION" object:nil];
        [sender setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        NSLog(@"点击了收起");
        [self postNotificationWithName:@"HIDEALLINTRODCETION" object:nil];
        [sender setTitle:@"展开更多" forState:UIControlStateNormal];
    }
}



@end
