//
//  XWCommentViewController.h
//  XueWen
//
//  Created by ShaJin on 2017/11/29.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
// 课程详情的写笔记界面
#import "XWBaseViewController.h"

@interface XWCommentViewController : XWBaseViewController
- (instancetype)initWithCourseID:(NSString *)courseID sendBlock:(void(^)(void))sendBlock;
- (instancetype)initWithCourseID:(NSString *)courseID comment:(BOOL)comment sendBlock:(void (^)(NSString *content,NSInteger status))sendBlock;
@end
