//
//  XWCollegeCollectionCell.m
//  XueWen
//
//  Created by Karron Su on 2018/4/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCollegeCollectionCell.h"

@interface XWCollegeCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@end
@implementation XWCollegeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imgView rounded:3];
}

#pragma mark - Setter
- (void)setLabelModel:(XWCourseLabelModel *)labelModel{
    _labelModel = labelModel;
//    if ([_labelModel.labelName containsString:@"老板"]) {
//        self.imgView.image = LoadImage(@"老板.jpg");
//    }else if ([_labelModel.labelName containsString:@"市场营销"]){
//        self.imgView.image = LoadImage(@"市场营销.jpg");
//    }else if ([_labelModel.labelName containsString:@"销售管理"]){
//        self.imgView.image = LoadImage(@"销售管理.jpg");
//    }else if ([_labelModel.labelName containsString:@"人力资源"]){
//        self.imgView.image = LoadImage(@"人力资源.jpg");
//    }else if ([_labelModel.labelName containsString:@"互联网"]){
//        self.imgView.image = LoadImage(@"互联网.jpg");
//    }else if ([_labelModel.labelName containsString:@"财税管理"]){
//        self.imgView.image = LoadImage(@"财税管理.jpg");
//    }else if ([_labelModel.labelName containsString:@"行政管理"]){
//        self.imgView.image = LoadImage(@"行政管理.jpg");
//    }else if ([_labelModel.labelName containsString:@"生产管理"]){
//        self.imgView.image = LoadImage(@"生产管理.jpg");
//    }
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_labelModel.coverAll] placeholderImage:DefaultImage];
    self.nickLabel.text = _labelModel.labelName;
}



@end
