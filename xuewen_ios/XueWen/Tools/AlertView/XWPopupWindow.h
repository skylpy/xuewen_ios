//
//  XWPopupWindow.h
//  XueWen
//
//  Created by ShaJin on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "BaseAlertView.h"

@interface XWPopupWindow : BaseAlertView
/** 通用弹窗 只有一个按钮 */
+ (void)popupWindowsWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle  buttonBlock:(void(^)(void))buttonBlock;
// 通用弹窗 两个按钮 系统弹窗
/*
 ---------------------------
 丨        title           丨
 丨       message          丨
 丨                        丨
 丨leftTitle    rightTtitle丨
 丨                        丨
 ---------------------------
 */
+ (void)popupWindowsWithTitle:(NSString *)title message:(NSString *)message leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftBlock:(void(^)(void))leftBlock rightBlock:(void(^)(void))rightBlock;
@end
