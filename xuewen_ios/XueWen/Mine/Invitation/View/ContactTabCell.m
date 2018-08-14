//
//  ContactTabCell.m
//  XueWen
//
//  Created by Karron Su on 2018/4/23.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ContactTabCell.h"

@interface ContactTabCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneNumberLab;
@property (nonatomic, strong) UIImageView *leftImgV;
@end

@implementation ContactTabCell

#pragma mark - lazy
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:kHeaFont size:18];
        _nameLabel.textColor = Color(@"#2A2732");
    }
    return _nameLabel;
}

- (UILabel *)phoneNumberLab{
    if (!_phoneNumberLab) {
        _phoneNumberLab = [[UILabel alloc] init];
        _phoneNumberLab.font = [UIFont fontWithName:kRegFont size:13];
        _phoneNumberLab.textColor = Color(@"#A7A7A7");
    }
    return _phoneNumberLab;
}

- (UIImageView *)leftImgV{
    if (!_leftImgV) {
        _leftImgV = [[UIImageView alloc] init];
        _leftImgV.image = LoadImage(@"icon_share_normal");
        _leftImgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _leftImgV;
}

#pragma mark - InitUI

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneNumberLab];
    [self.contentView addSubview:self.leftImgV];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.top.mas_equalTo(self.contentView).offset(10);
    }];
    
    [self.phoneNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(3);
    }];
    
    [self.leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-23);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 20);
}

#pragma mark - setter


- (void)setModel:(ContactModel *)model{
    _model = model;
    self.nameLabel.text = _model.name;
    self.phoneNumberLab.text = _model.phoneNumber;
    if (self.isMultiple) {
        self.leftImgV.hidden = NO;
    }else{
        self.leftImgV.hidden = YES;
    }
    if (_model.isChoice) {
        self.leftImgV.image = LoadImage(@"icon_share_choice");
    }else{
        self.leftImgV.image = LoadImage(@"icon_share_normal");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
