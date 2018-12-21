//
//  XWChoiceLabelCell.m
//  XueWen
//
//  Created by Karron Su on 2018/12/14.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWChoiceLabelCell.h"

@interface XWChoiceLabelCell ()

@property (weak, nonatomic) IBOutlet UIButton *choiceBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation XWChoiceLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(XWLabelModel *)model {
    _model = model;
    self.titleLabel.text = _model.label_name;
    if (_model.isSelect) {
        [self.choiceBtn setImage:LoadImage(@"Checklist2") forState:UIControlStateNormal];
    }else {
        [self.choiceBtn setImage:LoadImage(@"xuanzico") forState:UIControlStateNormal];
    }
}

- (IBAction)choiceBtnClick:(UIButton *)sender {
    !self.block ? : self.block(self.model);
}

@end
