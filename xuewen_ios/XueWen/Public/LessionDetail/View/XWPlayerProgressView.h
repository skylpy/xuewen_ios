//
//  XWPlayerProgressView.h
//  XueWen
//
//  Created by ShaJin on 2018/1/3.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XWPlayerProgressDelegate <NSObject>
/** 正在滑动 0~1 */
- (void)slidingWithProgress:(CGFloat)progress;
/** 设置进度0~1 */
- (void)setProgress:(CGFloat)progress;

@end
@interface XWPlayerProgressView : UIView
@property (nonatomic, weak) id<XWPlayerProgressDelegate> delegate;
/** 缓冲进度0~1 */
@property (nonatomic, assign) CGFloat bufferProgress;
/** 播放进度0~1 */
@property (nonatomic, assign) CGFloat playProgress;

@end
