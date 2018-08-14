//
//  ClassesSelectLessionView.h
//  XueWen
//
//  Created by ShaJin on 2017/11/15.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassesSelectViewDelegate.h"
@interface ClassesSelectLessionView : UIView

@property (nonatomic, weak) id<ClassesSelectViewDelegate> delegate;
- (instancetype)initWithSelect:(NSString *)select;

@end
