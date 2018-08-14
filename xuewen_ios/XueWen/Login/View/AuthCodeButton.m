//
//  AuthCodeButton.m
//  XueWen
//
//  Created by ShaJin on 2017/11/30.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "AuthCodeButton.h"
#import "ReactiveObjC.h"
typedef void(^SendBlock)(void);
@interface AuthCodeButton()
@property (nonatomic, strong) RACDisposable    *disposable;
@property (nonatomic, strong) SendBlock block;
@end
static AuthCodeButton *button = nil;
@implementation AuthCodeButton
+ (instancetype)authCodeButtonWithTarget:(id)target SendAction:(SEL)action{
    if (!button) {
        button = [AuthCodeButton buttonWithType:0];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        [button setTitleColor:COLOR(153, 153, 153) forState:UIControlStateHighlighted];
        button.titleLabel.font = kFontSize(13);
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

- (void)startCountdown{
    RACScheduler *scheduler = [RACScheduler mainThreadScheduler];
    __block NSInteger leftSeconds = 60;
    WeakSelf;
    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        weakSelf.disposable = [scheduler after:[NSDate dateWithTimeIntervalSinceNow:0] repeatingEvery:1 withLeeway:0.0 schedule:^{
            [subscriber sendNext:nil];
        }];
        return weakSelf.disposable;
    }] subscribeNext:^(id  _Nullable x) {
        if (leftSeconds > 0) {
            [weakSelf setTitle:[NSString stringWithFormat:@"重新获取%lds",(long)leftSeconds--] forState:UIControlStateNormal];
            [weakSelf setTitleColor:DefaultTitleCColor forState:UIControlStateNormal];
            weakSelf.enabled = NO;
            weakSelf.hasSend = YES;
        }else{
            [weakSelf setTitle:@"获取验证码" forState:UIControlStateNormal];
            [weakSelf setTitleColor:kThemeColor forState:UIControlStateNormal];
            weakSelf.enabled = YES;
            [weakSelf.disposable dispose];
            button = nil;
            weakSelf.hasSend = NO;
        }
    }];
}

+ (instancetype)authCodeButton{
    if (!button) {
        button = [AuthCodeButton buttonWithType:0];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        [button setTitleColor:COLOR(153, 153, 153) forState:UIControlStateHighlighted];
        button.titleLabel.font = kFontSize(13);
        [button addTarget:button action:@selector(sendAuthButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

+ (instancetype)authCodeButtonWithSendBlock:(void(^)(void))sendBlock{
    if (!button) {
        button = [AuthCodeButton buttonWithType:0];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        [button setTitleColor:COLOR(153, 153, 153) forState:UIControlStateHighlighted];
        button.titleLabel.font = kFontSize(13);
        [button addTarget:button action:@selector(sendAuthButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.block = ^(){
            sendBlock();
        };
    }
    return button;
}

- (void)sendAuthButtonAction:(UIButton *)sender{
    self.block();
    RACScheduler *scheduler = [RACScheduler mainThreadScheduler];
    __block NSInteger leftSeconds = 60;
    WeakSelf;
    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        weakSelf.disposable = [scheduler after:[NSDate dateWithTimeIntervalSinceNow:0] repeatingEvery:1 withLeeway:0.0 schedule:^{
            [subscriber sendNext:nil];
        }];
        return weakSelf.disposable;
    }] subscribeNext:^(id  _Nullable x) {
        if (leftSeconds > 0) {
            [sender setTitle:[NSString stringWithFormat:@"重新获取%lds",(long)leftSeconds--] forState:UIControlStateNormal];
            [sender setTitleColor:DefaultTitleCColor forState:UIControlStateNormal];
            sender.enabled = NO;
            weakSelf.hasSend = YES;
        }else{
            [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
            [sender setTitleColor:kThemeColor forState:UIControlStateNormal];
            sender.enabled = YES;
            [weakSelf.disposable dispose];
            button = nil;
            weakSelf.hasSend = NO;
        }
    }];
    
}

- (void)dealloc{
    NSLog(@"%s DEALLOC",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}
@end
