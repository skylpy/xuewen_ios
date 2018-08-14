//
//  XWExamResultShareView.h
//  XueWen
//
//  Created by Karron Su on 2018/6/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XWExamResultShareViewDelegate <NSObject>

/** 分享事件*/
- (void)didSelectShareItemAtIndex:(NSInteger)index;


@end

@interface XWExamResultShareView : UIView

@property (nonatomic, weak) id<XWExamResultShareViewDelegate> delegate;


@end
