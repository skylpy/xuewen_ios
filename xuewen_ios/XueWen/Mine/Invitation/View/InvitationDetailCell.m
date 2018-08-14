//
//  InvitationDetailCell.m
//  XueWen
//
//  Created by ShaJin on 2018/3/8.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "InvitationDetailCell.h"
#import "InvitationedModel.h"
@interface InvitationDetailCell()

@property (nonatomic, assign) BOOL isCompany;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *registLabel;
@property (nonatomic, strong) UILabel *activeLabel;
@property (nonatomic, strong) UIView *backViwe;
@property (nonatomic, strong) UIImageView *moreView;

@end
@implementation InvitationDetailCell
- (void)setModel:(InvitationedModel *)model{
    _model = model;
    self.backViwe.hidden = !model.showAll;
    self.moreView.image = LoadImage(model.showAll ? @"ico_arrow_retract" : @"ico_arrow_open");
    
    self.nameLabel.text = model.invitedCompanyName;
    self.statusLabel.text = model.status;
    self.dateLabel.text = model.creatTime;
    self.moneyLabel.text = [NSString stringWithFormat:@"本月充值：%@元",model.money];
    self.registLabel.text = [NSString stringWithFormat:@"新增注册：%@",model.registCount];
    self.activeLabel.text = [NSString stringWithFormat:@"新增激活：%@",model.activeCount];
    
    self.nameLabel.sd_layout.widthIs(self.nameLabel.textWidth);
    self.statusLabel.sd_layout.widthIs(self.statusLabel.textWidth);
    self.dateLabel.sd_layout.widthIs(self.dateLabel.textWidth);
}

- (void)setPersonalModel:(InvitationPersonalModel *)personalModel{
    InvitationPersonalModel *model = (InvitationPersonalModel *)personalModel;
    self.backViwe.hidden = YES;
    self.moreView.hidden = YES;

    self.nameLabel.text = model.invitedPhone;
    self.statusLabel.text = model.status;
    self.dateLabel.text = model.creatTime;
    
    self.nameLabel.sd_layout.widthIs(self.nameLabel.textWidth);
    self.statusLabel.sd_layout.widthIs(self.statusLabel.textWidth);
    self.dateLabel.sd_layout.widthIs(self.dateLabel.textWidth);
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self.contentView sd_addSubviews:@[self.nameLabel,self.statusLabel,self.dateLabel,self.moreView,self.backViwe]];
        [self.backViwe sd_addSubviews:@[self.moneyLabel,self.registLabel,self.activeLabel]];
        self.nameLabel.sd_layout.topSpaceToView(self.contentView, 20).leftSpaceToView(self.contentView, 15).heightIs(14);
        self.dateLabel.sd_layout.topSpaceToView(self.contentView, 42).leftSpaceToView(self.contentView, 15).heightIs(10);
        self.statusLabel.sd_layout.topSpaceToView(self.contentView, 20).rightSpaceToView(self.contentView,33).heightIs(14);
        
        self.moreView.sd_layout.topSpaceToView(self.contentView, 24).rightSpaceToView(self.contentView, 15).widthIs(12).heightIs(7);
        
        self.backViwe.sd_layout.topSpaceToView(self.contentView, 72).leftSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0);

        self.moneyLabel.sd_layout.topSpaceToView(self.backViwe, 15).leftSpaceToView(self.backViwe, 15).rightSpaceToView(self.backViwe, 15).heightIs(12);
        self.registLabel.sd_layout.topSpaceToView(self.moreView, 10).leftSpaceToView(self.backViwe, 15).rightSpaceToView(self.backViwe, 15).heightIs(12);
        self.activeLabel.sd_layout.topSpaceToView(self.registLabel, 10).leftSpaceToView(self.backViwe, 15).rightSpaceToView(self.backViwe, 15).heightIs(12);
    }
    return self;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithTextColor:DefaultTitleAColor size:14];
    }
    return _nameLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [UILabel labelWithTextColor:DefaultTitleAColor size:14];
    }
    return _statusLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel labelWithTextColor:DefaultTitleCColor size:12];
    }
    return _dateLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [self getLabel];
    }
    return _moneyLabel;
}

- (UILabel *)registLabel{
    if (!_registLabel) {
        _registLabel = [self getLabel];
    }
    return _registLabel;
}

- (UILabel *)activeLabel{
    if (!_activeLabel) {
        _activeLabel = [self getLabel];
    }
    return _activeLabel;
}

- (UILabel *)getLabel{
    return [UILabel labelWithTextColor:Color(@"#192041") size:12];
}

- (UIImageView *)moreView{
    if (!_moreView) {
        _moreView = [UIImageView new];
        
    }
    return _moreView;
}

- (UIView *)backViwe{
    if (!_backViwe) {
        _backViwe = [UIView new];
        _backViwe.backgroundColor = COLOR(255, 251, 249);
    }
    return _backViwe;
}

@end
