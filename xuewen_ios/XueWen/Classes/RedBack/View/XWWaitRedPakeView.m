//
//  XWWaitRedPakeView.m
//  XueWen
//
//  Created by aaron on 2018/9/13.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWWaitRedPakeView.h"

@interface XWWaitRedPakeView()
@property (weak, nonatomic) IBOutlet UIView *redBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *personRedbackTop;

@property (assign,nonatomic) BOOL flag;
@end

@implementation XWWaitRedPakeView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redBgView.layer.cornerRadius = 15;
    self.redBgView.clipsToBounds = YES;
    self.flag = YES;
    [self delayMethod];
    
    [self performSelector:@selector(canceMethod) withObject:nil afterDelay:3.0f];
}

- (void)canceMethod {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
    [self removeFromSuperview];
}

- (void)delayMethod {
    NSLog(@"execute");
    self.personRedbackTop.constant = self.flag ? 25 : 20;
    self.flag = !self.flag;
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.2f];
}

+ (instancetype)shareWaitRedPakeView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"XWWaitRedPakeView" owner:self options:nil].firstObject;
}

- (void)showFromView:(UIView *)superView {
    
    self.frame = superView.frame;
    
    [superView addSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
    [self removeFromSuperview];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

@end
