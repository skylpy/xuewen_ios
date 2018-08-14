//
//  XWNMyCourseCell.m
//  XueWen
//
//  Created by aaron on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNMyCourseCell.h"
#import "CAShapeLayer+XWLayer.h"

@interface XWNMyCourseCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *connentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *learnLabel;

@end

@implementation XWNMyCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //通过CAShapeLayer 高效画圆角
    [self.iconImage.layer setMask:[CAShapeLayer shapeLayerRect:self.iconImage.bounds withCornerRadius:2 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.titleLabel.font = [UIFont fontWithName:kMedFont size:14];
    self.connentLabel.font = [UIFont fontWithName:kRegFont size:11];
    self.nameLabel.font = [UIFont fontWithName:kRegFont size:12];
    self.learnLabel.font = [UIFont fontWithName:kRegFont size:13];
}

- (void)setModel:(CourseModel *)model {
    _model = model;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.coverPhoto] placeholderImage:DefaultImage];
    self.titleLabel.text = model.courseName;
    self.connentLabel.text = model.labelName;
    if (model.teacherName != nil&&model.teacherIntroduction != nil) {
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithData:[[NSString stringWithFormat:@"%@  %@",model.teacherName,model.teacherIntroduction] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSFontAttributeName : [UIFont fontWithName:kRegFont size:13]} documentAttributes:nil error:nil];
        self.nameLabel.attributedText = attrString;
    }
    
    self.learnLabel.text = [NSString stringWithFormat:@"已学%ld%%",model.percentage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
