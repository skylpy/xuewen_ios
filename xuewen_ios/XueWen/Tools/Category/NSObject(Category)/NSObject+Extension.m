//
//  NSObject+Extension.m
//  XueWen
//
//  Created by ShaJin on 2017/11/24.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)
/** 注册键盘通知 */
- (void)addKeyboardNoticationWithShowAction:(SEL)keyboardWillShow hiddenAciton:(SEL)keyboardWillHidden{
    [self addNotificationWithName:UIKeyboardWillShowNotification selector:keyboardWillShow];
    [self addNotificationWithName:UIKeyboardWillHideNotification selector:keyboardWillHidden];
}

/** 注册通知 */
- (void)addNotificationWithName:(NSString *)noticationName selector:(SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:noticationName object:nil];
}

/** 移除指定的通知 */
- (void)removeNotificationWithName:(NSString *)noticationName{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noticationName object:nil];
}

/** 移除所有通知 */
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 发送一个通知 */
- (void)postNotificationWithName:(NSString *)noticationName object:(id)object{
    [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:object];
}

/** 发送一个通知 */
+ (void)postNotificationWithName:(NSString *)noticationName{
    [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil];
}

/** 在主线程执行的任务 */
+ (void)actionWithMainQueue:(void (^)(void))action{
    dispatch_async(dispatch_get_main_queue(), ^{
        action();
    });
}

/** 在多线程执行的任务 */
+ (void)actionWithGlobalQueue:(void(^)(void))action{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        action();
    });
}
@end
