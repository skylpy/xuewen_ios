//
//  XWCourseCell.m
//  XueWen
//
//  Created by aaron on 2018/7/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCourseCell.h"
#import "CourseModel.h"
#import "UIImage+Extension.h"
#import "CAShapeLayer+XWLayer.h"

@interface XWCourseCell()

@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation XWCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //通过CAShapeLayer 高效画圆角
//    [self.iconImage.layer setMask:[CAShapeLayer shapeLayerRect:self.iconImage.bounds withCornerRadius:3 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    self.iconImage.layer.cornerRadius = 3;
    self.iconImage.clipsToBounds = YES;
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setModel:(CourseModel *)model {
    _model = model;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.coverPhoto] placeholderImage:DefaultImage];
    
    self.personLabel.text = [NSString stringWithFormat:@"%ld人学习",model.total];
    self.titleLabel.text = model.courseName;
    if (model.percentage == 0) {
        if ([model.price isEqualToString:@"0.00"]) {
            self.priceLabel.textColor = Color(@"#0EC950");
            self.priceLabel.text = @"免费";
        }else{
            self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
            self.priceLabel.textColor = Color(@"#FD8829");
        }
        
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"已学%ld%%", model.percentage];
        self.priceLabel.textColor = Color(@"#267DFF");
    }
}

- (void)setBuy:(BOOL)buy{
    _buy = buy;
    if (_buy) {
        self.priceLabel.text = [NSString stringWithFormat:@"已学%ld%%", _model.percentage];
        self.priceLabel.textColor = Color(@"#267DFF");
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _model.price];
        self.priceLabel.textColor = Color(@"#FD8829");
    }
}

@end
