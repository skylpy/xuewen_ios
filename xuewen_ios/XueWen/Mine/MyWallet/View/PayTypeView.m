//
//  PayTypeView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/7.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "PayTypeView.h"
#define Duration 0.25
@interface PayTypeView()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;

@end
@implementation PayTypeView
- (IBAction)zhifubaoAction:(id)sender {
}

- (IBAction)wechatAction:(id)sender {
}

- (void)tapAction:(UITapGestureRecognizer *)gesture{
    [self dismiss];
}

- (instancetype)init{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    if (self) {
        self.backgroundView.y = kHeight;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        self.zhifubaoButton.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)show{
    [UIView animateWithDuration:Duration animations:^{
        self.backgroundView.y = kHeight - self.backgroundView.height;
    }];
}

- (void)dismiss{
    XWWeakSelf
    [UIView animateWithDuration:Duration animations:^{
        weakSelf.backgroundView.y = kHeight;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
