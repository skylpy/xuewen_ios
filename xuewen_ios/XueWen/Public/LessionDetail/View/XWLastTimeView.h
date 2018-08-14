//
//  XWLastTimeView.h
//  XueWen
//
//  Created by Karron Su on 2018/5/22.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XWLastTimeViewDelegate <NSObject>

- (void)continueBtnAction;

@end

@interface XWLastTimeView : UIView

@property (nonatomic, strong) NSString *lastTime;

@property (nonatomic, weak) id<XWLastTimeViewDelegate> delegate;

@end
