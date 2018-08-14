//
//  BaseAlertView.h
//  XueWen
//
//  Created by ShaJin on 2017/11/17.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    kAnimationCenter = 0,   // 原位置从小变大
    kAnimationBottom,       // 从屏幕下方飞入
    kAnimationRight,        // 从屏幕右侧飞入
} AnimationType;
@interface BaseAlertView : UIView
/** 点击菜单外消失  Default is YES */
@property (nonatomic, assign) BOOL dismissOnTouchOutside;
/** 圆角半径 Default is 5.0 */
@property (nonatomic, assign) CGFloat cornerRadius;
/** 是否显示阴影 Default is YES */
@property (nonatomic, assign , getter=isShadowShowing) BOOL isShowShadow;
/** 出现方式 */
@property (nonatomic, assign) AnimationType animationType;
/** 动画时间 */
@property (nonatomic, assign) CGFloat duration;
/** 出现 */
- (void)show;
/** 消失 */
- (void)dismiss;
@end
