//
//  AuthCodeButton.h
//  XueWen
//
//  Created by ShaJin on 2017/11/30.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AuthCodeDelegate <NSObject>



@end
@interface AuthCodeButton : UIButton
/** 是否已经发送验证码，冷却状态为已发送 */
@property (nonatomic, assign) BOOL hasSend;
/** 验证码 */
+ (instancetype)authCodeButtonWithSendBlock:(void(^)(void))sendBlock;
+ (instancetype)authCodeButtonWithTarget:(id)target SendAction:(SEL)action;
- (void)startCountdown;
@end
