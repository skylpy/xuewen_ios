//
//  XWCourseCollectionCell.m
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCourseCollectionCell.h"
#import "CAShapeLayer+XWLayer.h"

@interface XWCourseCollectionCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *purchaseBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation XWCourseCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = Color(@"#F6F6F6");
    [self.bgView.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, kWidth-60, 135) withCornerRadius:5 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    [self.purchaseBtn.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, 70, 30) withCornerRadius:2 addStrokeColor:Color(@"#E63835") wlineWidth:1.0f]];
    self.purchaseBtn.layer.borderWidth = 1;
    self.purchaseBtn.layer.borderColor = Color(@"#E63835").CGColor;
    
    [self.coverImage.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, 130, 80) withCornerRadius:2 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    
    @weakify(self)
    [[self.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected = !x.selected;
        self.model.isSelect = x.selected;
    }];
    
    [[self.purchaseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.purchaseClick?:self.purchaseClick(self.model.Id);
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(XWCourseManageModel *)model {
    _model = model;
    [self.coverImage setImageWithURL:[NSURL URLWithString:model.coverphotoall] placeholder:DefaultImage];
    self.titleLabel.text = model.coursename;
    self.teacherLabel.text = [NSString stringWithFormat:@"讲师：%@",model.tchorg];
    self.moneyLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"¥ %@",model.price] rangeText:[NSString stringWithFormat:@"¥ %@",model.price] textFont:[UIFont fontWithName:kRegFont size:14] textColor:Color(@"#F25553")];
    self.selectBtn.selected = model.isSelect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
