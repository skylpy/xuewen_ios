//
//  XWCustomPopView.m
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCustomPopView.h"

@interface XWCustomPopView()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *examButton;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (copy, nonatomic) void (^examClick)(void);

@end

@implementation XWCustomPopView


+ (instancetype)shareCustomNew {
    
    return [[NSBundle mainBundle] loadNibNamed:@"XWCustomPopView" owner:self options:nil].firstObject;
}

- (void)showFoemSuperView:(UIView *)superView withTitle:(NSString *)title withExamClick:(void (^)(void))examClick {
    
    self.customView.layer.cornerRadius = 5;
    self.customView.clipsToBounds = YES;
    self.frame = superView.frame;
    
    self.examClick = examClick;
    self.centerLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"%@考试资格",title] rangeText:title textFont:[UIFont fontWithName:kRegFont size:14] textColor:Color(@"#F82020")];
    [superView addSubview:self];
    
    @weakify(self)
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self removeFromSuperview];
    }];
    
    [[self.examButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self removeFromSuperview];
        !self.examClick?:self.examClick();
    }];
}

@end
