//
//  XWNoneRedPakeView.m
//  XueWen
//
//  Created by aaron on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNoneRedPakeView.h"

@interface XWNoneRedPakeView()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *InvitationButton;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (nonatomic,copy) void (^goSeeClick)(NoneRedType type,RedBackType rtype);

@end

@implementation XWNoneRedPakeView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self)
    [[self.goodButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        !self.goSeeClick?:self.goSeeClick(goodType,AppearType);
        [self removeFromSuperview];
    }];
    
    [[self.InvitationButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.goSeeClick?:self.goSeeClick(InvitationType,AppearType);
        [self removeFromSuperview];
    }];
    
    [[self.refuseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        !self.goSeeClick?:self.goSeeClick(refushType,AppearType);
        [self removeFromSuperview];
    }];
}

+ (instancetype)shareNoneRedPakeView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"XWNoneRedPakeView" owner:self options:nil].firstObject;
}

- (void)showFromView:(UIView *)superView withState:(NSString *)state withGoSeeClick:(void (^)(NoneRedType type,RedBackType rtype))goSeeClick {
    
    self.frame = superView.frame;
    BOOL flag = [state isEqualToString:@"1"] ? NO : YES;
    self.bgImageView.image = flag ? [UIImage imageNamed:@"back_ground_red"]:[UIImage imageNamed:@"background_red"];
    if (flag) {
        self.goodButton.hidden = NO;
        self.refuseButton.hidden = NO;
        self.InvitationButton.hidden = YES;
    }else {
        self.goodButton.hidden = YES;
        self.refuseButton.hidden = YES;
        self.InvitationButton.hidden = NO;
        
    }
    self.goSeeClick = goSeeClick;
    [superView addSubview:self];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    !self.goSeeClick?:self.goSeeClick(noneType,DisappearType);
    [self removeFromSuperview];
}

@end
