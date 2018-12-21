//
//  XWGiveCouponView.m
//  XueWen
//
//  Created by Karron Su on 2018/12/15.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWGiveCouponView.h"
#import <pop/POP.h>

@interface XWGiveCouponView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *comfireBtn;
@property (nonatomic, strong) NSString *toUserId;

@end

@implementation XWGiveCouponView

- (instancetype)initWithFrame:(CGRect)frame toUserId:(nonnull NSString *)toUserId {
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"XWGiveCouponView" owner:self options:nil] lastObject];
    if (self) {
        self.toUserId = toUserId;
        self.frame = frame;
        [self.bgView rounded:10];
        [self.closeBtn setImage:LoadImage(@"closeico") forState:UIControlStateNormal];
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        anim.duration = 0.5;
        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        [self.bgView.layer pop_addAnimation:anim forKey:@"anim"];
        
        POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
        alphaAnim.duration = 0.5;
        alphaAnim.toValue = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self.layer pop_addAnimation:alphaAnim forKey:@"alphaAnim"];
    }
    return self;
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    
    [self close];
    
}

- (IBAction)comfireBtnClick:(UIButton *)sender {
    
    if (self.inputField.text == nil || [self.inputField.text isEqualToString:@""]) {
        [MBProgressHUD showTipMessageInWindow:@"请输入赠送金额"];
        return;
    }
    
    XWWeakSelf
    [XWHttpTool giveGoldWithToUserId:self.toUserId gold:self.inputField.text success:^{
        [MBProgressHUD showTipMessageInWindow:@"赠送成功"];
        [weakSelf close];
    } failure:^(NSString *error) {
        [MBProgressHUD showTipMessageInWindow:error];
    }];
}

- (void)close {
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.duration = 0.5;
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    XWWeakSelf
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [weakSelf removeFromSuperview];
        }
    };
    [self.bgView.layer pop_addAnimation:anim forKey:@"anim"];
    
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
    alphaAnim.duration = 0.5;
    alphaAnim.toValue = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self.layer pop_addAnimation:alphaAnim forKey:@"alphaAnim"];
}

@end
