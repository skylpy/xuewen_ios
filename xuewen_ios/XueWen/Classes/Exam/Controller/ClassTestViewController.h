//
//  ClassTestViewController.h
//  XueWen
//
//  Created by ShaJin on 2018/1/8.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 新的课程测试界面，用于替换ExamViewController
#import "XWBaseViewController.h"
@class QuestionsModel;
@interface ClassTestViewController : XWBaseViewController

- (instancetype)initWithQuestions:(NSArray<QuestionsModel *> *)questions;

@end
