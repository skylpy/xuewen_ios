//
//  XWNoteInputView.h
//  XueWen
//
//  Created by Karron Su on 2018/5/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWNoteInputView : UIView

@property (nonatomic, assign) BOOL isNotes;
@property (nonatomic, strong) HSTextView *textView;
@property (nonatomic, copy) void (^SendText)(NSString *sendText);
@property (nonatomic, copy) void (^TapAction)(BOOL isNotes);
@property (nonatomic, copy) void (^TapBecomeAction)(BOOL isNotes);

- (void)clear;

@end
