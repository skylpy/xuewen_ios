//
//  ProjectIntroductionCell.m
//  XueWen
//
//  Created by ShaJin on 2018/1/24.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ProjectIntroductionCell.h"
@interface ProjectIntroductionCell()

@property (nonatomic, strong) UIImageView *leftIcon;
@property (nonatomic, strong) UIImageView *rightIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *textView;

@end
@implementation ProjectIntroductionCell
- (void)setModel:(ProjectModel *)model{
    [super setModel:model];
    self.textView.attributedText = [[NSMutableAttributedString alloc] initWithData:[model.introduction dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView sd_addSubviews:@[self.leftIcon,self.titleLabel,self.rightIcon,self.textView]];
        self.titleLabel.sd_layout.topSpaceToView(self.contentView,24.5).centerXEqualToView(self.contentView).heightIs(16).widthIs(self.titleLabel.textWidth);
        self.leftIcon.sd_layout.centerYEqualToView(self.titleLabel).rightSpaceToView(self.titleLabel,14.5).widthIs(26.5).heightIs(9);
        self.rightIcon.sd_layout.centerYEqualToView(self.titleLabel).leftSpaceToView(self.titleLabel,14.5).widthIs(26.5).heightIs(9);
        self.textView.sd_layout.topSpaceToView(self.titleLabel,4.5).leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).bottomSpaceToView(self.contentView,0);
    }
    return self;
}

- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [UIImageView new];
        _leftIcon.image = LoadImage(@"icoSlash");
    }
    return _leftIcon;
}

- (UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [UIImageView new];
        _rightIcon.image = LoadImage(@"icoSlash");
    }
    return _rightIcon;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:DefaultTitleAColor size:15];
        _titleLabel.text = @"专题介绍";
        _titleLabel.textAlignment = 1;
    }
    return _titleLabel;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
    }
    return _textView;
}
@end
