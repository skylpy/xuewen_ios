//
//  LessionDetailDelegate.h
//  XueWen
//
//  Created by ShaJin on 2018/1/10.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LessionDetailDelegate <NSObject>
- (void)buyAction;

- (void)learnAction:(UIButton *)sender;

/** 播放视频 */
- (void)playAtIndex:(int)index;

/** 获取基础高度，就是当前视图（0，0）的点在屏幕上的高度 */
- (CGFloat)getBasicHeight;

@end
