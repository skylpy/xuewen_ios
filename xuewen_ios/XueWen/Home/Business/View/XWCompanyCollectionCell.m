//
//  XWCompanyCollectionCell.m
//  XueWen
//
//  Created by Karron Su on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCompanyCollectionCell.h"

@interface XWCompanyCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bigImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation XWCompanyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bigImgView rounded:3];
}

- (void)setModel:(XWCompanyCoursModel *)model{
    _model = model;
    [self.bigImgView sd_setImageWithURL:[NSURL URLWithString:_model.coverPhotoAll] placeholderImage:DefaultImage];
    self.titleLabel.text = _model.courseName;
    self.countLabel.text = [NSString stringWithFormat:@"%@人学习", _model.total];
}

@end
