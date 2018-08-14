//
//  XWExamResultCell.m
//  XueWen
//
//  Created by Karron Su on 2018/6/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWExamResultCell.h"

@interface XWExamResultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *tchImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation XWExamResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.tchImgView rounded:2];
}

- (void)setModel:(XWRecommendCourseModel *)model{
    _model = model;
    [self.tchImgView sd_setImageWithURL:[NSURL URLWithString:_model.coverPhotoAll] placeholderImage:DefaultImage];
    self.titleLabel.text = _model.courseName;
    self.countLabel.text = [NSString stringWithFormat:@"%@人学习", _model.studynum];
    if ([_model.amount isEqualToString:@"0.00"]) {
        self.priceLabel.text = @"免费";
        self.priceLabel.textColor = Color(@"#0EC950");
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _model.amount];
        self.priceLabel.textColor = Color(@"#FC651E");
    }
}

@end
