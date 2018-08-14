//
//  UIView+FrameView.h
//  happyselling
//
//  Created by ShaJin on 2017/10/28.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameView)
/** 控件的X坐标 */
@property (nonatomic, assign) CGFloat frameX;
/** 控件的Y坐标 */
@property (nonatomic, assign) CGFloat frameY;
/** 控件的宽度 */
@property (nonatomic, assign) CGFloat frameW;
/** 控件的高度 */
@property (nonatomic, assign) CGFloat frameH;
@end
