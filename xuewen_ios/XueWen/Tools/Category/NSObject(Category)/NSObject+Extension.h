//
//  NSObject+Extension.h
//  XueWen
//
//  Created by ShaJin on 2017/11/24.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)
/** 注册键盘通知 */
- (void)addKeyboardNoticationWithShowAction:(SEL)keyboardWillShow hiddenAciton:(SEL)keyboardWillHidden;
/** 注册通知 */
- (void)addNotificationWithName:(NSString *)noticationName selector:(SEL)selector;
/** 移除指定的通知 */
- (void)removeNotificationWithName:(NSString *)noticationName;
/** 移除所有通知 */
- (void)removeNotification;
/** 发送一个通知 */
- (void)postNotificationWithName:(NSString *)noticationName object:(id)object;
/** 发送一个通知 */
+ (void)postNotificationWithName:(NSString *)noticationName;
/** 在主线程执行的任务 */
+ (void)actionWithMainQueue:(void (^)(void))action;
/** 在多线程执行的任务 */
+ (void)actionWithGlobalQueue:(void(^)(void))action;
@end
