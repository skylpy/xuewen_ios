//
//  XWCourseCell.m
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCourseTableCell.h"
#import "CAShapeLayer+XWLayer.h"
#import "NSMutableAttributedString+XWUtil.h"
#import "NSString+Extension.h"

@interface XWCourseTableCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *functionBtn;

@end

@implementation XWCourseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = Color(@"#F6F6F6");
    [self.bgView.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, kWidth-30, 135) withCornerRadius:5 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    [self.functionBtn.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, 70, 30) withCornerRadius:2 addStrokeColor:Color(@"#2E6AE1") wlineWidth:1.0f]];
    self.functionBtn.layer.borderWidth = 1;
    self.functionBtn.layer.borderColor = Color(@"#2E6AE1").CGColor;
    
    @weakify(self)
    [[self.functionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.functionClick?:self.functionClick();
    }];
    
    [self.coverImage.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, 130, 80) withCornerRadius:2 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    
    [[self.hideBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.libmodel) {
            !self.hideBtnClick?:self.hideBtnClick(self.libmodel.Id);
        }
        if (self.cmodel) {
            !self.hideBtnClick?:self.hideBtnClick(self.cmodel.Id);
        }
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


- (void)setModel:(XWCourseManageModel *)model {
    _model = model;
    [self.coverImage setImageWithURL:[NSURL URLWithString:model.coverphotoall] placeholder:DefaultImage];
    self.titleLabel.text = model.coursename;
    self.teacherLabel.text = [NSString stringWithFormat:@"讲师：%@",model.tchorg];
    self.timeLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"有效期：%@ / %@人次",[model.expirytime stringWithDataFormatter:@"yyyy.MM.dd"],model.total] rangeText:model.total textFont:[UIFont fontWithName:kRegFont size:10] textColor:Color(@"#FEA520")];
}

-(void)setCmodel:(XWCourseManageModel *)cmodel {
    _cmodel = cmodel;
    [self.coverImage setImageWithURL:[NSURL URLWithString:cmodel.coverphotoall] placeholder:DefaultImage];
    self.titleLabel.text = cmodel.coursename;
    self.teacherLabel.text = [NSString stringWithFormat:@"讲师：%@",cmodel.tchorg];
    self.timeLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"¥ %@",cmodel.price] rangeText:[NSString stringWithFormat:@"¥ %@",cmodel.price] textFont:[UIFont fontWithName:kRegFont size:14] textColor:Color(@"#F25553")];
    self.functionBtn.layer.borderColor = Color(@"#F25553").CGColor;
    [self.functionBtn setTitle:@"立刻购买" forState:UIControlStateNormal];
    [self.functionBtn setTitleColor:Color(@"#F25553") forState:UIControlStateNormal];
}

-(void)setLibmodel:(XWCourseManageModel *)libmodel {
    _libmodel = libmodel;
    [self.coverImage setImageWithURL:[NSURL URLWithString:libmodel.coverphotoall] placeholder:DefaultImage];
    self.titleLabel.text = libmodel.coursename;
    self.teacherLabel.text = [NSString stringWithFormat:@"讲师：%@",libmodel.tchorg];
    self.timeLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"¥ %@",libmodel.price] rangeText:[NSString stringWithFormat:@"¥ %@",libmodel.price] textFont:[UIFont fontWithName:kRegFont size:14] textColor:Color(@"#F25553")];
    self.functionBtn.layer.borderColor = Color(@"#F25553").CGColor;
    [self.functionBtn setTitle:@"立刻购买" forState:UIControlStateNormal];
    [self.functionBtn setTitleColor:Color(@"#F25553") forState:UIControlStateNormal];
    if ([libmodel.type isEqualToString:@"0"]) {
        [self.hideBtn setTitle:@"加入收藏" forState:UIControlStateNormal];
        [self.hideBtn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateNormal];
    }else {
        [self.hideBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        [self.hideBtn setTitleColor:Color(@"#999999") forState:UIControlStateNormal];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
