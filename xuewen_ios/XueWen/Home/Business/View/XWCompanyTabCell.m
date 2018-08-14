//
//  XWCompanyTabCell.m
//  XueWen
//
//  Created by Karron Su on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCompanyTabCell.h"

@interface XWCompanyTabCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tchLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation XWCompanyTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.leftImgView rounded:2];
    [self.label1 rounded:6];
    [self.label2 rounded:6];
    [self.label3 rounded:6];
    self.separatorInset = UIEdgeInsetsMake(0, 25, 0, 25);
}

#pragma mark - Setter
- (void)setModel:(XWLearningModel *)model{
    _model = model;
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:_model.coverPhotoAll] placeholderImage:DefaultImage];
    self.titleLabel.text = _model.courseName;
    self.tchLabel.text = _model.name;
    self.countLabel.text = [NSString stringWithFormat:@"有%@位同事在学", _model.total];
    if (_model.lable.count == 0) {
        self.label1.hidden = YES;
        self.label2.hidden = YES;
        self.label3.hidden = YES;
    }else if (_model.lable.count == 1){
        self.label1.hidden = NO;
        self.label1.text = [NSString stringWithFormat:@"  %@  ", _model.lable[0]];
        self.label2.hidden = YES;
        self.label3.hidden = YES;
    }else if (_model.lable.count == 2){
        self.label1.hidden = NO;
        self.label1.text = [NSString stringWithFormat:@"  %@  ", _model.lable[0]];
        self.label2.hidden = NO;
        self.label2.text = [NSString stringWithFormat:@"  %@  ", _model.lable[1]];
        self.label3.hidden = YES;
    }else{
        self.label1.hidden = NO;
        self.label1.text = [NSString stringWithFormat:@"  %@  ", _model.lable[0]];
        self.label2.hidden = NO;
        self.label2.text = [NSString stringWithFormat:@"  %@  ", _model.lable[1]];
        self.label3.hidden = NO;
        self.label3.text = [NSString stringWithFormat:@"  %@  ", _model.lable[2]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
