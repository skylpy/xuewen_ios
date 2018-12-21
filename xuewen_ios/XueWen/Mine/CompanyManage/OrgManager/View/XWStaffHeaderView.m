//
//  XWStaffHeaderView.m
//  XueWen
//
//  Created by Karron Su on 2018/12/13.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWStaffHeaderView.h"
#import "XWStaffInfoModel.h"

@interface XWStaffHeaderView ()

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *postLabel;
@property (nonatomic, strong) UIButton *zenBtn;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation XWStaffHeaderView

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [_bgView rounded:5 width:1 color:Color(@"#DDDDDD")];
        [_bgView shadow:Color(@"#DDDDDD") opacity:1 radius:5 offset:CGSizeMake(0, 0)];
    }
    return _bgView;
}

- (UIImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc] init];
        [_headIcon rounded:30];
        _headIcon.backgroundColor = Color(@"#2E6AE1");
    }
    return _headIcon;
}

- (UILabel *)headLabel {
    if (!_headLabel) {
        _headLabel = [UILabel createALabelText:@"觉罗" withFont:[UIFont systemFontOfSize:14] withColor:[UIColor whiteColor]];
    }
    return _headLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel createALabelText:@"爱新觉罗" withFont:[UIFont systemFontOfSize:18] withColor:Color(@"#333333")];
    }
    return _nameLabel;
}

- (UILabel *)postLabel {
    if (!_postLabel) {
        _postLabel = [UILabel createALabelText:@"项目经理" withFont:[UIFont systemFontOfSize:10] withColor:Color(@"#999999")];
    }
    return _postLabel;
}

- (UIButton *)zenBtn {
    if (!_zenBtn) {
        _zenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zenBtn setTitle:@"赠送经费" forState:UIControlStateNormal];
        [_zenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _zenBtn.backgroundColor = Color(@"#FBCA47");
        [_zenBtn rounded:15];
        _zenBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        @weakify(self)
        [[_zenBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            !self.block ? : self.block();
        }];
    }
    return _zenBtn;
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

- (void)drawUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.headIcon];
    [self.bgView addSubview:self.headLabel];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.postLabel];
    [self.bgView addSubview:self.zenBtn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(self).offset(16);
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
    }];
    
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView);
        make.left.mas_equalTo(self.bgView).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.headIcon);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headIcon.mas_right).offset(15);
        make.top.mas_equalTo(self.bgView).offset(32);
    }];
    
    [self.postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headIcon.mas_right).offset(15);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.zenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView);
        make.right.mas_equalTo(self.bgView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(75, 30));
    }];
}

#pragma mark - Setter
- (void)setModel:(XWStaffInfoModel *)model {
    _model = model;
    self.nameLabel.text = _model.name;
    self.postLabel.text = _model.post;
    if ([_model.picture_all isEqualToString:@""] || _model.picture_all == nil) {
        self.headLabel.hidden = NO;
        NSString *text;
        if (_model.name.length >= 2) {
            text = [_model.name substringFromIndex:_model.name.length - 2];
        }else {
            text = _model.name;
        }
        self.headLabel.text = text;
    }else {
        self.headLabel.hidden = YES;
    }
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:_model.picture_all]];
}

@end
