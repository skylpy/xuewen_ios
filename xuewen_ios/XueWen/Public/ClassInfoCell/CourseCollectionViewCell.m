//
//  CourseCollectionViewCell.m
//  XueWen
//
//  Created by ShaJin on 2017/12/7.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "CourseCollectionViewCell.h"
#import "CourseModel.h"
@interface CourseCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
@implementation CourseCollectionViewCell
- (void)setModel:(CourseModel *)model{
    _model = model;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:model.coverPhoto] placeholderImage:LoadImage(@"default_cover")];
    self.titleLabel.text = model.courseName;
    if ([model.price floatValue] == 0) {
        self.priceLabel.text = @"免费";
        self.priceLabel.textColor = COLOR(14, 201, 80);
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
        self.priceLabel.textColor = COLOR(252, 101, 30);
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld人",(long)model.total];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
