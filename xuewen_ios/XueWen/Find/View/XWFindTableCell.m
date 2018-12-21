//
//  XWFindTableCell.m
//  XueWen
//
//  Created by Karron Su on 2018/10/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWFindTableCell.h"

@interface XWFindTableCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLab;
@property (weak, nonatomic) IBOutlet UILabel *companyInfoLab;
@property (weak, nonatomic) IBOutlet UIImageView *smallImgV;
@property (weak, nonatomic) IBOutlet UIImageView *bigImgV;


@end

@implementation XWFindTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView rounded:3];
    [self.bigImgV rounded:3];
}

- (void)setModel:(XWFindListModel *)model {
    
    _model = model;
    [self.smallImgV setImageWithURL:[NSURL URLWithString:model.logoUrlAll] placeholder:DefaultImage];
    [self.bigImgV setImageWithURL:[NSURL URLWithString:model.pictureUrlAll] placeholder:DefaultImage];
    self.companyNameLab.text = model.coName;
    self.companyInfoLab.text = model.coIntroduction;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
