//
//  XWProjectIntroduceCell.m
//  XueWen
//
//  Created by Karron Su on 2018/8/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWProjectIntroduceCell.h"

@interface XWProjectIntroduceCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation XWProjectIntroduceCell

#pragma mark - Getter
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = Color(@"#333333");
        _label.font = [UIFont fontWithName:kMedFont size:12];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.numberOfLines = 0;
    }
    return _label;
}

#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(26);
        make.right.mas_equalTo(self.contentView).offset(-26);
        make.top.mas_equalTo(self.contentView).offset(20);
        make.bottom.mas_equalTo(self.contentView).offset(-27);
    }];
}

- (void)setIntroduce:(NSString *)introduce{
    _introduce = introduce;
    self.label.text = [NSString filterHTML:_introduce];
}

@end
