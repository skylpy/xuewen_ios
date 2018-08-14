//
//  ConfirmOrderCell.m
//  XueWen
//
//  Created by ShaJin on 2018/3/2.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ConfirmOrderCell.h"
@interface ConfirmOrderCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, strong) UIImageView *moreView;
@end
@implementation ConfirmOrderCell
- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
    _titleLabel.sd_layout.widthIs([title widthWithSize:14]);
}

- (void)setContent:(NSString *)content{
    _content = content;
    if ([_title isEqualToString:@"余额"]) {
        _contentLable.text = [NSString stringWithFormat:@"￥%@",content];
        _contentLable.textColor = COLOR(252, 101, 30);
        _contentLable.sd_layout.rightSpaceToView(self.contentView, 15).widthIs([_contentLable.text widthWithSize:14]);
        _moreView.hidden = YES;
    }else{
        _contentLable.sd_layout.rightSpaceToView(self.contentView, 32).widthIs([content widthWithSize:14]);
        _contentLable.text = content;
        _contentLable.textColor = ([content isEqualToString:@"暂无可用"] || [content isEqualToString:@"请选择"]) ? COLOR(183, 183, 183) : DefaultTitleAColor;
        _moreView.hidden = NO;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView sd_addSubviews:@[self.titleLabel,self.contentLable,self.moreView]];
        self.titleLabel.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView, 15).heightIs(15);
        self.contentLable.sd_layout.centerYEqualToView(self.contentView).heightIs(15);
        self.moreView.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, 15).widthIs(7).heightIs(12);
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:DefaultTitleAColor size:14];
    }
    return _titleLabel;
}

- (UILabel *)contentLable{
    if (!_contentLable) {
        _contentLable = [UILabel labelWithTextColor:COLOR(183, 183, 183) size:14];
    }
    return _contentLable;
}

- (UIImageView *)moreView{
    if (!_moreView) {
        _moreView = [[UIImageView alloc] initWithImage:LoadImage(@"home_ico_arrow")];
    }
    return _moreView;
}
@end
