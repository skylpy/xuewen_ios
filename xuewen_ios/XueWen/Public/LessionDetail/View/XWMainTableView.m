//
//  XWMainTableView.m
//  XueWen
//
//  Created by aaron on 2018/7/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWMainTableView.h"

@implementation XWMainTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
