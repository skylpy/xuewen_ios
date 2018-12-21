//
//  XWTestEduHeaderView.m
//  XueWen
//
//  Created by aaron on 2018/10/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWTestEduHeaderView.h"

@interface XWTestEduHeaderView ()

@property (nonatomic,strong) UIImageView * topImage;

@property (nonatomic,strong) UIButton * dateilButton;

@end

@implementation XWTestEduHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topImage];
    [self addSubview:self.desLabel];
    [self addSubview:self.dateilButton];
    
    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.offset(15);
        make.right.offset(-15);
        make.height.offset(150);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topImage.mas_bottom).offset(10);
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-30);
    }];
    
    [self.dateilButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.offset(15);
        make.width.offset(50);
    }];
    
    @weakify(self)
    [[self.dateilButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(push)]) {
            
            [self.delegate push];
        }
    }];
}

- (UILabel *)desLabel {
    
    if (!_desLabel) {
        _desLabel = [UILabel createALabelText:@"根据招聘岗位智能生成一套岗位标准化测试题。通过“测一测”的成 绩，反馈面试者与企业招聘要求的匹配度。\n企业招聘新员工时，HR使用“测一测”功能，让面试者测试。然后,HR根据测试成绩，选出最符合企业岗位需求的人员。快速解决就业如何招聘合适人才的问题。" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#333333")];
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}

- (UIImageView *)topImage {
    
    if (!_topImage) {
        UIImageView * imageView = [UIImageView new];
        _topImage = imageView;
        imageView.image = [UIImage imageNamed:@"test_top_photo"];
    }
    return _topImage;
}

- (UIButton *)dateilButton {
    
    if (!_dateilButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        _dateilButton = button;
        [button setTitle:@"[了解详情]" forState:UIControlStateNormal];
        [button setTitleColor:Color(@"#1A92EF") forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:kRegFont size:10];
    }
    return _dateilButton;
}

@end
