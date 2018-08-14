//
//  XWShareView.h
//  XueWen
//
//  Created by Karron Su on 2018/6/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XWShareViewDelegate <NSObject>

/** 分享事件*/
- (void)didSelectShareItemAtIndex:(NSInteger)index;


@end

@interface XWShareView : UIView

@property (nonatomic, weak) id<XWShareViewDelegate> delegate;

@end
