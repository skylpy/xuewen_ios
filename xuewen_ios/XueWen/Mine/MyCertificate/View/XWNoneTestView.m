//
//  XWNoneTestView.m
//  XueWen
//
//  Created by aaron on 2018/8/20.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNoneTestView.h"

@interface XWNoneTestView()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (nonatomic,copy) void (^noneTestClick)(void);

@end

@implementation XWNoneTestView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.clipsToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    self.testButton.clipsToBounds = YES;
    self.testButton.layer.cornerRadius = 2;
    @weakify(self)
    [[self.testButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self removeFromSuperview];
        !self.noneTestClick?:self.noneTestClick();
    }];
}

+ (instancetype)shareNoneTestView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"XWNoneTestView" owner:self options:nil].firstObject;
}

- (void)showFromView:(UIView *)superView withTestClick:(void (^)(void))testClick {
    
    self.frame = superView.frame;
    self.noneTestClick = testClick;
    [superView addSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self removeFromSuperview];
}

@end
