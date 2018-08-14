//
//  MyClassesViewController.h
//  XueWen
//
//  Created by ShaJin on 2017/11/16.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWListViewController.h"
typedef enum : NSUInteger {
    kMyClasses = 0,         // 我的课程
    kLearningClasses,       // 在学课程
    kCompanyClasses,        // 企业课程
} MyClassesViewType;
@interface MyClassesViewController : XWListViewController

- (instancetype)initWithType:(MyClassesViewType)type;

@end
