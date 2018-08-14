//
//  XWCompanyInfoCell.m
//  XueWen
//
//  Created by Karron Su on 2018/7/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCompanyInfoCell.h"

@interface XWCompanyInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *companyInd;


@end

@implementation XWCompanyInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(XWCompanyInfoModel *)model{
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:_model.co_picture_all] placeholderImage:DefaultImage];
    self.companyName.text = _model.co_name;
    NSString *info = [NSString filterHTML:_model.co_introduction];
    self.companyInd.text = [NSString stringWithFormat:@"公司简介: %@", info];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
