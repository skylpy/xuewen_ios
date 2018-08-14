//
//  MyWalletCell.m
//  XueWen
//
//  Created by ShaJin on 2017/11/16.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyWalletCell.h"
@interface MyWalletCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation MyWalletCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.icon];
        [self addSubview:self.titleLabel];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.icon.sd_layout.leftSpaceToView(self,11).topSpaceToView(self,16.5).widthIs(20).heightIs(20);
        self.titleLabel.sd_layout.topSpaceToView(self,19).leftSpaceToView(self.icon,5.5).bottomSpaceToView(self,19).rightSpaceToView(self,30);
    }
    return self;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.image = LoadImage(@"icoTransactionDetails");
    }
    return _icon;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"交易明细";
        _titleLabel.textColor = COLOR(51, 51, 51);
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}
@end
