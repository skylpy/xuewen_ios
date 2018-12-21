//
//  XWRedBackView.m
//  XueWen
//
//  Created by aaron on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRedBackView.h"


@interface XWRedBackView()

@property (nonatomic,copy) void (^goSeeClick)(RedBackType type);
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *goSeeButton;

@end

@implementation XWRedBackView

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

+ (instancetype)shareRedBackView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"XWRedBackView" owner:self options:nil].firstObject;
}

- (void)showFromView:(UIView *)superView withMoney:(NSString *)money withTestClick:(void (^)(RedBackType type))goSeeClick {
    
    self.frame = superView.frame;
    self.moneyLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"%@元",money] rangeText:money textFont:[UIFont fontWithName:kRegFont size:30] textColor:Color(@"#FAEC12")];
    self.goSeeClick = goSeeClick;
    [superView addSubview:self];
    
    @weakify(self)
    [[self.goSeeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.goSeeClick?:self.goSeeClick(AppearType);
        [self removeFromSuperview];
    }];
}

- (IBAction)closeButtonClick:(UIButton *)sender {
    
    !self.goSeeClick?:self.goSeeClick(DisappearType);
    [self removeFromSuperview];
}

@end
