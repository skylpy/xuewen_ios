//
//  XWCertificateCell.m
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCertificateCell.h"

@interface XWCertificateCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation XWCertificateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    self.iconImage.image = [UIImage imageNamed:icon];
    self.titleLabel.text = @"";
}

- (void)setModel:(XWCerChildrenModel *)model {
    
    _model = model;
    NSString * imageURL = model.light == 0 ? model.medal_back_picture_all : model.medal_picture_all;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:DefaultImage];
    self.titleLabel.text = model.achievement_name;
}

@end
