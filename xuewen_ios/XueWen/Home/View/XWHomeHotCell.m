//
//  XWHomeHotCell.m
//  XueWen
//
//  Created by Karron Su on 2018/7/20.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHomeHotCell.h"


@interface XWHomeHotCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation XWHomeHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.leftIcon rounded:3];
    [self.rightIcon rounded:3];
}

#pragma mark - Setter
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    XWCourseIndexModel *model1 = _dataArray[1];
    XWCourseIndexModel *model2 = _dataArray[2];
    
    [self.leftIcon sd_setImageWithURL:[NSURL URLWithString:model1.coverPhotoAll] placeholderImage:DefaultImage];
    self.leftTitleLabel.text = model1.courseName;
    self.leftCountLabel.text = [NSString stringWithFormat:@"%@人学习", model1.total];
    if ([model1.amount isEqualToString:@"0.00"]) {
        self.leftPriceLabel.textColor = Color(@"#0EC950");
        self.leftPriceLabel.text = @"免费";
    }else{
        self.leftPriceLabel.text = [NSString stringWithFormat:@"¥%@", model1.amount];
        self.leftPriceLabel.textColor = Color(@"#FD8829");
    }
    
    
    [self.rightIcon sd_setImageWithURL:[NSURL URLWithString:model2.coverPhotoAll] placeholderImage:DefaultImage];
    self.rightTitleLabel.text = model2.courseName;
    self.rightCountLabel.text = [NSString stringWithFormat:@"%@人学习", model2.total];
    if ([model2.amount isEqualToString:@"0.00"]) {
        self.rightPriceLabel.textColor = Color(@"#0EC950");
        self.rightPriceLabel.text = @"免费";
    }else{
        self.rightPriceLabel.text = [NSString stringWithFormat:@"¥%@", model2.amount];
        self.rightPriceLabel.textColor = Color(@"#FD8829");
    }
    
}

- (IBAction)leftBtnClick:(UIButton *)sender {
    XWCourseIndexModel *model = _dataArray[1];
    
    [Analytics event:EventHot2];
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseId isAudio:NO] animated:YES];
}

- (IBAction)rightBtnClick:(id)sender {
    XWCourseIndexModel *model = _dataArray[2];
    
    [Analytics event:EventHot3];
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseId isAudio:NO] animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
