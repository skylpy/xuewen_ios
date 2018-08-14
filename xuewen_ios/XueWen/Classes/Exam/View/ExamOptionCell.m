//
//  ExamOptionCell.m
//  XueWen
//
//  Created by ShaJin on 2017/12/12.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ExamOptionCell.h"
#import "QuestionsModel.h"
@interface ExamOptionCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *result;

@end
@implementation ExamOptionCell
- (void)setModel:(QuestionsOptionModel *)model hasCommit:(BOOL)hasCommit{
    _model = model;
    self.contentLabel.text = model.title;
    CGFloat height = [model.title heightWithWidth:self.contentLabel.width size:15];
    self.contentLabel.sd_layout.heightIs(height);
    if (hasCommit) {
        if (self.model.right) {
            self.result.hidden = NO;
            self.state = (self.model.isSelected) ? kSelectState : kDefaultState;
            
        }else{
            self.result.hidden = YES;
            self.state = (self.model.isSelected) ? kWrongState : kDefaultState;
        }
    }else{
        self.result.hidden = YES;
        self.state = (self.model.isSelected) ? kSelectState : kDefaultState;
    }
}

- (void)setState:(SelectState)state{
    _state = state;
    switch (state) {
        case kSelectState:{
            self.icon.image = LoadImage(@"icoSelectionBoxRight");
        }break;
        case kWrongState:{
            self.icon.image = LoadImage(@"icoSelectionBoxWrong");
        }break;
        default:{
            self.icon.image = LoadImage(@"purseIcoChooseNormal");
        }break;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self.contentView sd_addSubviews:@[self.icon,self.contentLabel,self.result]];
        self.contentLabel.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,45).rightSpaceToView(self.contentView,40);
        self.icon.sd_layout.centerYEqualToView(self.contentLabel).leftSpaceToView(self.contentView,20).widthIs(15).heightIs(15);
        self.result.sd_layout.centerYEqualToView(self.contentLabel).rightSpaceToView(self.contentView,20).widthIs(15).heightIs(15);
        [self.contentLabel updateLayout];
    }
    return self;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.image = LoadImage(@"purseIcoChooseNormal");
    }
    return _icon;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = DefaultTitleAColor;
        _contentLabel.font = kFontSize(15);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIImageView *)result{
    if (!_result) {
        _result = [UIImageView new];
        _result.image = LoadImage(@"payIcoSuccess");
        _result.hidden = YES;
    }
    return _result;
}
@end
