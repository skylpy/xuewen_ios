//
//  BottomAlertView.h
//  XueWen
//
//  Created by ShaJin on 2018/1/18.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "BaseAlertView.h"
typedef void(^ActionBlock)(void);
/** 底部弹窗 */
@interface BottomAlertView : BaseAlertView
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) NSAttributedString *titleAttributed;
+ (instancetype)alertWithMessage:(NSString *)message firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle firstAction:(ActionBlock)firstAction secondAction:(ActionBlock)secondAction;
@end
