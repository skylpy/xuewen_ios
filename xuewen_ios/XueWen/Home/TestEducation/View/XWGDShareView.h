//
//  XWGDShareView.h
//  XueWen
//
//  Created by aaron on 2018/10/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XWGDShareViewDelegate <NSObject>

/** 分享事件*/
- (void)didSelectShareItemAtIndex:(NSInteger)index;


@end

@interface XWGDShareView : UIView

@property (nonatomic, weak) id<XWGDShareViewDelegate> delegate;

@property (nonatomic, copy) void (^codeClick)(void);

@end

NS_ASSUME_NONNULL_END
